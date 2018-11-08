//
//  SettingsViewController.h
//  recon
//
//  Created by Sumanth Peddamatham on 8/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ManagingViewController.h"

@class Profile;

@interface SettingsViewController : ManagingViewController {
   
   NSView *workspaceSettingsContent;   
   NSView *targetBarSettingsContent;
   NSView *sideBarSettingsContent;
   
   IBOutlet NSScrollView *workspaceSettingsScrollView;   
   
   // TCP/Non-TCP/Timings Popup
   IBOutlet NSPopUpButton *tcpScanPopUp;
   IBOutlet NSPopUpButton *nonTcpScanPopUp;
   IBOutlet NSPopUpButton *timingTemplatePopUp;   
   
   IBOutlet NSOutlineView *profilesOutlineView;
   IBOutlet NSTreeController *profilesTreeController;
   
   // Sort-descriptors for the various table views
   NSArray *osSortDescriptor;
   NSArray *hostSortDescriptor;
   NSArray *portSortDescriptor;   
   NSArray *profileSortDescriptor;      
   NSArray *sessionSortDescriptor;        
   
   IBOutlet NSMenu *profilesContextMenu;
}

@property (weak, readonly) NSArray *osSortDescriptor;
@property (weak, readonly) NSArray *hostSortDescriptor;
@property (weak, readonly) NSArray *portSortDescriptor;
@property (weak, readonly) NSArray *profileSortDescriptor;
@property (weak, readonly) NSArray *sessionSortDescriptor;

@property (strong) IBOutlet NSView *workspaceSettingsContent;
@property (strong) IBOutlet NSView *targetBarSettingsContent;
@property (strong) IBOutlet NSView *sideBarSettingsContent;

- (void)expandProfileView;
- (IBAction)addProfile:(id)sender;
- (IBAction)deleteProfile:(id)sender;

- (IBAction)copyProfile:(id)sender;
- (void)addProfileToUserProfiles:(Profile *)profile;

@end
