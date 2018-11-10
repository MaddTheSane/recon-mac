// -*- mode:objc -*-
// $Id: PTYTask.m,v 1.42 2007/01/12 23:15:45 yfabian Exp $
//
/*
 **  PTYTask.m
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

#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <util.h>
#import <sys/ioctl.h>
#import <sys/types.h>
#import <sys/wait.h>
#import <sys/time.h>

#import "PTYTask.h"

@implementation PTYTask

#define CTRLKEY(c)   ((c)-'A'+1)

static void setup_tty_param(struct termios *term,
							struct winsize *win,
							int width,
							int height)
{
    memset(term, 0, sizeof(struct termios));
    memset(win, 0, sizeof(struct winsize));
	
    term->c_iflag = ICRNL | IXON | IXANY | IMAXBEL | BRKINT;
    term->c_oflag = OPOST | ONLCR;
    term->c_cflag = CREAD | CS8 | HUPCL;
    term->c_lflag = ICANON | ISIG | IEXTEN | ECHO | ECHOE | ECHOK | ECHOKE | ECHOCTL;
	
    term->c_cc[VEOF]      = CTRLKEY('D');
    term->c_cc[VEOL]      = -1;
    term->c_cc[VEOL2]     = -1;
    term->c_cc[VERASE]    = 0x7f;	// DEL
    term->c_cc[VWERASE]   = CTRLKEY('W');
    term->c_cc[VKILL]     = CTRLKEY('U');
    term->c_cc[VREPRINT]  = CTRLKEY('R');
    term->c_cc[VINTR]     = CTRLKEY('C');
    term->c_cc[VQUIT]     = 0x1c;	// Control+backslash
    term->c_cc[VSUSP]     = CTRLKEY('Z');
    term->c_cc[VDSUSP]    = CTRLKEY('Y');
    term->c_cc[VSTART]    = CTRLKEY('Q');
    term->c_cc[VSTOP]     = CTRLKEY('S');
    term->c_cc[VLNEXT]    = -1;
    term->c_cc[VDISCARD]  = -1;
    term->c_cc[VMIN]      = 1;
    term->c_cc[VTIME]     = 0;
    term->c_cc[VSTATUS]   = -1;
	
    term->c_ispeed = B38400;
    term->c_ospeed = B38400;
	
    win->ws_row = height;
    win->ws_col = width;
    win->ws_xpixel = 0;
    win->ws_ypixel = 0;
}

static ssize_t writep(int fds, char *buf, size_t len)
{
    ssize_t wrtlen = len;
    ssize_t result = 0;
    ssize_t sts = 0;
    char *tmpPtr = buf;
    ssize_t chunk;
    struct timeval tv;
    fd_set wfds,efds;
	
    while (wrtlen > 0) {
		
		FD_ZERO(&wfds);
		FD_ZERO(&efds);
		FD_SET(fds, &wfds);
		FD_SET(fds, &efds);	
		
		tv.tv_sec = 0;
		tv.tv_usec = 100000;
		
		sts = select(fds + 1, NULL, &wfds, &efds, &tv);
		
		if (sts == 0) {
			NSLog(@"Write timeout!");
			break;
		}	
		
		if (wrtlen > 1024)
			chunk = 1024;
		else
			chunk = wrtlen;
		sts = write(fds, tmpPtr, wrtlen);
		if (sts <= 0)
			break;
		
		wrtlen -= sts;
		tmpPtr += sts;
		
    }
    if (sts <= 0)
		result = sts;
    else
		result = len;
	
    return result;
}

+ (void)_processReadThread:(PTYTask *)boss
{
    BOOL exitf = NO;
    ssize_t sts;
	char readbuf[4096];
	fd_set rfds,efds;
	
    /*
	 data receive loop
	 */
    while (exitf == NO)
	@autoreleasepool {
		
		FD_ZERO(&rfds);
		FD_ZERO(&efds);
		
		FD_SET(boss->FILDES, &rfds);
		FD_SET(boss->FILDES, &efds);
		
		sts = select(boss->FILDES + 1, &rfds, NULL, &efds, NULL);
		
		if (sts < 0) {
			break;
		}
		else if (FD_ISSET(boss->FILDES, &efds)) {
			sts = read(boss->FILDES, readbuf, 1);
#if 0 // debug
			fprintf(stderr, "read except:%d byte ", sts);
			if (readbuf[0] & TIOCPKT_FLUSHREAD)
				fprintf(stderr, "TIOCPKT_FLUSHREAD ");
			if (readbuf[0] & TIOCPKT_FLUSHWRITE)
				fprintf(stderr, "TIOCPKT_FLUSHWRITE ");
			if (readbuf[0] & TIOCPKT_STOP)
				fprintf(stderr, "TIOCPKT_STOP ");
			if (readbuf[0] & TIOCPKT_START)
				fprintf(stderr, "TIOCPKT_START ");
			if (readbuf[0] & TIOCPKT_DOSTOP)
				fprintf(stderr, "TIOCPKT_DOSTOP ");
			if (readbuf[0] & TIOCPKT_NOSTOP)
				fprintf(stderr, "TIOCPKT_NOSTOP ");
			fprintf(stderr, "\n");
#endif
			if (sts == 0) {
				// session close
				exitf = YES;
			}
		}
		else if (FD_ISSET(boss->FILDES, &rfds)) {
			sts = read(boss->FILDES, readbuf, sizeof(readbuf));
			
            if (sts == 0) 
			{
				exitf = YES;
            }
			
            if (sts > 1) {
                [boss setHasOutput: YES];
				[boss readTask:readbuf+1 length:sts-1];
            }
            else
                [boss setHasOutput: NO];
			
		}
		
    }
	
	if (sts >= 0) 
        [boss brokenPipe];
	
    MPSignalSemaphore(boss->threadEndSemaphore);
	
	[NSThread exit];
}

