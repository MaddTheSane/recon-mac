//
//  MyDocument.m
//  Recon
//
//  Created by Sumanth Peddamatham on 7/1/09.
//  Copyright bafoontecha.com 2009 . All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreAnimation.h>

#import "MyDocument.h"
#import "SessionManager.h"
#import "ArgumentListGenerator.h"

// Helper categories from the interwebs
#import "NSManagedObjectContext-helper.h"

#import "Profile.h"
#import "Session.h"


@implementation MyDocument

@synthesize workspacePlaceholder;

- (id)init 
{
    if (self = [super init])
    {
       // Insert initialization code here...
       
       [super init];       
    }
    return self;
}

- (void)dealloc
{
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
   [nc removeObserver:self];   
   
   [sessionManager release];
   
   [nmapErrorTimer invalidate];
   [nmapErrorTimer release];
   
   [nmapErrorTimer invalidate];
   [nmapErrorTimer release];
   
   [viewControllers release];   
   [super dealloc];
}

// -------------------------------------------------------------------------------
//	displayName: Override NSPersistentDocument window title
// -------------------------------------------------------------------------------
- (NSString *)displayName
{
   return @"Recon.";
}

// -------------------------------------------------------------------------------
//	awakeFromNib: Everything in here was moved to windowControllerDidLoadNib, since
//               awakeFromNib tends to be called after Panels are displayed.
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
   [NSApp setDelegate: self];
}

// -------------------------------------------------------------------------------
//	windowControllerDidLoadNib: This is where we perform most of the initial app
//                             setup.
// -------------------------------------------------------------------------------
- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
   //ANSLog(@"windowControllerDidLoadNib");
   
   sessionManager = [SessionManager sharedSessionManager];
   
   [sessionManager setSessionsArrayController:sessionsArrayController];   
   
   [super windowControllerDidLoadNib:windowController];
         
   [modeSwitchBar setSelectedSegment:0];
   
   [NSApp setServicesProvider:self];

   // Grab a copy of the Prefs Controller
   prefsController = [PrefsController sharedPrefsController];
   
   // Listen for user defaults updates from Prefs Controller
   [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(updateSupportFolder:)
    name:@"BAFupdateSupportFolder"
    object:prefsController];   
         
   NSSize mySize2 = {145, 147};
   [sessionsDrawer setContentSize:mySize2];   
   
   // If first run, display welcome screen
   if ([prefsController hasReconRunBefore] == NO)
   {      
      [[NSNotificationCenter defaultCenter]
       addObserver:self
       selector:@selector(finishFirstRun:)
       name:@"BAFfinishFirstRun"
       object:prefsController];   
      
      [prefsController displayWelcomeWindow];      
   }
   else
   {
      // Load up Persistent Store
      NSError *error;
      NSURL *url = [NSURL fileURLWithPath: [[prefsController reconSupportFolder]
                                     stringByAppendingPathComponent: @"Library.sessions"]];       
      
      // Set a custom Persistent Store location
      [self configurePersistentStoreCoordinatorForURL:url ofType:NSSQLiteStoreType error:&error];              
      
      // Add some default scanning profiles   
      [self addDefaultProfiles];   

      // Load queued sessions in the persistent store into session manager
      [self addQueuedSessions];

      [sessionsDrawer close];      
   }

   // Set up click-handlers for the Sessions Drawer
   [sessionsTableView setTarget:self];
   [sessionsTableView setDoubleAction:@selector(sessionsTableDoubleClick)];
   [sessionsTableView setAutosaveTableColumns:YES];   
   [sessionsContextMenu setAutoenablesItems:YES];      
   
   // Setup TableView for drag-and-drop
   [sessionsTableView registerForDraggedTypes:
    [NSArray arrayWithObjects:NSStringPboardType,NSFilenamesPboardType,nil]];
      
   // Setup Queue buttons
   [queueSegmentedControl setTarget:self];   
   [queueSegmentedControl setAction:@selector(segControlClicked:)];   
      
   [[self managedObjectContext] setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];   
   
   // Initialize view controllers
   viewControllers = [[NSMutableArray alloc] init];
   
   BasicViewController *vc;
   vc = [[BasicViewController alloc] init];
   [vc setManagedObjectContext:[self managedObjectContext]];
   [vc setSessionsArrayController:sessionsArrayController];
   [vc setProfilesArrayController:profilesArrayController];
   [vc setWorkspacePlaceholder:workspacePlaceholder];
   [viewControllers addObject:vc];
   [vc release];       
   
   vc = [[AdvancedViewController alloc] init];
   [vc setManagedObjectContext:[self managedObjectContext]];
   [vc setSessionsArrayController:sessionsArrayController];   
   [vc setProfilesArrayController:profilesArrayController];   
   [vc setWorkspacePlaceholder:workspacePlaceholder];
   [viewControllers addObject:vc];
   [vc release];              
   
   vc = [[SettingsViewController alloc] init];
   [vc setManagedObjectContext:[self managedObjectContext]];
   [vc setSessionsArrayController:sessionsArrayController];   
   [vc setProfilesArrayController:profilesArrayController];   
   [vc setWorkspacePlaceholder:workspacePlaceholder];
   [viewControllers addObject:vc];
   [vc release];                     
   
   // Set-up Workspace
   
   // Grab Basic view from controller
   vc = [viewControllers objectAtIndex:0];

   NSView *workspaceBasicContent = [vc view];
   
   [workspaceBasicContent setFrame:[workspacePlaceholder frame]];
   [workspacePlaceholder addSubview:workspaceBasicContent];
   
   NSView *targetBarBasicContent = [vc targetBarBasicContent];
   
   [targetBarBasicContent setFrame:[targetBarPlaceholder frame]];
   [targetBarPlaceholder addSubview:targetBarBasicContent];
   
}

