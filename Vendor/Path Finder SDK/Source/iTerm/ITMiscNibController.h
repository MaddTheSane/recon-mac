//
//  ITMiscNibController.h
//  iTerm
//
//  Created by Steve Gehrman on 1/23/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ITTerminalView;

@interface ITMiscNibController : NSObject {
    __unsafe_unretained ITTerminalView* mTerm;  // not retained
	
    NSTextField *mCommandField;
    NSTextField *mParameterName;
    NSPanel *mParameterPanel;
    NSTextField *mParameterPrompt;
    NSTextField *mParameterValue;
    NSView *mCommandView;
}

+ (ITMiscNibController*)controller:(ITTerminalView*)term;

- (NSString *)askUserForString:(NSString *)command window:(NSWindow*)window;

@property (strong) IBOutlet NSTextField *commandField;

@property (strong) IBOutlet NSTextField *parameterName;

@property (strong) IBOutlet NSPanel *parameterPanel;

@property (strong) IBOutlet NSTextField *parameterPrompt;

@property (strong) IBOutlet NSTextField *parameterValue;

@end
