//
//  ITIconStore.h
//  iTerm
//
//  Created by Steve Gehrman on 2/2/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITIconStore : NSObject
{
	NSBundle * mCoreTypesBundle;
}

@property (readonly, class, strong) ITIconStore *sharedInstance;

// GenericPreferencesIcon for example
- (nullable NSImage*)image:(NSString*)identifier;

- (NSImage*)popupArrowImage:(NSColor*)color
					  small:(BOOL)small;

@end

NS_ASSUME_NONNULL_END