- (void)displayViewController:(ManagingViewController *)vc
{
   // Try to end editing
   NSWindow *w = [workspacePlaceholder window];
   BOOL ended = [w makeFirstResponder:w];
   if (!ended) {
      NSBeep();
      return;
   }
}

// TODO: Transplant functions
- (IBAction)modeSwitch2:(id)sender
{   
   // Basic
   if ([sender selectedSegment] == 0) 
   {
      BasicViewController *vc = [viewControllers objectAtIndex:0];
   
      NSView *workspaceBasicContent = [vc view];      
      NSView *targetBarBasicContent = [vc targetBarBasicContent];
      
      [targetBarBasicContent setFrame:[targetBarPlaceholder frame]];
      [[targetBarPlaceholder animator] replaceSubview:[[targetBarPlaceholder subviews] lastObject]   
                                                 with:targetBarBasicContent];

      [workspaceBasicContent setFrame:[workspacePlaceholder frame]];
      [[workspacePlaceholder animator] replaceSubview:[[workspacePlaceholder subviews] lastObject]
                                                 with:workspaceBasicContent];
      
   }
   // Advanced
   if ([sender selectedSegment] == 1) 
   {
      AdvancedViewController *vc = [viewControllers objectAtIndex:1];

      NSView *workspaceAdvancedContent = [vc view];
      NSView *targetBarAdvancedContent = [vc targetBarAdvancedContent];
      
      [targetBarAdvancedContent setFrame:[targetBarPlaceholder frame]];
      [[targetBarPlaceholder animator] replaceSubview:[[targetBarPlaceholder subviews] lastObject]  
                                                 with:targetBarAdvancedContent];
      [workspaceAdvancedContent setFrame:[workspacePlaceholder frame]];
      [[workspacePlaceholder animator] replaceSubview:[[workspacePlaceholder subviews] lastObject]
                                                 with:workspaceAdvancedContent];
   
   }
   // Settings
   if ([sender selectedSegment] == 2) 
   {
      SettingsViewController *vc = [viewControllers objectAtIndex:2];      
      
      NSView *workspaceSettingsContent = [vc view];
      NSView *targetBarSettingsContent = [vc targetBarSettingsContent];
      
      [targetBarSettingsContent setFrame:[targetBarPlaceholder frame]];
      [[targetBarPlaceholder animator] replaceSubview:[[targetBarPlaceholder subviews] lastObject] 
                                                 with:targetBarSettingsContent];
      
      [workspaceSettingsContent setFrame:[workspacePlaceholder frame]];
      [[workspacePlaceholder animator] replaceSubview:[[workspacePlaceholder subviews] lastObject]
                                                 with:workspaceSettingsContent];

   }  
}

// -------------------------------------------------------------------------------
//	updateSupportFolder: If the user updates the output folder in the Prefs Controller
//                      we've gotta relocate the Persistent Store.
// -------------------------------------------------------------------------------
- (void)updateSupportFolder:(NSNotification *)notification
{
   NSError *error;   
   
   NSURL *url = [NSURL fileURLWithPath: [[prefsController reconSupportFolder]
                                         stringByAppendingPathComponent: @"Library.sessions"]];       
   
   // Grab store coordinator
   NSPersistentStoreCoordinator *currentPersistentStoreCoordinator =
                                 [[self managedObjectContext] persistentStoreCoordinator];
   
   // Grab current persistent store
   NSArray *persistentStores = [currentPersistentStoreCoordinator persistentStores];

   // If this isn't the first time running Recon, clean up...
   if ([persistentStores count] != 0)
   {
      [[self managedObjectContext] save:&error];
   
      // Remove current persistent store
      [currentPersistentStoreCoordinator removePersistentStore:[persistentStores lastObject] error:&error];
   }
   
   // Set a custom Persistent Store location
   [self configurePersistentStoreCoordinatorForURL:url ofType:NSSQLiteStoreType error:&error];              
   
   // Add some default profiles   
   [self addDefaultProfiles];   
   
   // Load queued sessions in the persistent store into session manager
   [self addQueuedSessions];   
}


