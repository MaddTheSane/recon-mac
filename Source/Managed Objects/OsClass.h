//
//  OsClass.h
//  recon
//
//  Created by Sumanth Peddamatham on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Host;

@interface OsClass :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * accuracy;
@property (nonatomic, strong) NSString * family;
@property (nonatomic, strong) NSString * vendor;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * gen;
@property (nonatomic, strong) Host * host;

@end



