//
//  NTChooseDestinationPanel.m
//  CocoatechCore
//
//  Created by sgehrman on Mon Aug 27 2001.
//  Copyright (c) 2001 CocoaTech. All rights reserved.
//

#import "NTChooseDestinationPanel.h"
#import "NSSavePanel-NTExtensions.h"

@interface NTChooseDestinationPanel ()
- (void)handleResult:(NSModalResponse)result openPanel:(NSOpenPanel*)openPanel;
- (void)startPanel:(NSString*)startPath window:(NSWindow*)window showInvisibleFiles:(BOOL)showInvisibleFiles;
@end

@implementation NTChooseDestinationPanel

@synthesize path;
@synthesize contextInfo;
@synthesize userClickedOK;
@synthesize selector;
@synthesize target;

- (id)initWithTarget:(id)inTarget selector:(SEL)inSelector contextInfo:(id)inContextInfo;
{
    self = [super init];

    self.selector = inSelector;
    self.target = inTarget;
    self.contextInfo = inContextInfo;

    return self;
}

+ (void)chooseDestination:(NSString*)startPath window:(NSWindow*)window target:(id)target selector:(SEL)inSelector contextInfo:(id)contextInfo;
{
	[self chooseDestination:startPath window:window target:target selector:inSelector contextInfo:contextInfo showInvisibleFiles:NO];
}

+ (void)chooseDestination:(NSString*)startPath window:(NSWindow*)window target:(id)target selector:(SEL)inSelector contextInfo:(id)contextInfo showInvisibleFiles:(BOOL)showInvisibleFiles;
{
    NTChooseDestinationPanel *panel = [[NTChooseDestinationPanel alloc] initWithTarget:target selector:inSelector contextInfo:contextInfo];

    [panel startPanel:startPath window:window showInvisibleFiles:showInvisibleFiles];
}

- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(NSInteger)returnCode contextInfo:(__unused void *)contextInfo
{
    [self handleResult:returnCode openPanel:sheet];
}

- (void)startPanel:(NSString*)startPath window:(NSWindow*)window showInvisibleFiles:(BOOL)inShowInvisibleFiles;
{
    NSOpenPanel *op = [NSOpenPanel openPanel];
    
    [op setCanChooseDirectories:YES];
    [op setCanChooseFiles:NO];
    [op setAllowsMultipleSelection:NO];
    [op setTreatsFilePackagesAsDirectories:YES];
    [op setPrompt:[NTLocalizedString localize:@"Choose Folder"]];
    
    [op setCanCreateDirectories:YES];
    
    [op setShowsHiddenFiles:inShowInvisibleFiles];
    
    // window is not wide enough, the buttons overlap
    [op setMinSize:NSMakeSize(480, [op minSize].height)];
    if (startPath) {
        op.directoryURL = [NSURL fileURLWithPath:startPath];
    }
    
    if (window) {
        [op beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
            [self openPanelDidEnd:op returnCode:result contextInfo:NULL];
        }];
    } else
    {
        NSModalResponse returnCode = [op runModal];
        
        [self handleResult:returnCode openPanel:op];
    }
}

- (void)handleResult:(NSModalResponse)result openPanel:(NSOpenPanel*)openPanel;
{
    self.userClickedOK = (result == NSOKButton);

    if (self.userClickedOK)
        self.path = [[openPanel URL] path];

    // must hide the sheet before we send out the action, otherwise our window wont get the action
    [openPanel orderOut:nil];

    // send out the selector
    [NSApp sendAction:self.selector to:self.target from:self];
	
	//[self autorelease];
}

@end