- (id)init
{
	if (self = [super init]) {
	
    PID = (pid_t)-1;
    STATUS = 0;
    DELEGATEOBJECT = nil;
    FILDES = -1;
    TTY = nil;
    LOG_PATH = nil;
    LOG_HANDLE = nil;
    hasOutput = NO;
    
    // allocate a semaphore to coordinate with thread
	MPCreateBinarySemaphore(&threadEndSemaphore);
	}
	
    return self;
}

- (void)dealloc
{
    if (PID > 0)
		kill(PID, SIGKILL);
    
	if (FILDES >= 0)
		close(FILDES);

    MPWaitOnSemaphore(threadEndSemaphore, kDurationForever);
    MPDeleteSemaphore(threadEndSemaphore);
}

- (void)launchWithPath:(NSString *)progpath
			 arguments:(NSArray *)args
		   environment:(NSDictionary *)env
				 width:(int)width
				height:(int)height
{
    struct termios term;
    struct winsize win;
    char ttyname[PATH_MAX];
    int sts;
    int one = 1;
	
    PATH = [progpath copy];
	
    setup_tty_param(&term, &win, width, height);
    PID = forkpty(&FILDES, ttyname, &term, &win);
    if (PID == (pid_t)0) {
		const char *path = [[progpath stringByStandardizingPath] UTF8String];
		NSInteger max = args == nil ? 0: [args count];
		const char *argv[max + 2];
		
		argv[0] = path;
		if (args != nil) {
            int i;
			for (i = 0; i < max; ++i)
				argv[i + 1] = [[args objectAtIndex:i] UTF8String];
		}
		argv[max + 1] = NULL;
		
		// set the PATH to something sensible since the inherited path seems to have the user's home directory.
		setenv("PATH", "/usr/bin:/bin:/usr/sbin:/sbin", 1);
		
		if (env != nil ) {
			NSArray *keys = [env allKeys];
			NSInteger i, max = [keys count];
			for (i = 0; i < max; ++i) {
				NSString *key, *value;
				key = [keys objectAtIndex:i];
				value = [env objectForKey:key];
				if (key != nil && value != nil) 
					setenv([key UTF8String], [value UTF8String], 1);
			}
		}
        chdir([[[env objectForKey:@"PWD"] stringByExpandingTildeInPath] UTF8String]);
		sts = execvp(path, (char * const *) argv);
		
		/*
		 exec error
		 */
		fprintf(stdout, "## exec failed ##\n");
		fprintf(stdout, "%s %s\n", path, strerror(errno));
		
		sleep(1);
		_exit(-1);
    }
    else if (PID < (pid_t)0) {
		NSLog(@"%@ %s", progpath, strerror(errno));
    }
	
    sts = ioctl(FILDES, TIOCPKT, &one);
    NSParameterAssert(sts >= 0);
	
    TTY = [NSString stringWithUTF8String:ttyname];
    NSParameterAssert(TTY != nil);
	
	// spawn a thread to do the read task
    [NSThread detachNewThreadSelector:@selector(_processReadThread:)
            	             toTarget: [PTYTask class]
						   withObject:self];
}