// -------------------------------------------------------------------------------
//	finishFirstRun: BEAUTIFIER FUNCTION.  The Welcome window looks better when the
//                 drawers are closed, so we open them after the user dismisses the
//                 window.
// -------------------------------------------------------------------------------
- (void)finishFirstRun:(NSNotification *)notification
{
   NSLog(@"Finish first run");
   
   // Load up Persistent Store
   NSError *error;
   NSURL *url = [NSURL fileURLWithPath: [[prefsController reconSupportFolder]
                                         stringByAppendingPathComponent: @"Library.sessions"]];       
   
   // Set a custom Persistent Store location
   [self configurePersistentStoreCoordinatorForURL:url ofType:NSSQLiteStoreType error:&error];              
   
   // Add some default scanning profiles   
   [self addDefaultProfiles];   
   
   // Load queued sessions in the persistent store into session manager
   [self addQueuedSessions];
   
   [sessionsDrawer close];   
}

// -------------------------------------------------------------------------------
//	validateToolbarItem: 
// -------------------------------------------------------------------------------
- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
   return YES;
}

static int numberOfShakes = 8;
static float durationOfShake = 0.5f;
static float vigourOfShake = 0.01f;
// Shaker, courtesy of http://www.cimgf.com/2008/02/27/core-animation-tutorial-window-shake-effect/
- (CAKeyframeAnimation *)shakeAnimation:(NSRect)frame
{
   CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
	
   CGMutablePathRef shakePath = CGPathCreateMutable();
   CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
	int index;
	for (index = 0; index < numberOfShakes; ++index)
	{
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));
	}
   CGPathCloseSubpath(shakePath);
   shakeAnimation.path = shakePath;
   shakeAnimation.duration = durationOfShake;
   return shakeAnimation;
}


#pragma mark -
#pragma mark Segmented Control click-handlers

// -------------------------------------------------------------------------------
//	segControlClicked: Delete/Play/Add segmented control in the lower-right
// -------------------------------------------------------------------------------
- (IBAction)segControlClicked:(id)sender
{
   int clickedSegment = [sender selectedSegment];
   
   if (clickedSegment == 0)
      [self dequeueSession:self];
   if (clickedSegment == 1)
      [self processQueue:self];
   if (clickedSegment == 2)
      [self queueSession:self];
}

#pragma mark -
#pragma mark SessionManager methods
// -------------------------------------------------------------------------------
//	queueSession: Queue up a session using the currently selected Profile.
//
//   http://arstechnica.com/apple/guides/2009/04/cocoa-dev-the-joy-of-nspredicates-and-matching-strings.ars
// -------------------------------------------------------------------------------
- (IBAction)queueSession:(id)sender 
{   
   NSLog(@"MyDocument: queueSession");
   
   NSTextField *sessionTarget = nil;
   
   // We have to drill-down to find the proper TextField in the targetBarPlaceholder
   if ( ([modeSwitchBar selectedSegment] == 1) || ([modeSwitchBar selectedSegment] == 2))
      sessionTarget = [[[[targetBarPlaceholder subviews] lastObject] subviews] lastObject];
   
   // Read the manual entry textfield, tokenize the string, and pull out
   //  arguments that start with '-', ie. nmap commands
   NSString *nmapCommand  = [nmapCommandTextField stringValue];
   NSArray *parsedNmapCommand = [nmapCommand componentsSeparatedByString:@" "];
   NSArray *nmapFlags = [parsedNmapCommand filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith '-'"]];
   
   // Check if the user entered any commands
   if ([nmapFlags count] == 0)
   {      
      // TODO: Check to make sure input arguments are valid
      [sessionManager queueSessionWithProfile:[[profilesArrayController selectedObjects] lastObject]
                                   withTarget:[sessionTarget stringValue]];      
      
   }
   // ... otherwise, parse the input commands and queue the session
   else
   {
      ArgumentListGenerator *a = [[ArgumentListGenerator alloc] init];   
      
      // Validate user-specified flags      
      if ([a areFlagsValid:nmapFlags] == YES)
      {
         // Create a brand spankin' profile
         Profile *profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" 
                                                          inManagedObjectContext:[self managedObjectContext]];
         
         // Populate new profile with command line args
         [a populateProfile:profile 
              withArgString:nmapFlags];
         
         // TODO: Check to make sure input arguments are valid
         [sessionManager queueSessionWithProfile:profile 
                                      withTarget:[parsedNmapCommand lastObject]];         

         // Cleanup
         [[self managedObjectContext] deleteObject:profile];
         [nmapCommandTextField setStringValue:@""];
      }
      // Flash textfield to indicate entry error
      else
      {
         [nmapCommandTextField setAnimations:[NSDictionary dictionaryWithObject:[self shakeAnimation:[nmapCommandTextField frame]] forKey:@"frameOrigin"]];
         [[nmapCommandTextField animator] setFrameOrigin:[nmapCommandTextField frame].origin];
      
//         nmapErrorCount = 1.0;
//         nmapErrorTimer = [[NSTimer scheduledTimerWithTimeInterval:0.07
//                                                   target:self
//                                                 selector:@selector(indicateEntryError:)
//                                                 userInfo:nil
//                                                  repeats:YES] retain]; 
      }

      // TODO: Why for thou crasheth?
      [a release];
   }
}

