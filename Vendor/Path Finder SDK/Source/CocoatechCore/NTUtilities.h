//
//  NTUtilities.h
//  CocoatechCore
//
//  Created by Steve Gehrman on Mon Dec 17 2001.
//  Copyright (c) 2001 CocoaTech. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NTUtilities : NSObject

+ (NSString*)OSVersionString;
+ (NSString*)OSVersionDescription;

+ (unsigned)versionStringToInt:(NSString*)version;

+ (NSString*)applicationVersion;
+ (NSString*)applicationBuild;

+ (NSNumber*)applicationVersionAsNumber;  // 4.6.2 = 462
+ (NSString*)applicationName;
+ (NSString*)applicationBundleIdentifier;
+ (NSString*)applicationCreatorCode;
+ (NSString*)usersEmailAddress;
+ (NSString *)computerName;
+ (NSString*)ipAddress:(NSString**)outInterface;

+ (BOOL)runningOnTiger;
+ (BOOL)runningOnLeopard;
+ (BOOL)runningOnSnowLeopard;

// 0x1047 == 10.4.7
+ (BOOL)osVersionIsAtLeast:(unsigned)osVersion __OSX_AVAILABLE_BUT_DEPRECATED_MSG(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA, "Use NSProcessInfo's operatingSystemVersion property instead.");

    // OSType code conversion
+ (OSType)stringToInt:(NSString*)stringValue;
+ (NSString*)intToString:(OSType)intValue;
+ (NSString*)MACAddress;

+ (BOOL)runningInDebugger;

// uses NSWorkspace to trash
+ (void)moveToTrash:(NSString*)path;
+ (void)moveContentsToTrash:(NSString*)folder;

@end

void NSLogRect(NSString* title, NSRect rect);
void NSLogErr(NSString* title, OSStatus err);
NSString* NSErrorString(OSStatus error);