@synthesize hasOutput;

- (void)setHasOutput: (BOOL) flag
{
    hasOutput = flag;
    if ([self firstOutput] == NO)
		[self setFirstOutput: flag];
}

@synthesize firstOutput;
@synthesize delegate=DELEGATEOBJECT;

- (void)doIdleTasks
{
    if ([DELEGATEOBJECT respondsToSelector:@selector(doIdleTasks)]) {
		[DELEGATEOBJECT doIdleTasks];
    }
}

- (void)readTask:(char *)buf length:(NSInteger)length
{
	if ([self logging])
	{
		NSData *data = [[NSData alloc] initWithBytes: buf length: length];
		[LOG_HANDLE writeData:data];
	}
	
	// forward the data to our delegate
	[DELEGATEOBJECT readTask:buf length:length];
}

- (void)writeTask:(NSData *)data
{
    const void *datap = [data bytes];
    size_t len = [data length];
    int sts;
    	
    sts = writep(FILDES, (char *)datap, len);
    if (sts < 0 ) {
		NSLog(@"%s(%d): writep() %s", __FILE__, __LINE__, strerror(errno));
    }
}

- (void)brokenPipe
{
    if ([DELEGATEOBJECT respondsToSelector:@selector(brokenPipe)]) {
        [DELEGATEOBJECT brokenPipe];
    }
}

- (void)sendSignal:(int)signo
{
    if (PID >= 0)
		kill(PID, signo);
}

- (void)setWidth:(int)width height:(int)height
{
    struct winsize winsize;
	
    if (FILDES == -1)
		return;
	
    ioctl(FILDES, TIOCGWINSZ, &winsize);
	if (winsize.ws_col != width || winsize.ws_row != height) {
		winsize.ws_col = width;
		winsize.ws_row = height;
		ioctl(FILDES, TIOCSWINSZ, &winsize);
	}
}

@synthesize pid=PID;

- (int)wait
{
    if (PID >= 0) 
		waitpid(PID, &STATUS, 0);
	
    return STATUS;
}

- (void)stop
{
    [self sendSignal:SIGKILL];
	usleep(10000);
	if (FILDES >= 0)
		close(FILDES);
    [self wait];
}

@synthesize status=STATUS;
@synthesize tty=TTY;
@synthesize path=PATH;

- (BOOL)loggingStartWithPath:(NSString *)path
{
    LOG_PATH = [[path stringByStandardizingPath ] copy];
	
    LOG_HANDLE = [NSFileHandle fileHandleForWritingAtPath:LOG_PATH];
    if (LOG_HANDLE == nil) {
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm createFileAtPath:LOG_PATH
					contents:nil
				  attributes:nil];
		LOG_HANDLE = [NSFileHandle fileHandleForWritingAtPath:LOG_PATH];
    }
    [LOG_HANDLE seekToEndOfFile];
	
    return LOG_HANDLE == nil ? NO:YES;
}

- (void)loggingStop
{
    [LOG_HANDLE closeFile];
	
    LOG_PATH = nil;
    LOG_HANDLE = nil;
}

- (BOOL)logging
{
    return LOG_HANDLE == nil ? NO : YES;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"PTYTask(pid %d, fildes %d)", PID, FILDES];
}

@end
