//
//  NTSimpleAlert.m
//  CocoatechCore
//
//  Created by sgehrman on Thu Aug 30 2001.
//  Copyright (c) 2001 CocoaTech. All rights reserved.
//

#import "NTSimpleAlert.h"

@implementation NTSimpleAlert

+ (void)alertSheet:(NSWindow*)window message:(NSString*)message subMessage:(NSString*)subMessage;
{
	if (!window)
		[self alertPanel:message subMessage:subMessage];
	else
	{		
		// these routines don't like nil
		if (subMessage == nil)
			subMessage = @"";
		
		NSBeginAlertSheet(message, [NTLocalizedString localize:@"OK" table:@"CocoaTechBase"], nil, nil,
						  window, nil, NULL, NULL, nil, @"%@", subMessage);
	}
}

+ (void)criticalAlertSheet:(NSWindow*)window message:(NSString*)message subMessage:(NSString*)subMessage;
{
	if (!window)
		[self criticalAlertPanel:message subMessage:subMessage];
	else
	{
		// these routines don't like nil
		if (subMessage == nil)
			subMessage = @"";
		
		NSBeginCriticalAlertSheet(message, [NTLocalizedString localize:@"OK" table:@"CocoaTechBase"], nil, nil,
								  window, nil, NULL, NULL, nil, @"%@", subMessage);
	}
}
	
+ (void)infoSheet:(NSWindow*)window message:(NSString*)message subMessage:(NSString*)subMessage;
{
	if (!window)
		[self infoPanel:message subMessage:subMessage];
	else
	{
		// these routines don't like nil
		if (subMessage == nil)
			subMessage = @"";
		
		NSBeginInformationalAlertSheet(message, [NTLocalizedString localize:@"OK" table:@"CocoaTechBase"], nil, nil,
									   window, nil, NULL, NULL, nil, @"%@", subMessage);
	}
}

+ (void)alertPanel:(NSString*)message subMessage:(NSString*)subMessage;
{
    // these routines don't like nil
    if (subMessage == nil)
        subMessage = @"";

    NSRunAlertPanel(message, @"%@", [NTLocalizedString localize:@"OK" table:@"CocoaTechBase"], nil, nil, subMessage);
}

+ (void)criticalAlertPanel:(NSString*)message subMessage:(NSString*)subMessage;
{
    // these routines don't like nil
    if (subMessage == nil)
        subMessage = @"";

    NSRunCriticalAlertPanel(message, @"%@", [NTLocalizedString localize:@"OK" table:@"CocoaTechBase"], nil, nil, subMessage);
}

+ (void)infoPanel:(NSString*)message subMessage:(NSString*)subMessage;
{
    // these routines don't like nil
    if (subMessage == nil)
        subMessage = @"";

    NSRunInformationalAlertPanel(message, @"%@", [NTLocalizedString localize:@"OK" table:@"CocoaTechBase"], nil, nil, subMessage);
}

@end
