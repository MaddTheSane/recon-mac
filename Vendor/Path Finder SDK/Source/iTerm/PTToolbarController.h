/*
 **  PTToolbarController.h
 **
 **  Copyright (c) 2002, 2003
 **
 **  Author: Fabian, Ujwal S. Setlur
 **	     Initial code by Kiichi Kusama
 **
 **  Project: iTerm
 **
 **  Description: manages an the toolbar.
 **
 */

#import <Cocoa/Cocoa.h>

extern NSToolbarItemIdentifier const NewToolbarItem;
extern NSToolbarItemIdentifier const ABToolbarItem;
extern NSToolbarItemIdentifier const CloseToolbarItem;
extern NSToolbarItemIdentifier const SettingsToolbarItem;
extern NSToolbarItemIdentifier const CommandToolbarItem;

@class ITTerminalView;

@interface PTToolbarController : NSObject <NSToolbarDelegate>
{
    NSToolbar* mToolbar;
    ITTerminalView* mTerm;
}

- (id)initWithWindow:(NSWindow*)window 
	  term:(ITTerminalView*)term;

@end
