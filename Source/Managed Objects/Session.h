//
//  Session.h
//  recon
//
//  Created by Sumanth Peddamatham on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Host;
@class Profile;

@interface Session :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * nmapOutputStdout;
@property (nonatomic, strong) NSString * target;
@property (nonatomic, strong) NSString * nmapOutputXml;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * nmapOutputStderr;
@property (nonatomic, strong) NSNumber * hostsDown;
@property (nonatomic, strong) NSNumber * hostsUp;
@property (nonatomic, strong) NSString * UUID;
@property (nonatomic, strong) NSNumber * progress;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSNumber * hostsTotal;
@property (nonatomic, strong) NSSet* hosts;
@property (nonatomic, strong) Profile * profile;

@end


@interface Session (CoreDataGeneratedAccessors)
- (void)addHostsObject:(Host *)value;
- (void)removeHostsObject:(Host *)value;
- (void)addHosts:(NSSet *)value;
- (void)removeHosts:(NSSet *)value;

@end

