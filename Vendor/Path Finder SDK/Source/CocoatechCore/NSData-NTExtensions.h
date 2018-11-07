//
//  NSData-NTExtensions.h
//  CocoatechCore
//
//  Created by Steve Gehrman on 2/5/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSData (NTExtensions)

- (NSData *)inflate;
+ (NSData*)inflateFile:(NSString*)path;

+ (NSData*)dataWithCarbonHandle:(Handle)handle __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA);
- (Handle)carbonHandle __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA);

- (NSData*)encrypt;
- (NSData*)decrypt;

- (NSData *)md5Signature;
+ (instancetype)dataWithBase64String:(NSString *)base64String;
- (instancetype)initWithBase64String:(NSString *)base64String;
- (NSString *)base64String;

@end
