//
//  NTTaskController.m
//  CocoatechCore
//
//  Created by sgehrman on Sun May 13 2001.
//  Copyright (c) 2001 CocoaTech. All rights reserved.
//

#import "NTTaskController.h"
#import "NSThread-NTExtensions.h"

@interface NTTaskController ()
- (void)sendOutputToDelegate;
- (BOOL)processOutput:(NSData*)output;
- (void)setNotifications;
- (void)finished;

@property (weak) id<NTTaskControllerDelegateProtocol> delegate;
@end

@implementation NTTaskController

@synthesize outputCache;

+ (NTTaskController*)task:(id<NTTaskControllerDelegateProtocol>)delegate;
{
	NTTaskController* result = [[NTTaskController alloc] initWithTaskDelegate:delegate];
	
	return result;
}

// tools like "tar" send their progress info through stderr, gnutar send output through stdout
- (id)initWithTaskDelegate:(id<NTTaskControllerDelegateProtocol>)delegate;
{
    self = [super init];
	
    [self setDelegate:delegate];  // no retain
	
    _task = [[NSTask alloc] init];
    self.outputCache = [NSMutableData data];
	mv_modes = [[NSArray alloc] initWithObjects:NSDefaultRunLoopMode, NSModalPanelRunLoopMode, NSEventTrackingRunLoopMode, nil];
	
    _outputPipe = [[NSPipe alloc] init];
    _errorPipe = [[NSPipe alloc] init];
    _inputPipe = [[NSPipe alloc] init];
	
    [_task setStandardInput:_inputPipe];
    [_task setStandardOutput:_outputPipe];
    [_task setStandardError:_errorPipe];
	
    _result = YES;
	
    return self;
}

//---------------------------------------------------------- 
// dealloc
//---------------------------------------------------------- 
- (void)dealloc;
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if ([self delegate])
		[[NSException exceptionWithName:@"NTTaskController" reason:@"Must call clearDelegate!" userInfo:nil] raise];
	
    [self stopTask];
	
    self.outputCache = nil;
}

- (void)clearDelegate;
{
	[self setDelegate:nil];
}

- (void)runTask:(BOOL)sync toolPath:(NSString*)toolPath directory:(NSString*)currentDirectory withArgs:(NSArray*)args
{
	[self runTask:sync toolPath:toolPath directory:currentDirectory withArgs:args input:nil];
}

- (void)runTask:(BOOL)sync toolPath:(NSString*)toolPath directory:(NSString*)currentDirectory withArgs:(NSArray*)args input:(NSData*)input;
{
	// the delegate can delete us while we are sending it the finished method
    __strong id aSelf = self;
	
	NS_DURING;
	{
		BOOL success = NO;
		
		if (currentDirectory)
			[_task setCurrentDirectoryPath: currentDirectory];
		
		[_task setLaunchPath:toolPath];
		[_task setArguments:args];
		
		[self setNotifications];
		
		if ([self readTilEndOfFile])
		{
			[[_outputPipe fileHandleForReading] readToEndOfFileInBackgroundAndNotifyForModes:mv_modes];
			[[_errorPipe fileHandleForReading] readToEndOfFileInBackgroundAndNotifyForModes:mv_modes];
		}
		else
		{		
			[[_outputPipe fileHandleForReading] readInBackgroundAndNotifyForModes:mv_modes];
			[[_errorPipe fileHandleForReading] readInBackgroundAndNotifyForModes:mv_modes];
		}
		
		NS_DURING
			[_task launch];
			success = YES;
		NS_HANDLER
			;
		NS_ENDHANDLER
		
		if (success)
		{
			if (input)
			{
				// feed the running task our input
				[[_inputPipe fileHandleForWriting] writeData:input];
				[[_inputPipe fileHandleForWriting] closeFile];
			}
			
			if (sync)
			{
				// [_task waitUntilExit];
				// if (!_taskDone)
				//	[self processOutput:[[_outputPipe fileHandleForReading] readDataToEndOfFile]];
				
				// -[NSTask waitUntilExit] doesn't wait until all the notifications have been sent, lost data that was in transit
				// at least that was my theory.  Seems to make sense
				if (!_taskDone)
				{
					double resolution = .25;
					BOOL isRunning;
					NSDate* next;
					
					do {
						next = [NSDate dateWithTimeIntervalSinceNow:resolution]; 
						
						isRunning = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
															 beforeDate:next];
					} while (isRunning && !_taskDone);
				}
			}
		}
	}
	NS_HANDLER;
	NS_ENDHANDLER;
	
	(void)aSelf;
}