// -------------------------------------------------------------------------------
//	indicateEntryError: Timer helper-function indicating nmap command entry error
// -------------------------------------------------------------------------------
- (void)indicateEntryError:(NSTimer *)aTimer
{
   nmapErrorCount -= 0.04;
   if (nmapErrorCount <= 0) {
      [nmapErrorTimer invalidate];
      [nmapCommandTextField setTextColor:[NSColor blackColor]];  
      return;
   }      
   
   [nmapCommandTextField setTextColor:[NSColor colorWithDeviceRed:nmapErrorCount green:0 blue:0 alpha:1]];
}         


// -------------------------------------------------------------------------------
//	dequeueSession: Use current state of the selected Profile and queue a session.
// -------------------------------------------------------------------------------
- (IBAction)dequeueSession:(id)sender 
{   
   [sessionManager deleteSession:[self selectedSessionInDrawer]];  
}

// -------------------------------------------------------------------------------
//	processQueue: Begin processing session queue.
// -------------------------------------------------------------------------------
- (IBAction)processQueue:(id)sender
{  
   [sessionManager processQueue];
}

// -------------------------------------------------------------------------------
//	addQueuedSessions: When the application loads, previous sessions are loaded
//                    from the persistent store.  We have to add queued sessions
//                    to the Session Manager, so continuity in the user experience
//                    is maintained.
// -------------------------------------------------------------------------------
- (void)addQueuedSessions
{   
   NSArray *array = [[self managedObjectContext] fetchObjectsForEntityName:@"Session" 
                                                             withPredicate:@"(status LIKE[c] 'Queued')"];                        
   
   if ([array count] > 0)
      [sessionManager queueExistingSessions:array];
   
   // This should probably be moved to it's own method, buuuuut...
   array = [[self managedObjectContext] fetchObjectsForEntityName:@"Session" withPredicate:
                     @"(status != 'Queued') AND (status != 'Done')"];   
   
   // Set incomplete scans to 'Aborted'
   if ([array count] > 0)
   {
      for (id object in array)
      {
         [object setStatus:@"Aborted"];
         [object setProgress:[NSNumber numberWithFloat:0.0]];
      }
   }   
}

