/*
 **  PTYSession.h
 **
 **  Copyright (c) 2002, 2003
 **
 **  Author: Fabian, Ujwal S. Setlur
 **
 **  Project: iTerm
 **
 **  Description: Implements the model class for a terminal session.
 **
 */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include <sys/time.h>

@class PTYTask;
@class PTYTextView;
@class PTYScrollView;
@class VT100Screen;
@class VT100Terminal;
@class PreferencePanel;
@class ITTerminalView;
@class iTermController;

@interface PTYSession : NSResponder
{        
    // Owning tab view item
    __weak NSTabViewItem *tabViewItem;
	
    // tty device
    NSString *tty;
    
    __weak ITTerminalView *parent;  // parent controller
    NSString *name;
	NSString *defaultName;
    NSString *windowTitle;
	
    PTYTask *SHELL;
    VT100Terminal *TERMINAL;
    NSString *TERM_VALUE;
    VT100Screen   *SCREEN;
    BOOL EXIT;
    PTYScrollView *mScrollView;
    PTYTextView *mTextView;
    
    // anti-idle
    BOOL antiIdle;
    char ai_code;

    BOOL autoClose;
    BOOL doubleWidth;
	BOOL xtermMouseReporting;
    BOOL bell;

    NSDictionary *addressBookEntry;
    
    // Status reporting
    struct timeval lastInput, lastOutput, lastUpdate, lastBlink;
    int objectCount;
	NSImage *icon;
	BOOL isProcessing;
    BOOL newOutput;
		
	// semaphore to coordinate updating UI
	MPSemaphoreID	updateSemaphore;
	
	// update timer stuff
	NSTimer *updateTimer;
	unsigned int updateCount;
}

// Session specific methods
- (void)initScreen: (NSRect) aRect width:(int)width height:(int) height;
- (void)startProgram:(NSString *)program
	   arguments:(NSArray *)prog_argv
	 environment:(NSDictionary *)prog_env;
- (void)terminate;
- (BOOL) isActiveSession;

// Preferences
- (void)setPreferencesFromAddressBookEntry: (NSDictionary *) aePrefs;

// PTYTask
- (void)writeTask:(NSData *)data;
- (void)readTask:(char *)buf length:(NSInteger)length;
- (void)brokenPipe;

@property (readonly, strong) PTYTextView *textView;
@property (readonly, strong) PTYScrollView *scrollView;

// PTYTextView
- (BOOL)hasKeyMappingForEvent: (NSEvent *) event highPriority: (BOOL) priority;
- (void)keyDown:(NSEvent *)event;
- (BOOL)willHandleEvent: (NSEvent *) theEvent;
- (BOOL)handleEvent: (NSEvent *) theEvent;
- (void)insertText:(NSString *)string;
- (void)insertNewline:(id)sender;
- (void)insertTab:(id)sender;
- (void)moveUp:(id)sender;
- (void)moveDown:(id)sender;
- (void)moveLeft:(id)sender;
- (void)moveRight:(id)sender;
- (void)pageUp:(id)sender;
- (void)pageDown:(id)sender;
- (void)paste:(id)sender;
- (void)pasteString: (NSString *) aString;
- (void)deleteBackward:(id)sender;
- (void)deleteForward:(id)sender;
- (void)textViewDidChangeSelection: (NSNotification *) aNotification;
- (void)textViewResized: (NSNotification *) aNotification;
- (void)tabViewWillRedraw: (NSNotification *) aNotification;

// misc
- (void)handleOptionClick: (NSEvent *) theEvent;
- (void)doIdleTasks;

// Contextual menu
- (void)menuForEvent:(NSEvent *)theEvent menu: (NSMenu *) theMenu;

// get/set methods
@property (weak) ITTerminalView *parent;
@property (weak) NSTabViewItem *tabViewItem;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *defaultName;
- (NSString *) uniqueID;
- (void)setUniqueID: (NSString *)uniqueID;
@property (nonatomic, copy) NSString *windowTitle;
@property (strong) PTYTask *SHELL;
@property (strong) VT100Terminal *TERMINAL;
@property (nonatomic, copy) NSString *TERM_VALUE;
@property (strong) VT100Screen *SCREEN;
- (NSView *) view;
@property NSStringEncoding encoding;
@property BOOL antiIdle;
@property int antiCode;
@property BOOL autoClose;
@property BOOL doubleWidth;
@property BOOL xtermMouseReporting;
@property (copy) NSDictionary *addressBookEntry;
- (int) number;
- (int) objectCount;
- (int) realObjectCount;
- (void)setObjectCount:(int)value;
- (NSString *) tty;
- (NSString *) contents;
@property (strong) NSImage *icon;
- (NSNumber*)ttyPID;

- (void)clearBuffer;
- (void)clearScrollbackBuffer;
- (BOOL)logging;
- (void)logStart;
- (void)logStartWithPath:(NSString *)path;
- (void)logStop;
@property (strong) NSColor *foregroundColor;
@property (strong) NSColor *backgroundColor;
@property (strong) NSColor *selectionColor;
@property (strong) NSColor *boldColor;
@property (strong) NSColor *cursorColor;
@property (strong) NSColor *selectedTextColor;
@property (strong) NSColor *cursorTextColor;
@property CGFloat transparency;

@property BOOL useTransparency;

@property BOOL disableBold;
- (void)setColorTable:(int) index highLight:(BOOL)hili color:(NSColor *) c;
- (int) optionKey;

// Session status
- (void)resetStatus;
@property (readonly) BOOL exited;
- (void)setLabelAttribute;
@property (nonatomic) BOOL bell;
@property BOOL isProcessing;

- (void)runCommand: (NSString *)command;

// Display timer stuff
- (void)updateDisplay;
- (void)signalUpdateSemaphore;

enum {
	FAST_MODE, SLOW_MODE
};

- (void)setTimerMode:(int)mode;
@end

@interface PTYSession (ScriptingSupport)

// Object specifier
- (NSScriptObjectSpecifier *)objectSpecifier;
- (void)handleExecScriptCommand: (NSScriptCommand *)aCommand;
- (void)handleTerminateScriptCommand: (NSScriptCommand *)command;
- (void)handleSelectScriptCommand: (NSScriptCommand *)command;
- (void)handleWriteScriptCommand: (NSScriptCommand *)command;
@end
