//
//  Profile.h
//  recon
//
//  Created by Sumanth Peddamatham on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Session;

@interface Profile: NSManagedObject

@property (nonatomic, strong) NSString * scanDelayString;
@property (nonatomic, strong) NSNumber * icmpTimeStamp;
@property (nonatomic, strong) NSNumber * debuggingLevel;
@property (nonatomic, strong) NSString * maxParallelismString;
@property (nonatomic, strong) NSNumber * minParallelism;
@property (nonatomic, strong) NSString * setSourcePortString;
@property (nonatomic, strong) NSString * scanRandomString;
@property (nonatomic, strong) NSNumber * scriptArgs;
@property (nonatomic, strong) NSNumber * dontPing;
@property (nonatomic, strong) NSNumber * minHostgroup;
@property (nonatomic, strong) NSString * ftpBounceString;
@property (nonatomic, strong) NSNumber * maxTimeToScan;
@property (nonatomic, strong) NSNumber * scriptScan;
@property (nonatomic, strong) NSNumber * maxProbeTimeout;
@property (nonatomic, strong) NSNumber * initialRttTimeout;
@property (nonatomic, strong) NSString * synPingString;
@property (nonatomic, strong) NSNumber * maxOutstandingProbes;
@property (nonatomic, strong) NSString * targetListString;
@property (nonatomic, strong) NSNumber * idleScan;
@property (nonatomic, strong) NSNumber * scanRandom;
@property (nonatomic, strong) NSNumber * excludeFile;
@property (nonatomic, strong) NSNumber * enableAggressive;
@property (nonatomic, strong) NSString * initialRttTimeoutString;
@property (nonatomic, strong) NSNumber * scriptsToRun;
@property (nonatomic, strong) NSNumber * excludeHosts;
@property (nonatomic, strong) NSString * sessionTarget;
@property (nonatomic, strong) NSNumber * minHostsParallel;
@property (nonatomic, strong) NSString * minHostsParallelString;
@property (nonatomic, strong) NSString * maxTimeToScanString;
@property (nonatomic, strong) NSString * debuggingLevelString;
@property (nonatomic, strong) NSNumber * ipv6Support;
@property (nonatomic, strong) NSNumber * synPing;
@property (nonatomic, strong) NSNumber * maxHostgroup;
@property (nonatomic, strong) NSNumber * versionDetection;
@property (nonatomic, strong) NSNumber * verbosity;
@property (nonatomic, strong) NSString * minOutstandingProbesString;
@property (nonatomic, strong) NSNumber * hostTimeout;
@property (nonatomic, strong) NSNumber * initialProbeTimeout;
@property (nonatomic, strong) NSString * useDecoysString;
@property (nonatomic, strong) NSNumber * minDelayBetweenProbes;
@property (nonatomic, strong) NSString * setIPv4TTLString;
@property (nonatomic, strong) NSNumber * traceRoute;
@property (nonatomic, strong) NSString * idleScanString;
@property (nonatomic, strong) NSDate * lastAccessDate;
@property (nonatomic, strong) NSNumber * udpProbe;
@property (nonatomic, strong) NSString * minProbeTimeoutString;
@property (nonatomic, strong) NSString * maxHostsParallelString;
@property (nonatomic, strong) NSString * setSourceIPString;
@property (nonatomic, strong) NSNumber * portsToScan;
@property (nonatomic, strong) NSNumber * osDetection;
@property (nonatomic, strong) NSNumber * fragmentIP;
@property (nonatomic, strong) NSNumber * maxRetries;
@property (nonatomic, strong) NSString * initialProbeTimeoutString;
@property (nonatomic, strong) NSNumber * maxScanDelay;
@property (nonatomic, strong) NSString * excludeHostsString;
@property (nonatomic, strong) NSString * minHostgroupString;
@property (nonatomic, strong) NSNumber * maxParallelism;
@property (nonatomic, strong) NSString * maxScanDelayString;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * traceScript;
@property (nonatomic, strong) NSString * maxRttTimeoutString;
@property (nonatomic, strong) NSString * portsToScanString;
@property (nonatomic, strong) NSString * minParallelismString;
@property (nonatomic, strong) NSNumber * scanDelay;
@property (nonatomic, strong) NSNumber * minOutstandingProbes;
@property (nonatomic, strong) NSString * minDelayBetweenProbesString;
@property (nonatomic, strong) NSNumber * isEnabled;
@property (nonatomic, strong) NSString * ackPingString;
@property (nonatomic, strong) NSNumber * fastScan;
@property (nonatomic, strong) NSNumber * setSourcePort;
@property (nonatomic, strong) NSString * setNetworkInterfaceString;
@property (nonatomic, strong) NSNumber * ipprotoProbe;
@property (nonatomic, strong) NSString * maxRetriesString;
@property (nonatomic, strong) NSNumber * maxHostsParallel;
@property (nonatomic, strong) NSNumber * maxRttTimeout;
@property (nonatomic, strong) NSString * hostTimeoutString;
@property (nonatomic, strong) NSString * scriptsToRunString;
@property (nonatomic, strong) NSString * scriptArgsString;
@property (nonatomic, strong) NSString * maxOutstandingProbesString;
@property (nonatomic, strong) NSNumber * minProbeTimeout;
@property (nonatomic, strong) NSString * excludeFileString;
@property (nonatomic, strong) NSNumber * tcpScanTag;
@property (nonatomic, strong) NSNumber * timingTemplateTag;
@property (nonatomic, strong) NSNumber * minRttTimeout;
@property (nonatomic, strong) NSNumber * icmpNetmask;
@property (nonatomic, strong) NSNumber * packetTrace;
@property (nonatomic, strong) NSString * maxHostgroupString;
@property (nonatomic, strong) NSNumber * targetList;
@property (nonatomic, strong) NSString * minRttTimeoutString;
@property (nonatomic, strong) NSNumber * icmpPing;
@property (nonatomic, strong) NSNumber * ftpBounce;
@property (nonatomic, strong) NSString * udpProbeString;
@property (nonatomic, strong) NSNumber * nonTcpScanTag;
@property (nonatomic, strong) NSNumber * setIPv4TTL;
@property (nonatomic, strong) NSNumber * defaultPing;
@property (nonatomic, strong) NSString * ipprotoProbeString;
@property (nonatomic, strong) NSNumber * setSourceIP;
@property (nonatomic, strong) NSString * verbosityString;
@property (nonatomic, strong) NSNumber * ackPing;
@property (nonatomic, strong) NSString * extraOptionsString;
@property (nonatomic, strong) NSString * maxProbeTimeoutString;
@property (nonatomic, strong) NSNumber * disableReverseDNS;
@property (nonatomic, strong) NSNumber * useDecoys;
@property (nonatomic, strong) NSNumber * disableRandom;
@property (nonatomic, strong) NSNumber * extraOptions;
@property (nonatomic, strong) NSNumber * setNetworkInterface;
@property (nonatomic, strong) NSSet<Session *>* sessions;
@property (nonatomic, strong) NSSet<Profile*>* children;
@property (nonatomic, strong) Profile * parent;

@end


@interface Profile (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet<Session *> *)value;
- (void)removeSessions:(NSSet<Session *> *)value;

- (void)addChildrenObject:(Profile *)value;
- (void)removeChildrenObject:(Profile *)value;
- (void)addChildren:(NSSet<Profile*> *)value;
- (void)removeChildren:(NSSet<Profile*> *)value;

@end

