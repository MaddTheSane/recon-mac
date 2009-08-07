//
//  AdvancedViewController.m
//  recon
//
//  Created by Sumanth Peddamatham on 8/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AdvancedViewController.h"

#import "Host.h"
#import "Port.h"
#import "Profile.h"
#import "Session.h"
#import "OsMatch.h"

#import "SessionManager.h"


@implementation AdvancedViewController

@synthesize targetBarAdvancedContent;

- (id)init 
{
   if (self = [super init])
   {
      if (![super initWithNibName:@"Advanced"
                           bundle:nil]) {
         return nil;
      }
      [self setTitle:@"Advanced"];      
   }   
   return self;
}


// -------------------------------------------------------------------------------
//	windowControllerDidLoadNib: This is where we perform most of the initial app
//                             setup.
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
   // ... and the Host TableView
   [hostsTableView setTarget:self];
   [hostsTableView setDoubleAction:@selector(hostsTableDoubleClick)];
   
   // ... and the Services TableView
   [portsTableView setTarget:self];
   [portsTableView setDoubleAction:@selector(portsTableDoubleClick)];   
   
   // ... and the Oses TableView
   [osesTableView setTarget:self];
   [osesTableView setDoubleAction:@selector(osesTableDoubleClick)];   
   
   // ... and the Ports TableView in the Results Tab
   [resultsPortsTableView setTarget:self];
   [resultsPortsTableView setDoubleAction:@selector(resultsPortsTableDoubleClick)];   
   
   [targetBarAdvancedContent retain];   
   [sideBarAdvancedContent retain];
   [workspaceAdvancedContent retain];      
   
   [self createHostsMenu];   
   
   [[ipTextField cell] setBackgroundStyle:NSBackgroundStyleRaised];   
}   


#pragma mark Table click handlers
// -------------------------------------------------------------------------------
//	createHostsMenu: Create a right-click menu for the hosts Table View.
//                  TODO: This function is replicated in InspectorController. :(
// -------------------------------------------------------------------------------
- (void)createHostsMenu
{
   NSArray *array = [[self managedObjectContext] fetchObjectsForEntityName:@"Profile" withPredicate:
                     @"(parent.name LIKE[c] 'Defaults') OR (parent.name LIKE[c] 'User Profiles')"];   
   
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                       initWithKey:@"name" ascending:YES];
   
   NSMutableArray *sa = [NSMutableArray arrayWithArray:array];
   [sa sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];    
   [sortDescriptor release];
   
   NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:@"Queue with"
                                               action:@selector(handleHostsMenuClick:)
                                        keyEquivalent:@""];   
   NSMenu *submenu = [[NSMenu alloc] initWithTitle:@"Profile"];
   [mi setSubmenu:submenu];
   
   for (id obj in sa)
   {
      NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:[obj name]
                                                  action:@selector(handleHostsMenuClick:)
                                           keyEquivalent:@""];
      [mi setTag:10];
      [submenu addItem:mi];
      [mi release];      
      
   }
   [hostsContextMenu addItem:mi];
}

// -------------------------------------------------------------------------------
//	handleHostsMenuClick: 
// -------------------------------------------------------------------------------
- (IBAction)handleHostsMenuClick:(id)sender
{
   //ANSLog(@"MyDocument: handleHostsMenuClick: %@", [sender title]);
   
   // If we want to queue selected hosts... (10 is a magic number specified in IB)
   if ([sender tag] == 10)
   {
      // Grab the desired profile...
      NSArray *s = [[self managedObjectContext] fetchObjectsForEntityName:@"Profile" withPredicate:
                    @"(name LIKE[c] %@)", [sender title]]; 
      Profile *p = [s lastObject];
      
      // Grab the selected hosts from the hostsController
      NSArray *selectedHosts = [hostsInSessionController selectedObjects];
      
      NSString *hostsIpCSV = [[NSString alloc] init];
      
      // Create a comma-seperated string of target ip's
      if ([selectedHosts count] > 1)
      {
         Host *lastHost = [selectedHosts lastObject];
         
         for (Host *host in selectedHosts)
         {
            if (host == lastHost)
               break;
            hostsIpCSV = [hostsIpCSV stringByAppendingFormat:@"%@ ", [host ipv4Address]];
         }
      }
      
      hostsIpCSV = [hostsIpCSV stringByAppendingString:[[selectedHosts lastObject] ipv4Address]];
      
      //      // Create a Target string based on the hosts ip's
      //      NSString *ip = [[a lastObject] ipv4Address];
      
      // BEAUTIFIER: When queueing up a new host, keep the selection on the current Session
      Session *currentSession = [[sessionsController selectedObjects] lastObject];      
      
      // Grab the Session Manager object
      SessionManager *sessionManager = [SessionManager sharedSessionManager];
      
      [sessionManager queueSessionWithProfile:p withTarget:hostsIpCSV];
      
      // BEAUTIFIER
      [sessionsController setSelectedObjects:[NSArray arrayWithObject:currentSession]];
   }
}

// -------------------------------------------------------------------------------
//	Table click handlers
// -------------------------------------------------------------------------------
#pragma mark Table double-click handlers
- (void)hostsTableDoubleClick
{
   // If user double-clicks on a Host menu item, switch to results view
//   [self toggleResults:self];
}

- (void)portsTableDoubleClick 
{
   // Get selected port
   Port *selectedPort = [[portsInSessionController selectedObjects] lastObject];
   // Get host for selected port
   Host *selectedHost = selectedPort.host;
   
   [hostsInSessionController setSelectedObjects:[NSArray arrayWithObject:selectedHost]];
   // If user double-clicks on a Host menu item, switch to results view
//   [self toggleResults:self];
}

- (void)osesTableDoubleClick
{
   // Get selected port
   OsMatch *selectedOs = [[osesInSessionController selectedObjects] lastObject];
   // Get host for selected port
   Host *selectedHost = selectedOs.host;
   
   [hostsInSessionController setSelectedObjects:[NSArray arrayWithObject:selectedHost]];
   // If user double-clicks on a Host menu item, switch to results view
//   [self toggleResults:self];
}

- (void)resultsPortsTableDoubleClick
{
   // Find clicked row from sessionsTableView
   NSInteger selectedRow = [resultsPortsTableView selectedRow];
   // Get selected object from sessionsController 
   Port *selectedPort = [[portsInHostController arrangedObjects] objectAtIndex:selectedRow];
   Host *selectedHost = [selectedPort host];
   
   NSString *url;
   switch ([[selectedPort number] integerValue]) {
      case 80:
         url = [NSString stringWithFormat:@"http://%@", [selectedHost ipv4Address]];
         [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
         break;
         
      case 139:
      case 445:
         url = [NSString stringWithFormat:@"smb://%@", [selectedHost ipv4Address]];
         [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
         break;         
      default:
         break;
   }
   
   // TODO: Parse the port name for services running on non-standard ports
}


#pragma mark -
#pragma mark Sort Descriptors

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

@end
