// -*- mode:objc -*-
// $Id: ITTerminalView.h,v 1.52 2007/01/23 04:46:14 yfabian Exp $
/*
 **  ITTerminalView.h
 **
 **  Copyright (c) 2002, 2003
 **
 **  Author: Fabian, Ujwal S. Setlur
 **	     Initial code by Kiichi Kusama
 **
 **  Project: iTerm
 **
 **  Description: Session and window controller for iTerm.
 **
 */

#import <Cocoa/Cocoa.h>

@class PTYSession, PTYTabView, ITTerminalWindowController, ITMiscNibController, iTermController, PTToolbarController, PSMTabBarControl;

extern NSNotificationName const ITNumberOfSessionsDidChangeNotification;

@interface ITTerminalView : NSView <NSTabViewDelegate, NSOutlineViewDelegate>
{
    /// tab view
    PTYTabView *mTabView;
	PSMTabBarControl *mTabBarControl;
	ITMiscNibController* mNibController;

    int mWidth;
	int mHeight;
	int mCharWidth;
	int mCharHeight;
	
	CGFloat charHorizontalSpacingMultiplier;
	CGFloat charVerticalSpacingMultiplier;
	
    NSFont *FONT, *NAFONT;
	
	BOOL antiAlias;
	    
    BOOL mInitialized;
	BOOL sendInputToAllSessions;
	BOOL suppressContextualMenu;
	
	BOOL mBeingResized;
}

+ (ITTerminalView*)view:(NSDictionary *)entry;

- (void)setupSession: (PTYSession *) aSession title: (NSString *)title;
- (void)insertSession: (PTYSession *) aSession atIndex: (NSInteger) index;
- (void)closeSession: (PTYSession*) aSession;
- (IBAction)previousSession:(id)sender;
- (IBAction)nextSession:(id)sender;
- (PTYSession *) currentSession;
- (NSInteger) currentSessionIndex;
@property (copy) NSString *currentSessionName;

- (void)updateCurretSessionProfiles;

- (void)startProgram:(NSString *)program;
- (void)startProgram:(NSString *)program
           arguments:(NSArray<NSString*> *)prog_argv;
- (void)startProgram:(NSString *)program
		   arguments:(NSArray<NSString*> *)prog_argv
		 environment:(NSDictionary<NSString*,NSString*> *)prog_env;
- (void)setWindowSize;
- (void)setWindowTitle;
- (void)setWindowTitle: (NSString *)title;
- (void)setFont:(NSFont *)font nafont:(NSFont *)nafont;
- (void)setCharacterSpacingHorizontal: (CGFloat) horizontal vertical: (CGFloat) vertical;
- (void)changeFontSize: (BOOL) increase;
- (CGFloat) largerSizeForSize: (CGFloat) aSize;
- (CGFloat) smallerSizeForSize: (CGFloat) aSize;
@property (readonly, strong) NSFont *font;
@property (readonly, strong) NSFont *nafont;
@property (nonatomic) BOOL antiAlias;

- (void)setCharSizeUsingFont: (NSFont *)font;
@property int width;
@property int height;
@property int charWidth;
@property int charHeight;

@property (readonly) CGFloat charSpacingVertical;
@property (readonly) CGFloat charSpacingHorizontal;
@property BOOL useTransparency;

// controls which sessions see key events
@property (nonatomic) BOOL sendInputToAllSessions;
- (IBAction)toggleInputToAllSessions:(id)sender;
- (void)sendInputToAllSessions: (NSData *) data;

// iTermController
- (void)clearBuffer:(id)sender;
- (void)clearScrollbackBuffer:(id)sender;
- (IBAction)logStart:(id)sender;
- (IBAction)logStop:(id)sender;

// Contextual menu
- (void)menuForEvent:(NSEvent *)theEvent menu: (NSMenu *) theMenu;
@property BOOL suppressContextualMenu;
- (NSMenu *)tabView:(NSTabView *)aTabView menuForTabViewItem:(NSTabViewItem *)tabViewItem;

// NSTabView
@property (readonly, strong) PTYTabView *tabView;
@property (readonly, nonatomic, strong) PSMTabBarControl *tabBarControl;

- (void)moveTabToNewWindowContextualMenuAction:(id)sender;
- (void)setLabelColor: (NSColor *) color forTabViewItem: tabViewItem;

// Bookmarks
- (id)commandField;

- (void)runCommand:(NSString*)command;
- (NSArray*)ttyPIDs:(BOOL)currentSessionOnly;
- (BOOL)terminalIsIdle:(PTYSession*)session;  // pass nil for all sessions 
- (void)newTabWithDirectory:(NSString*)path;
- (void)makeFirstResponder;

// Utility methods
+ (void) breakDown:(NSString *)cmdl cmdPath: (NSString **) cmd cmdArgs: (NSArray **) path;

- (void)addNewSession:(NSDictionary *)addressbookEntry
		  withCommand:(NSString *)command
			  withURL:(NSString*)url;

- (void)appendSession:(PTYSession *)object;
- (void)removeFromSessionsAtIndex:(NSUInteger)index;
@property (readonly, copy) NSArray<PTYSession*> *sessions;
- (void)addInSessions:(PTYSession *)object;
- (void)insertInSessions:(PTYSession *)object;
- (void)insertInSessions:(PTYSession *)object atIndex:(NSUInteger)index;
@end

@interface ITTerminalView (ScriptingSupport)

// Object specifier
- (NSScriptObjectSpecifier *)objectSpecifier;

- (void)handleSelectScriptCommand: (NSScriptCommand *)command;

- (void)handleLaunchScriptCommand: (NSScriptCommand *)command;
@end


@interface ITTerminalView (WindowStuffTemp)
- (NSRect)windowWillUseStandardFrame:(NSRect)defaultFrame;
@end

@interface ITTerminalView (Actions)
- (IBAction)closeTabAction:(id)sender;
- (void)newSessionInTabAtIndex:(id)sender;
- (void)newSessionInWindowAtIndex:(id)sender;
@end