#pragma mark -
#pragma mark Profiles drawer methods
// -------------------------------------------------------------------------------
//	addDefaultProfiles: 
// -------------------------------------------------------------------------------
- (void)addDefaultProfiles
{
   NSArray *array = [[self managedObjectContext] fetchObjectsForEntityName:@"Profile" withPredicate:nil];    
   
   if (array != nil) {
      
      int count = [array count]; // may be 0 if the object has been deleted   
      
      if (count == 0)
      {
         NSManagedObjectContext *context = [self managedObjectContext]; 
         Profile *profileParent = nil; 
         
         // Add Defaults parent folder
         profileParent = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profileParent setValue: @"Defaults" forKey: @"name"]; 
         [profileParent setIsEnabled:NO];
                  
         Profile *profile = nil; 
         
         // Add a few defaults
         profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profile setValue: @"Intense Scan" forKey: @"name"]; 
         [profile setTimingTemplateTag:[NSNumber numberWithInt:4]];      
         [profile setEnableAggressive:[NSNumber numberWithInt:1]];         
         [profile setIcmpPing:[NSNumber numberWithBool:TRUE]];
         [profile setSynPing:[NSNumber numberWithBool:TRUE]];
         [profile setSynPingString:@"22,25,80"];
         [profile setAckPing:[NSNumber numberWithBool:TRUE]];
         [profile setAckPingString:@"21,23,80,3389"];
         [profile setValue:profileParent forKey:@"parent"];

         profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profile setValue: @"Intense Scan+UDP" forKey: @"name"]; 
         [profile setTimingTemplateTag:[NSNumber numberWithInt:4]];      
         [profile setTcpScanTag:[NSNumber numberWithInt:5]];      
         [profile setNonTcpScanTag:[NSNumber numberWithInt:1]];      
         [profile setEnableAggressive:[NSNumber numberWithInt:1]];         
         [profile setIcmpPing:[NSNumber numberWithBool:TRUE]];
         [profile setSynPing:[NSNumber numberWithBool:TRUE]];
         [profile setSynPingString:@"22,25,80"];
         [profile setAckPing:[NSNumber numberWithBool:TRUE]];
         [profile setAckPingString:@"21,23,80,3389"];
         [profile setValue:profileParent forKey:@"parent"];
         
         profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profile setValue: @"Intense Scan+TCP" forKey: @"name"]; 
         [profile setPortsToScan:[NSNumber numberWithBool:TRUE]];
         [profile setPortsToScanString:@"1-65535"];
         [profile setTimingTemplateTag:[NSNumber numberWithInt:4]];      
         [profile setEnableAggressive:[NSNumber numberWithInt:1]];         
         [profile setIcmpPing:[NSNumber numberWithBool:TRUE]];
         [profile setSynPing:[NSNumber numberWithBool:TRUE]];
         [profile setSynPingString:@"22,25,80"];
         [profile setAckPing:[NSNumber numberWithBool:TRUE]];
         [profile setAckPingString:@"21,23,80,3389"];
         [profile setValue:profileParent forKey:@"parent"];

         profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profile setValue: @"Intense Scan-Ping" forKey: @"name"]; 
         [profile setTimingTemplateTag:[NSNumber numberWithInt:4]];      
         [profile setEnableAggressive:[NSNumber numberWithInt:1]];         
         [profile setDontPing:[NSNumber numberWithBool:TRUE]];
         [profile setValue:profileParent forKey:@"parent"];         
         
         profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profile setValue: @"Ping Scan" forKey: @"name"]; 
         [profile setNonTcpScanTag:[NSNumber numberWithInt:4]];
         [profile setIcmpPing:[NSNumber numberWithBool:TRUE]];
         [profile setAckPing:[NSNumber numberWithBool:TRUE]];
         [profile setAckPingString:@"21,23,80,3389"];
         [profile setValue:profileParent forKey:@"parent"];
         
         profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profile setValue: @"Quick Scan" forKey: @"name"]; 
         [profile setTimingTemplateTag:[NSNumber numberWithInt:4]];
         [profile setFastScan:[NSNumber numberWithBool:TRUE]];
         [profile setValue:profileParent forKey:@"parent"];
         
         profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profile setValue: @"Quick Scan+" forKey: @"name"]; 
         [profile setVersionDetection:[NSNumber numberWithBool:TRUE]];
         [profile setTimingTemplateTag:[NSNumber numberWithInt:4]];
         [profile setOsDetection:[NSNumber numberWithBool:TRUE]];
         [profile setFastScan:[NSNumber numberWithBool:TRUE]];
         [profile setValue:profileParent forKey:@"parent"];
         // TODO: add --version-light
         
         profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profile setValue: @"Quick Traceroute" forKey: @"name"]; 
         [profile setNonTcpScanTag:[NSNumber numberWithInt:4]];
         [profile setIcmpPing:[NSNumber numberWithBool:TRUE]];
         [profile setSynPing:[NSNumber numberWithBool:TRUE]];
         [profile setSynPingString:@"22,25,80"];         
         [profile setAckPing:[NSNumber numberWithBool:TRUE]];
         [profile setAckPingString:@"21,23,80,3389"];
         [profile setUdpProbe:[NSNumber numberWithBool:TRUE]];
         [profile setIpprotoProbe:[NSNumber numberWithBool:TRUE]];
         [profile setTraceRoute:[NSNumber numberWithBool:TRUE]];
         [profile setValue:profileParent forKey:@"parent"];
         
         profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profile setValue: @"Comprehensive" forKey: @"name"]; 
         [profile setTcpScanTag:[NSNumber numberWithInt:5]];               
         [profile setNonTcpScanTag:[NSNumber numberWithInt:1]];
         [profile setIcmpPing:[NSNumber numberWithBool:TRUE]];
         [profile setIcmpTimeStamp:[NSNumber numberWithBool:TRUE]];
         [profile setSynPing:[NSNumber numberWithBool:TRUE]];
         [profile setSynPingString:@"21,22,23,25,80,113,31339"];         
         [profile setAckPing:[NSNumber numberWithBool:TRUE]];
         [profile setAckPingString:@"80,113,443,10042"];
         [profile setUdpProbe:[NSNumber numberWithBool:TRUE]];
         [profile setIpprotoProbe:[NSNumber numberWithBool:TRUE]];
         [profile setTraceRoute:[NSNumber numberWithBool:TRUE]];
         // TODO: add --script-all
         [profile setValue:profileParent forKey:@"parent"];         
         
         // Add Saved Sessions parent folder
         profileParent = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:context]; 
         [profileParent setValue: @"Saved Sessions" forKey: @"name"]; 
         [profileParent setIsEnabled:NO];         
         
      }
   }
}

