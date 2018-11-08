//
//  NetstatConnection.m
//  Recon
//
//  Created by Sumanth Peddamatham on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetstatConnection.h"


@implementation NetstatConnection

- (id)init
{
   return [self initWithLocalIP:@"HI" 
                    andLocalPort:@"HI"            
                    andRemoteIP:@"HI" 
                    andRemotePort:@"HI"            
                      andStatus:@"HI"];
}

- (id)initWithLocalIP:(NSString *)lIP 
         andLocalPort:(NSString *)lP 
          andRemoteIP:(NSString *)rIP 
        andRemotePort:(NSString *)rP 
            andStatus:(NSString *)s;
{
   if (!(self = [super init])) return nil;
   
   self.localIP = lIP;
   self.localPort = lP;   
   self.remoteIP = rIP;
   self.remotePort = rP;   
   self.status = s;
   
   return self;
}

@synthesize localIP;
@synthesize localPort;
@synthesize remoteIP;
@synthesize remotePort;
@synthesize status;

@end
