//
//  Port.h
//  recon
//
//  Created by Sumanth Peddamatham on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Host;
@class Port_Script;

@interface Port :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSString * serviceMethod;
@property (nonatomic, strong) NSString * serviceOsType;
@property (nonatomic, strong) NSString * serviceProduct;
@property (nonatomic, strong) NSString * stateReasonTTL;
@property (nonatomic, strong) NSString * serviceDeviceType;
@property (nonatomic, strong) NSString * stateReason;
@property (nonatomic, strong) NSString * protocol;
@property (nonatomic, strong) NSString * serviceName;
@property (nonatomic, strong) NSString * serviceConf;
@property (nonatomic, strong) NSString * serviceVersion;
@property (nonatomic, strong) Host * host;
@property (nonatomic, strong) NSSet<Port_Script*>* scripts;

@end


@interface Port (CoreDataGeneratedAccessors)
- (void)addScriptsObject:(Port_Script *)value;
- (void)removeScriptsObject:(Port_Script *)value;
- (void)addScripts:(NSSet<Port_Script*> *)value;
- (void)removeScripts:(NSSet<Port_Script*> *)value;

@end

