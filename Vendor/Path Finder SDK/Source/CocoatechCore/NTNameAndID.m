//
//  NTNameAndID.m
//  CocoatechCore
//
//  Created by Steve Gehrman on 6/24/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "NTNameAndID.h"

// =================================================================

@interface NTNameAndID ()
@property (readwrite, retain) NSNumber *identifierNumber;
@property (readwrite, copy) NSString *name;
@end

@implementation NTNameAndID

- (instancetype)init
{
    return self = [super init];
}

+ (NTNameAndID*)nameAndID:(NSString*)name identifier:(int)identifier;
{
    NTNameAndID* result = [[self alloc] init];
	
    [result setIdentifierNumber:@(identifier)];
    [result setName:name];
	
    return [result autorelease];
}

- (void)dealloc;
{
    [self setName:nil];
	[self setIdentifierNumber:nil];
	
    [super dealloc];
}

//---------------------------------------------------------- 
//  ident 
//---------------------------------------------------------- 
- (int)identifier;
{
    return [[self identifierNumber] intValue];
}

//---------------------------------------------------------- 
//  identifierNumber 
//---------------------------------------------------------- 
@synthesize identifierNumber=mIdentifierNumber;

//---------------------------------------------------------- 
//  name 
//---------------------------------------------------------- 
@synthesize name=mName;

- (BOOL)isEqual:(NTNameAndID*)right;
{
	return ([self identifier] == [right identifier] &&
			[[self name] isEqualToString:[right name]]);
}

- (NSComparisonResult)compare:(NTNameAndID *)right;
{
    return [[self name] compare:[right name]]; 
}

- (NSString*)description;
{
	return [NSString stringWithFormat:@"%@ (%@)", [self name], [[self identifierNumber] description]];
}

@end

@implementation NTNameAndID (Utilities)

+ (NSArray*)names:(NSArray*)nameIDArray;
{
	NSMutableArray *result = [NSMutableArray array];
	NTNameAndID *nameID;
	
	for (nameID in nameIDArray)
	{
		if ([nameID name])
			[result addObject:[nameID name]];
	}
	
	return result;
}

+ (NSArray*)identifiers:(NSArray*)nameIDArray;
{
	NSMutableArray *result = [NSMutableArray array];
	NTNameAndID *nameID;
	
	for (nameID in nameIDArray)
		[result addObject:@([nameID identifier])];
	
	return result;
}

@end

