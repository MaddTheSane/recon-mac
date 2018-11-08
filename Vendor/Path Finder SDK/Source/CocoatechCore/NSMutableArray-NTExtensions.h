//
//  NSMutableArray-NTExtensions.h
//  CocoatechCore
//
//  Created by Steve Gehrman on 7/30/08.
//  Copyright 2008 Cocoatech. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMutableArray<ObjectType> (NTExtensions)

- (void)reverseOrder;

// avoids exception if nil
- (void)addObjectIf:(ObjectType)anObject;

- (void)removeNTProxyObjectIdenticalTo:(ObjectType)theObject;

- (void)insertObjectsFromArray:(NSArray<ObjectType> *)anArray atIndex:(NSUInteger)anIndex;
- (void)insertObject:(ObjectType)anObject inArraySortedUsingSelector:(SEL)selector;
- (NSUInteger)indexWhereObjectWouldBelong:(ObjectType)anObject inArraySortedUsingSelector:(SEL)selector;

@end
