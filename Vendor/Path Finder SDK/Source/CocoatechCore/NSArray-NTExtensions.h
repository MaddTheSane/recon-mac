/*
 *  NSArray-NTExtensions.h
 *  CocoatechCore
 *
 *  Created by Steve Gehrman on 10/22/04.
 *  Copyright 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (NTExtensions)

//! not very efficient, but useful when your not dealing with a mutable array and need to make an ocasional change
- (NSArray<ObjectType>*)arrayByReplacingObjectAtIndex:(NSInteger)index withObject:(ObjectType)newItem;

- (nullable ObjectType)safeObjectAtIndex:(NSUInteger)index;

- (BOOL)validIndex:(NSUInteger)index;
- (BOOL)validInsertIndex:(NSUInteger)index;

- (NSArray<ObjectType>*)arrayByRemovingDuplicates;  //!< returns same pointer if no changes needed

- (NSArray<ObjectType> *)arrayByAddingObjectToFront:(ObjectType)anObject;

//! used in tabView, we want to reorder the "tab array" while preserving the selection
+ (BOOL)moveSource:(NSUInteger*)ioSrcIndex 
			toDest:(NSUInteger*)ioDestIndex
		 selection:(NSUInteger*)ioSelectionIndex;

- (NSArray<ObjectType> *)arrayByRemovingObjectIdenticalTo:(ObjectType)anObject;
- (NSArray<ObjectType> *)arrayByRemovingObject:(ObjectType)anObject;

- (NSMutableArray *)deepMutableCopy;
- (NSArray *)arrayByPerformingSelector:(SEL)aSelector;
- (NSArray *)arrayByPerformingSelector:(SEL)aSelector withObject:(nullable id)anObject;

- (NSArray<ObjectType> *)reversedArray;

@end

NS_ASSUME_NONNULL_END
