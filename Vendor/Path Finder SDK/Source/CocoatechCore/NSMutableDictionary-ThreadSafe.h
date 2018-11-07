//
//  NSMutableDictionary-ThreadSafe.h
//  CocoatechCore
//
//  Created by Steve Gehrman on Thu Sep 12 2002.
//  Copyright (c) 2002 CocoaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSMutableDictionaryThreadSafeProtocol <NSObject>

- (id)safeObjectForKey:(id)aKey;

- (void)safeRemoveObjectForKey:(id)aKey;
- (void)safeRemoveObjectsForKeys:(NSArray*)keys;
- (void)safeRemoveAllObjects;
- (void)safeRemoveObject:(id)anObject;
- (void)safeRemoveObjects:(NSArray*)objects;

- (void)safeSetObject:(id)anObject
					  forKey:(id)aKey;

	// returns a copy of the array
- (NSArray*)safeAllValues;
- (NSArray*)safeAllKeys;

- (NSEnumerator*)safeKeyEnumerator;
- (NSEnumerator*)safeObjectEnumerator;

@property (readonly) NSUInteger safeCount;

- (id)safeKeyForObjectIdenticalTo:(id)anObject;

@end

@interface NSMutableDictionary<KeyType, ObjectType> (ThreadSafe) <NSMutableDictionaryThreadSafeProtocol>
- (ObjectType)safeObjectForKey:(KeyType)aKey;

- (void)safeRemoveObjectForKey:(KeyType)aKey;
- (void)safeRemoveObjectsForKeys:(NSArray<KeyType>*)keys;
- (void)safeRemoveAllObjects;
- (void)safeRemoveObject:(ObjectType)anObject;
- (void)safeRemoveObjects:(NSArray<ObjectType>*)objects;

- (void)safeSetObject:(ObjectType)anObject
               forKey:(KeyType)aKey;

// returns a copy of the array
- (NSArray<ObjectType>*)safeAllValues;
- (NSArray<KeyType>*)safeAllKeys;

- (NSEnumerator<KeyType>*)safeKeyEnumerator;
- (NSEnumerator<ObjectType>*)safeObjectEnumerator;

- (KeyType)safeKeyForObjectIdenticalTo:(ObjectType)anObject;
@end