// -------------------------------------------------------------------------------
//	Session Drawer Menu click-handlers
// -------------------------------------------------------------------------------
#pragma mark Session Drawer Menu click-handlers
- (Session *)clickedSessionInDrawer
{
   // Find clicked row from sessionsTableView
   NSInteger clickedRow = [sessionsTableView clickedRow];

   return [[sessionsArrayController arrangedObjects] objectAtIndex:clickedRow];
}

- (Session *)selectedSessionInDrawer
{
   // Find clicked row from sessionsTableView
   NSInteger selectedRow = [sessionsTableView selectedRow];

   return [[sessionsArrayController arrangedObjects] objectAtIndex:selectedRow];   
}

- (IBAction)sessionDrawerRun:(id)sender
{
   NSLog(@"MyDocument: launching session");
   NSArray *selectedSessions = [sessionsArrayController selectedObjects];
   
   if ([selectedSessions count] > 1)
   {            
      for (id session in selectedSessions)
         [sessionManager launchSession:session];         
   }
   else 
   {
      [sessionManager launchSession:[selectedSessions lastObject]];
   }
}
- (IBAction)sessionDrawerRunCopy:(id)sender
{
   //ANSLog(@"MyDocument: sessionDrawerRunCopy - NOT IMPLEMENTED!");
}
- (IBAction) sessionDrawerAbort:(id)sender
{
   //ANSLog(@"MyDocument: Aborting session");
   
   NSArray *selectedSessions = [sessionsArrayController selectedObjects];
   
   if ([selectedSessions count] > 1)
   {      
      for (id session in selectedSessions)
         [sessionManager abortSession:session];         
   }
   else 
   {
      [sessionManager abortSession:[selectedSessions lastObject]];      
   }
}
- (IBAction) sessionDrawerRemove:(id)sender
{
   //ANSLog(@"MyDocument: Removing session");
   
   NSArray *selectedSessions = [sessionsArrayController selectedObjects];
   
   if ([selectedSessions count] > 1)
   {
      for (id session in selectedSessions)
         [sessionManager deleteSession:session];         
   }
   else 
   {
      [sessionManager deleteSession:[selectedSessions lastObject]];      
   }
}
- (IBAction) sessionDrawerShowInFinder:(id)sender
{   
   // Retrieve currently selected session
   NSString *savedSessionsDirectory = [prefsController reconSessionFolder];
   [[NSWorkspace sharedWorkspace] openFile:[savedSessionsDirectory stringByAppendingPathComponent:[[self clickedSessionInDrawer] UUID]]
                           withApplication:@"Finder"];

}

// -------------------------------------------------------------------------------
//	Table click handlers
// -------------------------------------------------------------------------------
#pragma mark Table double-click handlers

// Sessions Drawer click-handlers
- (void)sessionsTableDoubleClick
{
   //ANSLog(@"MyDocument: doubleClick!");
   
   // Retrieve currently selected session
   Session *selectedSession = [[sessionsArrayController selectedObjects] lastObject]; 
   
   if (selectedSession != nil) {
      // Retrieve currently selected profile
//      Profile *storedProfile = [selectedSession profile];
//      [profilesTreeController setContent:[NSArray arrayWithObject:storedProfile]];
      
      //   [[profilesTreeController selectedObjects] lastObject];
   }
}


// -------------------------------------------------------------------------------
//	Main Menu key-handlers
// -------------------------------------------------------------------------------
#pragma mark Main Menu click-handlers

- (IBAction) toggleSessionsDrawer:(id)sender {
   [sessionsDrawer toggle:self];    
}

// -------------------------------------------------------------------------------
//	Hands this functionality off to the PrefsController
// -------------------------------------------------------------------------------

