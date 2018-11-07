//
//  NSEvent-Utilities.h
//  CocoatechCore
//
//  Created by Steve Gehrman on Sat Jun 22 2002.
//  Copyright (c) 2002 CocoaTech. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSEvent (Utilities)

@property (class, readonly, getter=isMouseButtonDown) BOOL mouseButtonDown;

// look at the state of the hardware
@property (class, readonly) BOOL controlKeyDownNow;
@property (class, readonly) BOOL optionKeyDownNow;
@property (class, readonly) BOOL commandKeyDownNow;
@property (class, readonly) BOOL shiftKeyDownNow;
@property (class, readonly) BOOL spaceKeyDownNow;
@property (class, readonly) BOOL capsLockDownNow;
+ (NSEventModifierFlags)carbonModifierFlagsToCocoaModifierFlags:(unsigned)aModifierFlags;

// a simple way of looking at the event modifier flags
@property (readonly) BOOL modifierIsDown;
@property (readonly) BOOL controlKeyDown;
@property (readonly) BOOL optionKeyDown;
@property (readonly) BOOL commandKeyDown;
@property (readonly) BOOL shiftKeyDown;

// option key or control key but not both
@property (readonly) BOOL optionXOrCommandKeyDown;
@property (readonly) BOOL openInNewWindowEvent;  // command key down

    // does not dequeue the mouseUp event
// pass nil for timeout to loop forever making sure that mouse is down so it doesn't endless loop
+ (BOOL)isDragEvent:(NSEvent *)event forView:(NSView*)view dragSlop:(CGFloat)dragSlop timeOut:(NSDate*)date;

// these examine clickCount%2 so the 3rd click becomes a single click and the 4th becomes another double click
// you have to do this if the user clicks 4 times expecting events 1,2,1,2 rather than 1,2,3,4
@property (readonly, getter=isSingleClick) BOOL singleClick;
@property (readonly, getter=isDoubleClick) BOOL doubleClick;

@property (readonly, getter=isArrowEvent) BOOL arrowEvent;
@property (readonly, getter=isLeftArrowEvent) BOOL leftArrowEvent;
@property (readonly, getter=isRightArrowEvent) BOOL rightArrowEvent;
@property (readonly, getter=isUpArrowEvent) BOOL upArrowEvent;
@property (readonly, getter=isDownArrowEvent) BOOL downArrowEvent;

@property (readonly, getter=isHomeKeyEvent) BOOL homeKeyEvent;
@property (readonly, getter=isEndKeyEvent) BOOL endKeyEvent;

@property (readonly, getter=isPageUpKeyEvent) BOOL pageUpKeyEvent;
@property (readonly, getter=isPageDownKeyEvent) BOOL pageDownKeyEvent;

@property (readonly, getter=isDeleteKeyEvent) BOOL deleteKeyEvent;
@property (readonly, getter=isReturnKeyEvent) BOOL returnKeyEvent;
@property (readonly, getter=isEscKeyEvent) BOOL escKeyEvent;
@property (readonly, getter=isTabKeyEvent) BOOL tabKeyEvent;
@property (readonly, getter=isShiftTabKeyEvent) BOOL shiftTabKeyEvent;

- (BOOL)characterIsDown:(unichar)theCharacter;
@end

// ---------------------------------------------------------------------------------------------
// keyMap utils

void logKeyMap(KeyMapByteArray keyMap);
void keyMapAddKeyCode(KeyMapByteArray keymap, int keyCode);
void keyMapInvert(KeyMapByteArray keymap);
void keyMapInit(KeyMapByteArray keymap);
BOOL keyMapAND(KeyMapByteArray keymap, KeyMapByteArray keymap2);

#define kNSCommandKeyCode 55
#define kNSShiftKeyCode 56
#define kNSAlphaShiftCode 57
#define kNSAlternateKeyCode 58
#define kNSControlKeyCode 59
#define kNSFunctionKeyCode 63

