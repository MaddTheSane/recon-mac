//
//  MyDocument.h
//  Recon
//
//  Created by Sumanth Peddamatham on 7/1/09.
//  Copyright bafoontecha.com 2009 . All rights reserved.
//
//  http://www.cocoadevcentral.com/articles/000086.php

#import <Cocoa/Cocoa.h>
#import "PrefsController.h"
#import <BWTK/BWSplitView.h>
#import <BWTK/BWAnchoredButton.h>

#import "ManagingViewController.h"
#import "BasicViewController.h"
#import "AdvancedViewController.h"
#import "SettingsViewController.h"

@class Session;
@class SessionManager;
@class PrefsController;

// User application default keys
extern NSString * const BAFReconHasRun;
extern NSString * const BAFNmapBinaryLocation;
extern NSString * const BAFSavedSessionsDirectory;

@interface MyDocument : NSPersistentDocument <NSApplicationDelegate> {

   NSMutableArray *viewControllers;   
   
   // TODO: Transplant functions
   IBOutlet NSWindow *mainWindow;

   IBOutlet NSView *targetBarPlaceholder;
   IBOutlet NSView *__weak workspacePlaceholder;   
   IBOutlet NSView *notesSideBarPlaceholder;
   
   IBOutlet NSView *notesSideBarContent;
   
   IBOutlet NSSegmentedControl *modeSwitchBar;
      
   PrefsController *prefsController;
   SessionManager *sessionManager;
   
   IBOutlet NSDrawer *notesDrawer;
   
   // Toolbar Outlets
   IBOutlet NSToolbar *mainToolbar;
   
   // Queue Controls
   IBOutlet NSSegmentedControl *queueSegmentedControl;
      
   // Session Drawer
   IBOutlet NSDrawer *sessionsDrawer;
   IBOutlet NSTableView *sessionsTableView;
   IBOutlet NSMenu *sessionsContextMenu;
   IBOutlet NSArrayController *sessionsArrayController;
   IBOutlet NSArrayController *profilesArrayController;
   IBOutlet NSArrayController *notesInHostArrayController;
   IBOutlet NSArrayController *hostsInSessionArrayController;
   
   // Notes Drawer
   IBOutlet NSTableView *notesTableView;
   
   // Sessions Menu Items
   IBOutlet NSMenuItem *runMenuItem;
   IBOutlet NSMenuItem *runCopyMenuItem;   
   IBOutlet NSMenuItem *removeMenuItem;   
   IBOutlet NSMenuItem *showInFinderMenuItem;         

   // Manual-entry Outlets
   IBOutlet NSTextField *nmapCommandTextField;   
   IBOutlet NSTextView *nmapConsoleTextView;   
   
   // Defines for flashing direct-entry TextField
   float nmapErrorCount;   
   NSTimer *nmapErrorTimer;
   
   // Sort-descriptors for the various table views
   NSArray *osSortDescriptor;
   NSArray *hostSortDescriptor;
   NSArray *portSortDescriptor;   
   NSArray *profileSortDescriptor;      
   NSArray *sessionSortDescriptor;      
   NSArray *notesSortDescriptor;
   
   BOOL closedDrawers;
   NSRect standardWindowRect;
}

@property (weak, readonly) NSArray *osSortDescriptor;
@property (weak, readonly) NSArray *hostSortDescriptor;
@property (weak, readonly) NSArray *portSortDescriptor;
@property (weak, readonly) NSArray *profileSortDescriptor;
@property (weak, readonly) NSArray *sessionSortDescriptor;
@property (weak, readonly) NSArray *notesSortDescriptor;

@property (weak, readonly) NSView *workspacePlaceholder;

- (IBAction)toggleFullScreen:(id)sender;
- (BOOL)windowShouldZoom:(NSWindow *)window toFrame:(NSRect)proposedFrame;

- (IBAction)showProfileEditor:(id)sender;
- (IBAction)modeSwitch2:(id)sender;

- (IBAction)switchToBasic:(id)sender;
- (IBAction)switchToAdvanced:(id)sender;
- (IBAction)switchToProfileEditor:(id)sender;

- (IBAction)saveDocument:(id)sender;
- (IBAction)saveDocumentTo:(id)sender;
- (IBAction)saveDocumentAs:(id)sender;

- (IBAction)segControlClicked:(id)sender;

- (IBAction)toggleNotes:(id)sender;
- (IBAction)toggleSessions:(id)sender;

// Sessions Drawer click-handlers
- (IBAction) sessionDrawerRun:(id)sender;
- (IBAction) sessionDrawerRunCopy:(id)sender;
- (IBAction) sessionDrawerAbort:(id)sender;
- (IBAction) sessionDrawerRemove:(id)sender;
- (IBAction) sessionDrawerShowInFinder:(id)sender;

- (Session *)clickedSessionInDrawer;
- (Session *)selectedSessionInDrawer;

// Session Manager click-handlers
- (IBAction)queueSession:(id)sender;
- (IBAction)dequeueSession:(id)sender;
- (IBAction)processQueue:(id)sender;

- (void)addQueuedSessions;
- (void)addDefaultProfiles;
- (IBAction)emailSelectedSessions:(id)sender;

// Preference window stuff
- (IBAction)setuidNmap:(id)sender;
- (IBAction)unsetuidNmap:(id)sender;
- (IBAction)showPrefWindow:(id)sender;

- (void)zoom:(id)sender;
- (void)updateSupportFolder:(NSNotification *)notification;

- (IBAction)addNote:(id)sender;

@end
