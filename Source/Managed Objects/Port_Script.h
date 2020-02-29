//
//  Port_Script.h
//  recon
//
//  Created by Sumanth Peddamatham on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Port;

@interface Port_Script: NSManagedObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * output;
@property (nonatomic, strong) Port * port;

@end



