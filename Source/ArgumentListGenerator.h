//
//  ArgumentListGenerator.h
//  Recon
//
//  Created by Sumanth Peddamatham on 6/30/09.
//  Copyright 2009 bafoontecha.com. All rights reserved.
//
//  Read nmap arguments from managedObject.

//  Read current profile name from interface
//  Search managedObjectContext for Profile entity matching current profile
//  Convert argument array into nmap switch array
//
//  http://www.cocoadevcentral.com/articles/000080.php

#import <Cocoa/Cocoa.h>

@class Profile;

@interface ArgumentListGenerator : NSObject

@property (readwrite, copy) NSDictionary<NSString*,NSString*> *nmapArgsBool;
@property (readwrite, copy) NSDictionary<NSString*,NSString*> *nmapArgsString;

@property (readwrite, copy) NSDictionary<NSString*,NSString*> *nmapArgsBoolReverse;
@property (readwrite, copy) NSDictionary<NSString*,NSString*> *nmapArgsStringReverse;

@property (readwrite, copy) NSDictionary<NSString*,NSString*> *nmapArgsTcpString;
@property (readwrite, copy) NSDictionary<NSString*,NSString*> *nmapArgsNonTcpString;
@property (readwrite, copy) NSDictionary<NSString*,NSString*> *nmapArgsTimingString;

@property (readwrite, copy) NSDictionary<NSString*,NSString*> *nmapArgsTcpStringReverse;
@property (readwrite, copy) NSDictionary<NSString*,NSString*> *nmapArgsNonTcpStringReverse;
@property (readwrite, copy) NSDictionary<NSString*,NSString*> *nmapArgsTimingStringReverse;

- (NSArray<NSString*> *) convertProfileToArgs:(Profile *)profile
                                   withTarget:(NSString *)target 
                               withOutputFile:(NSString*)nmapOutput;

- (BOOL)areFlagsValid:(NSArray<NSString*> *)argArray;
- (void)populateProfile:(Profile *)profile withArgString:(NSArray<NSString*> *)argArray;

@end
