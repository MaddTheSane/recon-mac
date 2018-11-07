//
//  NTPath.h
//  CocoatechCore
//
//  Created by Steve Gehrman on Wed Oct 09 2002.
//  Copyright (c) 2002 CocoaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTPath : NSObject
{
    NSString* mv_path;
	NSString* mv_name;
	
    char* mv_fileSystemPath;
    UInt8* mv_UTF8Path;
}

- (instancetype)initWithPath:(NSString*)path;
- (instancetype)initWithFileSystemPath:(const char*)fileSystemPath length:(int)length;

+ (instancetype)pathWithPath:(NSString*)path;

- (NSString*)path;
- (const char *)fileSystemPath NS_RETURNS_INNER_POINTER;
- (const char *)fileSystemRepresentation NS_RETURNS_INNER_POINTER;
- (const UInt8 *)UTF8Path NS_RETURNS_INNER_POINTER;

- (NSString*)name;
- (NSString*)parentPath;

@end