- (IBAction)setuidNmap:(id)sender
{
   [prefsController rootNmap];
}
- (IBAction)unsetuidNmap:(id)sender
{
   [prefsController unrootNmap];
}
- (IBAction)showPrefWindow:(id)sender
{
   [prefsController showPrefWindow:self];
}

// -------------------------------------------------------------------------------
//	Menu click handlers
// -------------------------------------------------------------------------------
//
//// Enable/Disable menu depending on context
//- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
//{
//   BOOL enabled = NO;
//   
//   if (
//    ([menuItem action] == @selector(sessionDrawerRun:)) ||
//    ([menuItem action] == @selector(sessionDrawerRunCopy:)) ||
//    ([menuItem action] == @selector(sessionDrawerAbort:)) ||       
//    ([menuItem action] == @selector(sessionDrawerRemove:)) ||
//    ([menuItem action] == @selector(sessionDrawerShowInFinder:))       
//    )
//   {
////      NSInteger clickedRow = [sessionsTableView clickedRow];
////      if (clickedRow == -1) {
//      if ([[sessionsArrayController selectionIndexes] count] == 0) {
//         enabled = NO;
//      }
//      else 
//      {
//         enabled = YES;
////         Session *s = [self clickedSessionInDrawer];
//         
////         // Only enable Abort if session is running
////         if (
////             ([menuItem action] == @selector(sessionDrawerAbort:)) &&
////             ([s status] != @"Queued")
////            )         
////         {
////            //ANSLog(@"1");
////            enabled = NO;
////         }
////         
////         // Only enable Run if session is not running
////         else if (([menuItem action] == @selector(sessionDrawerRun:)) &&
////                 ([s status] != @"Queued"))
////         {
////
////            enabled = NO;
////         }         
//      }
//   } 
//   else if ([menuItem action] == @selector(handleHostsMenuClick:))
//   {
//      if ([[hostsInSessionController selectedObjects] count] == 0)
////      if ([hostsTableView clickedRow] == -1)
//         enabled = NO;
//      else
//         enabled = YES;
//   }
//   else
//   {
//      enabled = [super validateMenuItem:menuItem];
//   }
//  
//   return enabled;
//}

//
//// Handle context menu clicks in Sessions TableView
//- (void)menuNeedsUpdate:(NSMenu *)menu 
//{
////   NSInteger clickedRow = [sessionsTableView clickedRow];
////   NSInteger selectedRow = [sessionsTableView selectedRow];
////   NSInteger numberOfSelectedRows = [sessionsTableView numberOfSelectedRows];
//   //(NSIndexSet *)selectedRowIndexes = [sessionsTableView selectedRowIndexes];
//   
//   // If clickedRow == -1, the user hasn't clicked on a session
//   
//   // TODO: If Sessions Context Menu
//   if (menu == sessionsContextMenu) 
//   {
////      Session *s = [self clickedSessionInDrawer];
////      if ([s status] == @"
//   }
//   else if (menu == hostsContextMenu)
//   {
//   }
//   else
//   {
//      //ANSLog(@"MyDocument: fart!");      
//   
//   // TODO: If Hosts Context Menu
//   
//   // TODO: If Ports in Host Context Menu
//   
//   // TODO: If Ports Context Menu
//   
//   // TODO: If Profiles Context Menu
//   
////   [sessionsContextMenu update];
//   }
//}
//




#pragma mark -
#pragma mark NSWindow hooks

- (NSString *)windowNibName 
{
   return @"MyDocument";
}

// -------------------------------------------------------------------------------
//	NSDocument functions that we can potentially override
// -------------------------------------------------------------------------------

- (IBAction)saveDocument:(id)sender
{
   NSError *error;
   [[self managedObjectContext] save:&error];
}
- (IBAction)saveDocumentTo:(id)sender
{
   //ANSLog(@"SAVY?");
}
- (IBAction)saveDocumentAs:(id)sender
{
   //ANSLog(@"SAVY?");
}

// Overriding this allows us to create the illusion of Autosave
- (BOOL)isDocumentEdited
{
   return NO;
//   //ANSLog(@"EDIT!");
}

//- (void)canCloseDocumentWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo
//{	
//
//	[[self managedObjectContext] commitEditing];
//	[super canCloseDocumentWithDelegate:delegate shouldCloseSelector:shouldCloseSelector contextInfo:contextInfo];
//}


