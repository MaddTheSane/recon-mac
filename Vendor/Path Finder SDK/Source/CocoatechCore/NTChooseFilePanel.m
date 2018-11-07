//
//  NTChooseFilePanel.m
//  CocoatechCore
//
//  Created by sgehrman on Mon Aug 27 2001.
//  Copyright (c) 2001 CocoaTech. All rights reserved.
//

#import "NTChooseFilePanel.h"
#import "NSSavePanel-NTExtensions.h"

@interface NTChooseFilePanel ()
- (void)startPanel:(NSString*)startPath window:(NSWindow*)window fileType:(ChooseFileTypeEnum)fileType showInvisibleFiles:(BOOL)showInvisibleFiles;
@end

@interface NTChooseFilePanel ()
@property (readwrite, copy) NSString *path;
@property (readwrite) BOOL userClickedOK;
@property SEL selector;
@property (retain) id target;
@end

@implementation NTChooseFilePanel

- (id)initWithTarget:(id)target selector:(SEL)inSelector;
{
    self = [super init];

    [self setSelector:inSelector];
    [self setTarget:target];

    return self;
}

//---------------------------------------------------------- 
// dealloc
//---------------------------------------------------------- 
- (void)dealloc
{
    [self setPath:nil];
    [self setTarget:nil];
    [super dealloc];
}

+ (void)openFile:(NSString*)startPath window:(NSWindow*)window target:(id)target selector:(SEL)inSelector fileType:(ChooseFileTypeEnum)fileType;
{
	[self openFile:startPath window:window target:target selector:inSelector fileType:fileType showInvisibleFiles:NO];
}

+ (void)openFile:(NSString*)startPath window:(NSWindow*)window target:(id)target selector:(SEL)inSelector fileType:(ChooseFileTypeEnum)fileType showInvisibleFiles:(BOOL)showInvisibleFiles;
{
    NTChooseFilePanel *panel = [[NTChooseFilePanel alloc] initWithTarget:target selector:inSelector];

    [panel startPanel:startPath window:window fileType:fileType showInvisibleFiles:showInvisibleFiles];
}

//---------------------------------------------------------- 
//  path 
//---------------------------------------------------------- 
@synthesize path=mPath;

//---------------------------------------------------------- 
//  selector 
//---------------------------------------------------------- 
@synthesize selector=mSelector;

//---------------------------------------------------------- 
//  target 
//---------------------------------------------------------- 
@synthesize target=mTarget;

//---------------------------------------------------------- 
//  userClickedOK 
//---------------------------------------------------------- 
@synthesize userClickedOK=mUserClickedOK;

- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(NSInteger)returnCode contextInfo:(__unused void *)contextInfo
{
    if (returnCode == NSOKButton)
    {
		[self setUserClickedOK:YES];
        [self setPath:[[sheet URL] path]];
	}
	
	[sheet orderOut:self];
	
	// send out the selector
	[[self target] performSelector:[self selector] withObject:self];
	
    [self autorelease];
}

- (void)startPanel:(NSString*)startPath window:(NSWindow*)window fileType:(ChooseFileTypeEnum)fileType showInvisibleFiles:(BOOL)showInvisibleFiles;
{
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setCanChooseDirectories:(fileType == kFilesAndFoldersType) ? YES : NO];
    [op setCanChooseFiles:YES];
    [op setAllowsMultipleSelection:NO];
    [op setShowsHiddenFiles:showInvisibleFiles];
    
    if (fileType == kApplicationFileType)
        [op setPrompt:[NTLocalizedString localize:@"Choose Application" table:@"CocoaTechBase"]];
    else if (fileType == kImageFileType)
        [op setPrompt:[NTLocalizedString localize:@"Choose Image" table:@"CocoaTechBase"]];
    else if (fileType == kGenericFileType || fileType == kTextFileType || fileType == kFilesAndFoldersType)
        [op setPrompt:[NTLocalizedString localize:@"Choose File" table:@"CocoaTechBase"]];
    
    // window is not wide enough, the buttons overlap
    [op setMinSize:NSMakeSize(480, [op minSize].height)];
    if (startPath) {
        op.directoryURL = [NSURL fileURLWithPath:startPath];
    }
    
    if (window) {
        [op beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
            [self openPanelDidEnd:op returnCode:result contextInfo:NULL];
        }];
    }
    else
    {
        NSModalResponse result = [op runModal];
        if (result == NSOKButton)
        {
            [self setUserClickedOK:YES];
            [self setPath:[[op URL] path]];
        }
        
        // must hide the sheet before we send out the action, otherwise our window wont get the action
        [op orderOut:nil];
        
        // send out the selector
        [[self target] performSelector:[self selector] withObject:self];
        
        [self autorelease];
    }
}

@end


