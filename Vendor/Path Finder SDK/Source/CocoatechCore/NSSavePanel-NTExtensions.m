//
//  NSSavePanel-NTExtensions.m
//  CocoatechCore
//
//  Created by Steve Gehrman on 10/31/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import "NSSavePanel-NTExtensions.h"

@implementation NSSavePanel (NTExtensions)

- (BOOL)handleSavePanelOK:(NSModalResponse)returnCode;
{
	if (returnCode == NSModalResponseOK)
	{
		BOOL isDirectory;
		
		// replace file
		if (![[NSFileManager defaultManager] fileExistsAtPath:[[self URL] path] isDirectory:&isDirectory])
			return YES;  // file doesn't exist, return YES for success
		else
		{
			// only replace files, this is sync, so a folder might be too slow if large
			if (!isDirectory)
			{
				NSError *error=nil;
				
				[[NSFileManager defaultManager] removeItemAtPath:[[self URL] path] error:&error];
				
				if (error)
					NSLog(@"%@", [error description]);
				else
					return YES;  // deleted file, return YES for success
			}
		}
	}
	
	return NO;
}

@end
