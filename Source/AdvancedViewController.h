//
//  AdvancedViewController.h
//  recon
//
//  Created by Sumanth Peddamatham on 8/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ManagingViewController.h"
#import "NSManagedObjectContext-helper.h"

#import <WebKit/WebKit.h>

@interface AdvancedViewController : ManagingViewController {

   IBOutlet NSView *workspaceAdvancedContent;   
   IBOutlet NSView *targetBarAdvancedContent;   
   IBOutlet NSView *sideBarAdvancedContent;   
   
   IBOutlet NSView *outputPlaceholder;
   IBOutlet NSView *portsInHostView;
   IBOutlet NSView *scriptOutputView;
   
   // Various Results Outlets
   IBOutlet NSTableView *hostsTableView;
   IBOutlet NSMenu *hostsContextMenu;
   
   IBOutlet NSComboBox *sessionTarget;      
   
   IBOutlet NSTableView *portsTableView;   
   IBOutlet NSTableView *resultsPortsTableView;   
   IBOutlet NSTableView *osesTableView;      
   IBOutlet NSArrayController *portsInHostController;      
   
   IBOutlet NSArrayController *hostsInSessionController;
   IBOutlet NSArrayController *portsInSessionController;
   IBOutlet NSArrayController *osesInSessionController;
      
   // Sort-descriptors for the various table views
   NSArray *osSortDescriptor;
   NSArray *hostSortDescriptor;
   NSArray *portSortDescriptor;   
   NSArray *profileSortDescriptor;      
   NSArray *sessionSortDescriptor;        
   
   IBOutlet NSTextField *ipTextField;
   IBOutlet WebView *webby;
}

@property (readonly) NSArray *osSortDescriptor;
@property (readonly) NSArray *hostSortDescriptor;
@property (readonly) NSArray *portSortDescriptor;
@property (readonly) NSArray *profileSortDescriptor;
@property (readonly) NSArray *sessionSortDescriptor;

@property (readonly) NSView *targetBarAdvancedContent;

- (void)createHostsMenu;

- (IBAction)modeSwitch:(id)sender;

@end
