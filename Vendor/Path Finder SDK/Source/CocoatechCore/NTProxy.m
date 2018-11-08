//
//  NTProxy.m
//  CocoatechCore
//
//  Created by Steve Gehrman on 7/30/08.
//  Copyright 2008 Cocoatech. All rights reserved.
//

#import "NTProxy.h"

@implementation NTProxy

@synthesize object;

+ (NTProxy*)proxyWithObject:(id)theObject;
{
	NTProxy* result = [[NTProxy alloc] init];
	
	result.object = theObject;
	
	return result;
}

- (void)dealloc;
{
	self.object = nil;
}

@end
