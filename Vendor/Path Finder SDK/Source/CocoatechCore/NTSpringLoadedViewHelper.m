//
//  NTSpringLoadedViewHelper.m
//  CocoatechCore
//
//  Created by Steve Gehrman on 10/15/06.
//  Copyright 2006 Cocoatech. All rights reserved.
//

#import "NTSpringLoadedViewHelper.h"
#import "NSObject-NTExtensions.h"
#import "NTSpaceKeyPoll.h"

@interface NTSpringLoadedViewHelper (Protocols) <NTSpaceKeyPollDelegate>
@end

@interface NTSpringLoadedViewHelper ()
@property (assign) id<NTSpringLoadedViewHelperDelegateProtocol> delegate;
- (void)performSpringAction;

@property BOOL springLoadedRunning;
- (void)springLoadedSelector:(NSNumber*)springNumber;
@end

@implementation NTSpringLoadedViewHelper

@synthesize spaceKeyPoll;

+ (NTSpringLoadedViewHelper*)helper:(id<NTSpringLoadedViewHelperDelegateProtocol>)delegate;
{
	NTSpringLoadedViewHelper* helper = [[NTSpringLoadedViewHelper alloc] init];
	
	[helper setDelegate:delegate];
	helper.spaceKeyPoll = [NTSpaceKeyPoll poll:helper];

	return helper;
}

//---------------------------------------------------------- 
// dealloc
//---------------------------------------------------------- 
- (void)dealloc
{
	if ([self delegate])
		[NSException raise:@"must call clearDelegate" format:@"%@", NSStringFromClass([self class])];

	self.spaceKeyPoll.delegate = nil;
	self.spaceKeyPoll = nil;
}

- (void)clearDelegate;
{
	[self setDelegate:nil];
}

- (void)startSpringLoadedAction;
{
	if (![self springLoadedRunning])
	{
		[self setSpringLoadedRunning:YES];
		
		[self.spaceKeyPoll start];

		[self performSelector:@selector(springLoadedSelector:) withObject:@0 afterDelay:.25 inModes:@[NSDefaultRunLoopMode, NSEventTrackingRunLoopMode, NSModalPanelRunLoopMode]];
	}
}

- (void)cancelSpringLoadedAction;
{
	if ([self springLoadedRunning])
	{
		[self setSpringLoadedRunning:NO];
		
		[self.spaceKeyPoll stop];
		
		[self safeCancelPreviousPerformRequests];
	}
}

- (void)springLoadedSelector:(NSNumber*)springNumber;
{
	if ([self springLoadedRunning])
	{
		int stage = [springNumber intValue];
		BOOL doSpringButton = (stage == 6);
				
		if (doSpringButton)
			[self performSpringAction];
		else
		{
			if (stage >= 4)
			{
				NSView* view = [[self delegate] springLoadedHelper_toggleState:self];
				
				[view setNeedsDisplay:YES];
				[view displayIfNeeded];
				[[view window] flushWindow];
			}
			
			[self performSelector:@selector(springLoadedSelector:) withObject:[NSNumber numberWithInt:stage+1] afterDelay:.25 inModes:[NSArray arrayWithObjects:NSDefaultRunLoopMode, NSEventTrackingRunLoopMode, NSModalPanelRunLoopMode , nil]];
		}
	}
}

//---------------------------------------------------------- 
//  delegate 
//---------------------------------------------------------- 
@synthesize delegate=mDelegate;

//---------------------------------------------------------- 
//  springLoadedRunning 
//---------------------------------------------------------- 
@synthesize springLoadedRunning=mSpringLoadedRunning;

- (void)performSpringAction;
{
	[[self delegate] springLoadedHelper_hasSprung:self];
	[self cancelSpringLoadedAction];
}

@end

@implementation NTSpringLoadedViewHelper (Protocols) 

// <NTSpaceKeyPollDelegate>

- (void)spaceKeyDown:(NTSpaceKeyPoll*)spaceKeyPoll
{
	[self performSpringAction];
}

@end



