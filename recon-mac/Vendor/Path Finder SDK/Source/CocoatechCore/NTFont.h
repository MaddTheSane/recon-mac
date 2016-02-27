//
//  NTFont.h
//  CocoatechCore
//
//  Created by Steve Gehrman on Fri Dec 28 2001.
//  Copyright (c) 2001 CocoaTech. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NTFont : NSObject
{
    NSFont* normal;
    NSFont* bold;
    NSFont* italic;
    NSFont* boldItalic;
}

@property (retain) NSFont* normal;
@property (nonatomic, retain) NSFont* bold;
@property (nonatomic, retain) NSFont* italic;
@property (nonatomic, retain) NSFont* boldItalic;

+ (instancetype)fontWithFont:(NSFont*)font;

// Helvetica Bold - 12pt
- (NSString*)displayString;

@end
