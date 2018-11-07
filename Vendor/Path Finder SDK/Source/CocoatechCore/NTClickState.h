//
//  NTClickState.h
//  CocoatechCore
//
//  Created by Steve Gehrman on Tue Aug 13 2002.
//  Copyright (c) 2002 CocoaTech. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NTClickState : NSObject
{
    BOOL _handled;  // set to true when click doesn't require any more processing

    NSInteger _renameOnMouseUpIndex;
    
    NSEvent* _event;
}

+ (NTClickState*)clickState:(NSEvent*)event;

@property (getter=isHandled) BOOL handled;

@property (readonly) BOOL tryRenameOnMouseUp;
@property (setter=setTryRenameOnMouseUpIndex:) NSInteger renameOnMouseUpIndex;

@property (readonly, retain) NSEvent *event;

@property (readonly,getter=isDoubleClick) BOOL doubleClick;
@property (readonly,getter=isSingleClick) BOOL singleClick;

@property (readonly,getter=isRightClick) BOOL rightClick;
@property (readonly,getter=isLeftClick) BOOL leftClick;

@property (readonly,getter=isContextualMenuClick) BOOL contextualMenuClick;  //!< either rightMouseDown, or leftMouseDown and controlKeyDown

@property (readonly) BOOL anyModifierDown;
@property (readonly,getter=isShiftDown) BOOL shiftDown;
@property (readonly,getter=isControlDown) BOOL controlDown;
@property (readonly,getter=isCommandDown) BOOL commandDown;
@property (readonly,getter=isOptionDown) BOOL optionDown;

- (NSPoint)mousePointForView:(NSView*)view;  //!< in views coordinates
@property (readonly) NSPoint mousePointInWindow;  //!< in window coordinates

@end
