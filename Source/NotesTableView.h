//
//  NotesTableView.h
//  recon
//
//  Created by Sumanth Peddamatham on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NotesTableView : NSTableView {

   NSArray<NSColor*> *alternatingColors;
}

@property (copy) NSArray<NSColor*> *alternatingColors;

@end
