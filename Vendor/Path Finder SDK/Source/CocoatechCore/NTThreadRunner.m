//
//  NTThreadRunner.m
//  CocoatechCore
//
//  Created by Steve Gehrman on 8/28/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NTThreadRunner.h"
#import "NTThreadHelper.h"
#import "NSThread-NTExtensions.h"

@interface NTThreadRunnerParam ()
@property (readwrite, weak) NTThreadRunner *runner;
@end

@interface NTThreadRunner ()
@property (weak) id<NTThreadRunnerDelegateProtocol> delegate;
@property (readwrite, retain) NTThreadHelper *threadHelper;

@property float priority;

@property (nonatomic, readwrite, retain) NTThreadRunnerParam *param;

@end

@implementation NTThreadRunner

- (void)dealloc;
{
	if ([self delegate])
		[NSException raise:@"must call clearDelegate" format:@"%@", NSStringFromClass([self class])];
	
	[self setThreadHelper:nil];
	[self setParam:nil];
}

- (void)clearDelegate; // also kills the thread
{
	if (![[self threadHelper] complete])
		[mv_threadHelper setKilled:YES];
	
	[self setDelegate:nil];
	
	// resume incase the thread is paused
	[[self threadHelper] resume];
}

@synthesize threadHelper=mv_threadHelper;

+ (NTThreadRunner*)thread:(NTThreadRunnerParam*)param
				 priority:(float)priority
				 delegate:(id<NTThreadRunnerDelegateProtocol>)delegate;
{
	NTThreadRunner* result = [[NTThreadRunner alloc] init];
	
	[result setDelegate:delegate];
	[result setPriority:priority];
	[result setThreadHelper:[NTThreadHelper threadHelper]];
	[result setParam:param];
		
	[NSThread detachNewThreadSelector:@selector(threadProc:) toTarget:result withObject:param];
	
	return result;
}

//---------------------------------------------------------- 
//  param 
//---------------------------------------------------------- 
@synthesize param=mv_param;

- (void)threadProc:(NTThreadRunnerParam*)param;
{
    @autoreleasepool {
	
	[NSThread setThreadPriority:[self priority]];
	
	if ([param doThreadProc])
		[self performSelectorOnMainThread:@selector(mainThreadCallback) withObject:nil];
	
	[[self threadHelper] setComplete:YES];

    }
}

- (void)mainThreadCallback;
{
	[[self delegate] threadRunner_complete:self];
}

- (void)setParam:(NTThreadRunnerParam *)theParam
{
    if (mv_param != theParam) {
		[mv_param setRunner:nil];
		
        mv_param = theParam;
		
		[mv_param setRunner:self];
    }
}

//---------------------------------------------------------- 
//  delegate 
//---------------------------------------------------------- 
@synthesize delegate=mv_delegate;

//---------------------------------------------------------- 
//  priority 
//---------------------------------------------------------- 
@synthesize priority=mv_priority;

@end

// ------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------

@implementation NTThreadRunnerParam 

//---------------------------------------------------------- 
//  threadRunner 
//---------------------------------------------------------- 
@synthesize runner=mv_runner;

//---------------------------------------------------------- 
//  threadRunner 
//---------------------------------------------------------- 
- (NTThreadHelper *)helper
{
    return [[self runner] threadHelper]; 
}

- (id<NTThreadRunnerDelegateProtocol>)delegate;
{
	return [[self runner] delegate];
}

// must subclass to do work
- (BOOL)doThreadProc;
{
	return NO;
}

@end
