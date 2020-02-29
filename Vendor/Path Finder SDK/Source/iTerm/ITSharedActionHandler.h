//
//  ITSharedActionHandler.h
//  iTerm
//
//  Created by Steve Gehrman on 2/4/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ITSharedActionHandler : NSObject

@property (class, readonly, strong) ITSharedActionHandler *sharedInstance;
- (IBAction)showConfigWindow:(id)sender;
- (IBAction)showPreferencesAction:(id)sender;
- (IBAction)showProfilesAction:(id)sender;

@end
