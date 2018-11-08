//
//  Host.h
//  recon
//
//  Created by Sumanth Peddamatham on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class TcpSeqValue;
@class OsMatch;
@class Port;
@class TcpTsSeqValue;
@class HostNote;
@class Session;
@class OsClass;
@class IpIdSeqValue;

@interface Host :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * macAddress;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * ipIdSequenceClass;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSString * statusReason;
@property (nonatomic, strong) NSString * tcpSequenceIndex;
@property (nonatomic, strong) NSString * tcpTsSequenceClass;
@property (nonatomic, strong) NSString * uptimeSeconds;
@property (nonatomic, strong) NSString * ipv4Address;
@property (nonatomic, strong) NSString * uptimeLastBoot;
@property (nonatomic, strong) NSString * tcpSequenceDifficulty;
@property (nonatomic, strong) NSString * hostname;
@property (nonatomic, strong) NSNumber * isSelected;
@property (nonatomic, strong) NSSet* tcpsequencevalues;
@property (nonatomic, strong) NSSet* osmatches;
@property (nonatomic, strong) NSSet* ports;
@property (nonatomic, strong) NSSet* tcptssequencevalues;
@property (nonatomic, strong) NSSet* notes;
@property (nonatomic, strong) Session * session;
@property (nonatomic, strong) NSSet* osclasses;
@property (nonatomic, strong) NSSet* ipidsequencevalues;

@end


@interface Host (CoreDataGeneratedAccessors)
- (void)addTcpsequencevaluesObject:(TcpSeqValue *)value;
- (void)removeTcpsequencevaluesObject:(TcpSeqValue *)value;
- (void)addTcpsequencevalues:(NSSet *)value;
- (void)removeTcpsequencevalues:(NSSet *)value;

- (void)addOsmatchesObject:(OsMatch *)value;
- (void)removeOsmatchesObject:(OsMatch *)value;
- (void)addOsmatches:(NSSet *)value;
- (void)removeOsmatches:(NSSet *)value;

- (void)addPortsObject:(Port *)value;
- (void)removePortsObject:(Port *)value;
- (void)addPorts:(NSSet *)value;
- (void)removePorts:(NSSet *)value;

- (void)addTcptssequencevaluesObject:(TcpTsSeqValue *)value;
- (void)removeTcptssequencevaluesObject:(TcpTsSeqValue *)value;
- (void)addTcptssequencevalues:(NSSet *)value;
- (void)removeTcptssequencevalues:(NSSet *)value;

- (void)addNotesObject:(HostNote *)value;
- (void)removeNotesObject:(HostNote *)value;
- (void)addNotes:(NSSet *)value;
- (void)removeNotes:(NSSet *)value;

- (void)addOsclassesObject:(OsClass *)value;
- (void)removeOsclassesObject:(OsClass *)value;
- (void)addOsclasses:(NSSet *)value;
- (void)removeOsclasses:(NSSet *)value;

- (void)addIpidsequencevaluesObject:(IpIdSeqValue *)value;
- (void)removeIpidsequencevaluesObject:(IpIdSeqValue *)value;
- (void)addIpidsequencevalues:(NSSet *)value;
- (void)removeIpidsequencevalues:(NSSet *)value;

@end

