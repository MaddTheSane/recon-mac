//
//  NTThreadRunner.h
//  CocoatechCore
//
//  Created by Steve Gehrman on 8/28/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NTThreadRunner, NTThreadRunnerParam, NTThreadHelper;

@protocol NTThreadRunnerDelegateProtocol <NSObject>
//! called on main thread
- (void)threadRunner_complete:(NTThreadRunner*)threadRunner;
@end

@interface NTThreadRunner : NSObject
{
	__weak id<NTThreadRunnerDelegateProtocol> mv_delegate;
	
	float mv_priority;
	
	NTThreadRunnerParam* mv_param;
	NTThreadHelper* mv_threadHelper;
}

+ (NTThreadRunner*)thread:(NTThreadRunnerParam*)param
				 priority:(float)priority
				 delegate:(id<NTThreadRunnerDelegateProtocol>)delegate;  // state is kNormalThreadState

- (void)clearDelegate; //!< also kills the thread if still running

@property (nonatomic, readonly, retain) NTThreadRunnerParam *param;
@property (readonly, retain) NTThreadHelper *threadHelper;

@end

// -------------------------------------------------------------------------

@interface NTThreadRunnerParam : NSObject
{
	__weak NTThreadRunner* mv_runner;
}

//! must subclass to do work
- (BOOL)doThreadProc;

@property (readonly, weak) NTThreadRunner *runner;
@property (readonly, assign) NTThreadHelper *helper;

@property (readonly, assign) id<NTThreadRunnerDelegateProtocol> delegate;

@end