+ (BOOL)synchronousTask:(id<NTTaskControllerDelegateProtocol>)delegate toolPath:(NSString*)toolPath directory:(NSString*)currentDirectory withArgs:(NSArray*)args;
{
    BOOL result=NO;
	// we need this wacky pool here, otherwise we run out of pipes, the pipes are internally autoreleased
    @autoreleasepool {
	
	NS_DURING
	{
		NTTaskController* task = [[NTTaskController alloc] initWithTaskDelegate:delegate];
		
		[task runTask:YES toolPath:toolPath directory:currentDirectory withArgs:args];
		
		result = [task taskResult];
		
		[task clearDelegate];
	}
	NS_HANDLER;
	NS_ENDHANDLER;
	
    }
	
    return result;
}

@synthesize taskResult=_result;
@synthesize readTilEndOfFile=mv_readTilEndOfFile;

- (BOOL)isRunning
{
    return [_task isRunning];
}

- (void)stopTask;
{
    if ([_task isRunning])
        [_task terminate];
}

@synthesize bufferOutputToDelegateWithDelay=_bufferOutputToDelegateWithDelay;

- (BOOL)processOutput:(NSData*)output;
{
    BOOL result = YES;
	
    if ([output length])
    {
		[self.outputCache appendData:output];
		
		if (_bufferOutputToDelegateWithDelay)
		{
			// this delay is done for speed reasons.  A task like 'locate' can produce lots of output. We don't want to send every line one at a time
			if (!_delayedOutputProcessing)
			{
				_delayedOutputProcessing = YES;
				[self performSelector:@selector(processOutputAfterDelay:) withObject:nil afterDelay:.1 inModes:[NSThread defaultRunLoopModes]];
			}
		}
		else 
			[self sendOutputToDelegate];
	}
    else 
	{
		result = NO;
		
		// no data means we are done
		[self finished];
	}
	
    return result;
}

- (void)sendOutputToDelegate;
{
    if ([self.outputCache length])
    {
		[[self delegate] task_handleTask:self output:self.outputCache];
		
        // reset output cache
		self.outputCache = [NSMutableData data];
    }
}

- (void)processOutputAfterDelay:(id)object;
{
    if (_delayedOutputProcessing)
    {
        _delayedOutputProcessing = NO;
        [self sendOutputToDelegate];
    }
}

- (void)setNotifications;
{
	if ([self readTilEndOfFile])
	{
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(taskOutputAvailable:)
													 name:NSFileHandleReadToEndOfFileCompletionNotification
												   object:[_outputPipe fileHandleForReading]];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(taskErrorsAvailable:)
													 name:NSFileHandleReadToEndOfFileCompletionNotification
												   object:[_errorPipe fileHandleForReading]];		
	}
	else
	{
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(taskOutputAvailable:)
													 name:NSFileHandleReadCompletionNotification
												   object:[_outputPipe fileHandleForReading]];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(taskErrorsAvailable:)
													 name:NSFileHandleReadCompletionNotification
												   object:[_errorPipe fileHandleForReading]];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(taskDidTerminate:)
												 name:NSTaskDidTerminateNotification
											   object:_task];	
}	

- (void)finished;
{
	// flush out any cached output
	[self sendOutputToDelegate];
	
	_taskDone = YES;
	
	[[self delegate] task_handleTask:self finished:[NSNumber numberWithBool:_result]];
}

//---------------------------------------------------------- 
//  delegate 
//---------------------------------------------------------- 
@synthesize delegate=mDelegate;

- (void)taskOutputAvailable:(NSNotification*)note
{
	// the delegate can delete us while we are sending it the finished method
    __strong id aSelf = self;

	NS_DURING;
	{
		NSData* output = [[note userInfo] objectForKey:NSFileHandleNotificationDataItem];
		
		BOOL gotData = [aSelf processOutput:output];
		if (gotData)
		{
			if (![aSelf readTilEndOfFile])
				[[note object] readInBackgroundAndNotifyForModes:mv_modes];
			else	
				[aSelf finished];
		}
	}
	NS_HANDLER;
	NS_ENDHANDLER;
	
	(void)aSelf;
}

- (void)taskErrorsAvailable:(NSNotification*)note
{
    NSData* output = [[note userInfo]objectForKey:NSFileHandleNotificationDataItem];
	
    if ([output length])
    {
		[[self delegate] task_handleTask:self errors:output];
        
        [[note object] readInBackgroundAndNotifyForModes:mv_modes];
    }
}

- (void)taskDidTerminate:(NSNotification*)note
{
    _result = ([_task terminationStatus] == 0);
}

@end

