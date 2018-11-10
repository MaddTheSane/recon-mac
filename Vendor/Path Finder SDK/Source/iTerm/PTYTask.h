// -*- mode:objc -*-
// $Id: PTYTask.h,v 1.10 2006/11/23 02:08:04 yfabian Exp $
/*
 **  PTYTask.h
 **
 **  Copyright (c) 2002, 2003
 **
 **  Author: Fabian, Ujwal S. Setlur
 **	     Initial code by Kiichi Kusama
 **
 **  Project: iTerm
 **
 **  Description: Implements the interface to the pty session.
 **
 */

/*
  Delegate
      readTask:
      brokenPipe
*/

#import <Foundation/Foundation.h>

@interface PTYTask : NSObject
{
    pid_t PID;
    int FILDES;
    int STATUS;
    __weak id DELEGATEOBJECT;
    NSString *TTY;
    NSString *PATH;

    NSString *LOG_PATH;
    NSFileHandle *LOG_HANDLE;
    BOOL hasOutput;
    BOOL firstOutput;

    MPSemaphoreID threadEndSemaphore;
}

- (id)init;
- (void)dealloc;

- (void)launchWithPath:(NSString *)progpath
	     arguments:(NSArray *)args
	   environment:(NSDictionary *)env
		 width:(int)width
		height:(int)height;

@property (weak) id delegate;

- (void)doIdleTasks;
- (void)readTask:(char *)buf length:(NSInteger)length;
- (void)writeTask:(NSData *)data;
- (void)brokenPipe;
- (void)sendSignal:(int)signo;
- (void)setWidth:(int)width height:(int)height;
@property (readonly) pid_t pid;
- (int)wait;
- (void)stop;
@property (readonly) int status;
@property (readonly, copy) NSString *tty;
@property (readonly, copy) NSString *path;
- (BOOL)loggingStartWithPath:(NSString *)path;
- (void)loggingStop;
@property (readonly) BOOL logging;
@property (nonatomic) BOOL hasOutput;
@property BOOL firstOutput;

- (NSString *)description;

@end