// -------------------------------------------------------------------------------
//	applicationShouldTerminate: Saves the managed object context before close
// -------------------------------------------------------------------------------
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
   
   NSLog(@"MyDocument: Closing main window");
   
   NSError *error;
   int reply = NSTerminateNow;
   NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
   
   if (managedObjectContext != nil) {
      if ([managedObjectContext commitEditing]) {
         if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            // This error handling simply presents error information in a panel with an 
            // "Ok" button, which does not include any attempt at error recovery (meaning, 
            // attempting to fix the error.)  As a result, this implementation will 
            // present the information to the user and then follow up with a panel asking 
            // if the user wishes to "Quit Anyway", without saving the changes.
            
            // Typically, this process should be altered to include application-specific 
            // recovery steps.  
            
            BOOL errorResult = [[NSApplication sharedApplication] presentError:error];
            
            if (errorResult == YES) {
               reply = NSTerminateCancel;
            } 
            
            else {
               
               int alertReturn = NSRunAlertPanel(nil, @"Could not save changes while quitting. Quit anyway?" , @"Quit anyway", @"Cancel", nil);
               if (alertReturn == NSAlertAlternateReturn) {
                  reply = NSTerminateCancel;	
               }
            }
         }
      } 
      
      else {
         reply = NSTerminateCancel;
      }
   }

//   exit(0);
   return reply;
}

// -------------------------------------------------------------------------------
//	applicationShouldTerminateAfterLastWindowClosed: Kills application properly
// -------------------------------------------------------------------------------
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
   return TRUE;
}

// -------------------------------------------------------------------------------
//	Sort Descriptors for the various table views
// -------------------------------------------------------------------------------

// http://fadeover.org/blog/archives/13
- (NSArray *)hostSortDescriptor
{
	if(hostSortDescriptor == nil){
		hostSortDescriptor = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"ipv4Address" ascending:YES]];
   }
   
	return hostSortDescriptor;
}

- (void)setHostSortDescriptor:(NSArray *)newSortDescriptor
{
	hostSortDescriptor = newSortDescriptor;
}

- (NSArray *)portSortDescriptor
{
	if(portSortDescriptor == nil){
		portSortDescriptor = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES]];
   }
   
	return portSortDescriptor;
}

- (void)setPortSortDescriptor:(NSArray *)newSortDescriptor
{
	portSortDescriptor = newSortDescriptor;
}

- (NSArray *)profileSortDescriptor
{
	if(profileSortDescriptor == nil){
		profileSortDescriptor = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
   }
   
	return profileSortDescriptor;
}

- (void)setProfileSortDescriptor:(NSArray *)newSortDescriptor
{
	profileSortDescriptor = newSortDescriptor;
}

- (NSArray *)sessionSortDescriptor
{
	if(sessionSortDescriptor == nil){
		sessionSortDescriptor = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]];
   }
   
	return sessionSortDescriptor;
}

- (void)setSessionSortDescriptor:(NSArray *)newSortDescriptor
{
	sessionSortDescriptor = newSortDescriptor;
}

- (NSArray *)osSortDescriptor
{
	if(osSortDescriptor == nil){
		osSortDescriptor = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO]];
   }
   
	return osSortDescriptor;
}

- (void)setOsSortDescriptor:(NSArray *)newSortDescriptor
{
	osSortDescriptor = newSortDescriptor;
}


#pragma mark Dragging Destination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
   //ANSLog(@"draggingEntered:");
   if ([sender draggingSource] == self) {
      return NSDragOperationNone;
   }
   
//   highlighted = YES;
//   [self setNeedsDisplay:YES];
   return NSDragOperationCopy;
}
- (void)draggingExited:(id <NSDraggingInfo>)sender
{
   //ANSLog(@"draggingExited:");
//   highlighted = NO;
//   [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
   return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
   NSPasteboard *pb = [sender draggingPasteboard];
   if(![self readFromPasteboard:pb]) {
      //ANSLog(@"Error: Could not read from dragging pasteboard");
      return NO;
   }
   return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
   //ANSLog(@"concludeDragOperation:");
//   highlighted = NO;
//   [self setNeedsDisplay:YES];
}

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard

{
   
   // Copy the row numbers to the pasteboard.
   
   NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
   
   [pboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
   
   [pboard setData:data forType:NSStringPboardType];
   
   return YES;
   
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op

{
   
   // Add code here to validate the drop
   
   //ANSLog(@"validate Drop");
   
   return NSDragOperationEvery;
   
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info

              row:(int)row dropOperation:(NSTableViewDropOperation)operation

{
   
   NSPasteboard* pboard = [info draggingPasteboard];
   
   NSData* rowData = [pboard dataForType:NSStringPboardType];
   
   NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
   
//   int dragRow = [rowIndexes firstIndex];
   
   return TRUE;
   
   // Move the specified row to its new location...
   
}


@end
