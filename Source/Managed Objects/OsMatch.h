//
//  OsMatch.h
//  recon
//
//  Created by Sumanth Peddamatham on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Host;

@interface OsMatch :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * line;
@property (nonatomic, strong) NSString * accuracy;
@property (nonatomic, strong) Host * host;

@end



