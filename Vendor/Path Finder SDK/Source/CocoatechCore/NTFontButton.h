//
//  NTFontButton.h
//  CocoatechCore
//
//  Created by Steve Gehrman on Sun Dec 29 2002.
//  Copyright (c) 2002 CocoaTech. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NTFont;
@protocol NTFontButtonDelegate;

@interface NTFontButton : NSButton
{
    __unsafe_unretained id<NTFontButtonDelegate> delegate;

    NTFont* displayedFont;
}

@property (assign) IBOutlet id<NTFontButtonDelegate> delegate;  // not retained
@property (nonatomic, retain) NTFont* displayedFont;

- (IBAction)setFontUsingFontPanel:(id)sender;

@end

@protocol NTFontButtonDelegate <NSObject>
- (void)fontButton:(NTFontButton *)fontButton didChangeToFont:(NTFont *)newFont;
@end

