//
//  HostNote.h
//  recon
//
//  Created by Sumanth Peddamatham on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Host;

@interface HostNote :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSData * text;
@property (nonatomic, strong) Host * host;

@end



