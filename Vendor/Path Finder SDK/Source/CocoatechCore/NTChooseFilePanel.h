//
//  NTChooseFilePanel.h
//  CocoatechCore
//
//  Created by sgehrman on Mon Aug 27 2001.
//  Copyright (c) 2001 CocoaTech. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, ChooseFileTypeEnum)
{
    kApplicationFileType,
    kImageFileType,
    kTextFileType,
    kGenericFileType,
	kFilesAndFoldersType
};

// this will autodelete itself when done.
@interface NTChooseFilePanel : NSObject
{
    NSString* mPath;
    SEL mSelector;
    id mTarget;
    BOOL mUserClickedOK;
}

// selector should be a normal action type selector, [sender path] to get path selected
+ (void)openFile:(NSString*)startPath window:(NSWindow*)window target:(id)target selector:(SEL)inSelector fileType:(ChooseFileTypeEnum)fileType;
+ (void)openFile:(NSString*)startPath window:(NSWindow*)window target:(id)target selector:(SEL)inSelector fileType:(ChooseFileTypeEnum)fileType showInvisibleFiles:(BOOL)showInvisibleFiles;

@property (readonly, copy) NSString *path;
@property (readonly) BOOL userClickedOK;

@end
