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
   NSArray<NSSortDescriptor*> *osSortDescriptor;
   NSArray<NSSortDescriptor*> *hostSortDescriptor;
   NSArray<NSSortDescriptor*> *portSortDescriptor;
   NSArray<NSSortDescriptor*> *profileSortDescriptor;
   NSArray<NSSortDescriptor*> *sessionSortDescriptor;        
   
   IBOutlet NSMenu *profilesContextMenu;
}

@property (nonatomic, copy, readonly) NSArray<NSSortDescriptor*> *osSortDescriptor;
@property (nonatomic, copy, readonly) NSArray<NSSortDescriptor*> *hostSortDescriptor;
@property (nonatomic, copy, readonly) NSArray<NSSortDescriptor*> *portSortDescriptor;
@property (nonatomic, copy, readonly) NSArray<NSSortDescriptor*> *profileSortDescriptor;
@property (nonatomic, copy, readonly) NSArray<NSSortDescriptor*> *sessionSortDescriptor;

@property (strong) IBOutlet NSView *workspaceSettingsContent;
@property (strong) IBOutlet NSView *targetBarSettingsContent;
@property (strong) IBOutlet NSView *sideBarSettingsContent;

- (void)expandProfileView;
- (IBAction)addProfile:(id)sender;
- (IBAction)deleteProfile:(id)sender;

- (IBAction)copyProfile:(id)sender;
- (void)addProfileToUserProfiles:(Profile *)profile;

@end
