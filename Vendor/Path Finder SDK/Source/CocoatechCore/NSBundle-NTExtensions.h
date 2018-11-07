//
//  NSBundle-NTExtensions.h
//  CocoatechCore
//
//  Created by Steve Gehrman on Fri May 16 2003.
//  Copyright (c) 2003 CocoaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (NTExtensions)

- (NSImage*)imageWithName:(NSString*)imageName NS_DEPRECATED_WITH_REPLACEMENT_MAC("imageForResource:", 10_0, 10_7);
- (NSImage*)imageWithName:(NSString*)imageName inDirectory:(NSString*)directory NS_DEPRECATED_MAC(10_0, 10_7, "Use -imageForResource: instead");

@end
