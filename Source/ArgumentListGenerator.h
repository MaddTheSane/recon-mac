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

@interface ArgumentListGenerator : NSObject {

   NSDictionary *__weak nmapArgsBool;   
   NSDictionary *__weak nmapArgsString;
   
   // Dictionary for reverse lookups
   NSDictionary *__weak nmapArgsBoolReverse;   
   NSDictionary *__weak nmapArgsStringReverse;   
   
   NSDictionary *__weak nmapArgsTcpString;
   NSDictionary *__weak nmapArgsNonTcpString;
   NSDictionary *__weak nmapArgsTimingString;

   NSDictionary *__weak nmapArgsTcpStringReverse;
   NSDictionary *__weak nmapArgsNonTcpStringReverse;
   NSDictionary *__weak nmapArgsTimingStringReverse;   
}

@property (readwrite, weak) NSDictionary *nmapArgsBool;
@property (readwrite, weak) NSDictionary *nmapArgsString;

@property (readwrite, weak) NSDictionary *nmapArgsBoolReverse;
@property (readwrite, weak) NSDictionary *nmapArgsStringReverse;

@property (readwrite, weak) NSDictionary *nmapArgsTcpString;
@property (readwrite, weak) NSDictionary *nmapArgsNonTcpString;
@property (readwrite, weak) NSDictionary *nmapArgsTimingString;

@property (readwrite, weak) NSDictionary *nmapArgsTcpStringReverse;
@property (readwrite, weak) NSDictionary *nmapArgsNonTcpStringReverse;
@property (readwrite, weak) NSDictionary *nmapArgsTimingStringReverse;

- (NSArray *) convertProfileToArgs:(Profile *)profile 
                        withTarget:(NSString *)target 
                     withOutputFile:(NSString*)nmapOutput;

- (BOOL)areFlagsValid:(NSArray *)argArray;
- (void)populateProfile:(Profile *)profile withArgString:(NSArray *)argArray;

@end
