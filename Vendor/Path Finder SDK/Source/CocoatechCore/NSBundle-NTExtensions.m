//
//  NSBundle-NTExtensions.m
//  CocoatechCore
//
//  Created by Steve Gehrman on Fri May 16 2003.
//  Copyright (c) 2003 CocoaTech. All rights reserved.
//

#import "NSBundle-NTExtensions.h"
#import <AppKit/AppKit.h>

@implementation NSBundle (NTExtensions)

- (NSImage*)imageWithName:(NSString*)imageName;
{
    return [self imageForResource:[imageName stringByDeletingPathExtension]];
}

- (NSImage*)imageWithName:(NSString*)imageName inDirectory:(NSString*)directory;
{
    NSString *path = [directory stringByAppendingPathComponent:[imageName stringByDeletingPathExtension]];
    return [self imageForResource:path];
}

@end
