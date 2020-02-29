//
//  ITMiscNibController.m
//  iTerm
//
//  Created by Steve Gehrman on 1/23/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ITMiscNibController.h"
#import "ITTerminalView.h"
#import "ITAddressBookMgr.h"

@interface ITMiscNibController ()
@property (strong) IBOutlet NSView *commandView;
@end

@implementation ITMiscNibController

- (id)init;
{
	self = [super init];
	
	// load nib
    if (![NSBundle loadNibNamed:@"Misc" owner:self])
    {
        NSLog(@"Failed to load Misc.nib");
        NSBeep();
    }	
	
	return self;
}

//---------------------------------------------------------- 
// dealloc
//---------------------------------------------------------- 
- (void)dealloc
{
    [self setCommandField:nil];
    [self setParameterName:nil];
    [self setParameterPanel:nil];
    [self setParameterPrompt:nil];
    [self setParameterValue:nil];
	[self setCommandView:nil];
}

+ (ITMiscNibController*)controller:(ITTerminalView*)term;
{
	ITMiscNibController* result = [[ITMiscNibController alloc] init];
	
	result->mTerm = term; // not retained
	
	return result;
}

- (IBAction)parameterPanelEnd:(id)sender
{
    [NSApp stopModal];
}

- (NSString *)askUserForString:(NSString *)command window:(NSWindow*)window;
{
	NSMutableString *completeCommand = [[NSMutableString alloc] initWithString:command];
	NSRange r1, r2, currentRange;
	
	while (1)
	{
		currentRange = NSMakeRange(0,[completeCommand length]);
		r1 = [completeCommand rangeOfString:@"$$" options:NSLiteralSearch range:currentRange];
		if (r1.location == NSNotFound)
			break;
		currentRange.location = r1.location + 2;
		currentRange.length -= r1.location + 2;
		r2 = [completeCommand rangeOfString:@"$$" options:NSLiteralSearch range:currentRange];
		if (r2.location == NSNotFound) 
			break;
		
		[[self parameterName] setStringValue: [completeCommand substringWithRange:NSMakeRange(r1.location+2, r2.location - r1.location-2)]];
		[[self parameterValue] setStringValue:@""];
		
		[NSApp beginSheet: [self parameterPanel]
		   modalForWindow: window
			modalDelegate: self
		   didEndSelector: nil
			  contextInfo: nil];
		
		[NSApp runModalForWindow:[self parameterPanel]];
		
		[NSApp endSheet:[self parameterPanel]];
		[[self parameterPanel] orderOut:self];
		
		[completeCommand replaceOccurrencesOfString:[completeCommand  substringWithRange:NSMakeRange(r1.location, r2.location - r1.location+2)] withString:[[self parameterValue] stringValue] options:NSLiteralSearch range:NSMakeRange(0,[completeCommand length])];
	}
	
	return completeCommand;
}

//---------------------------------------------------------- 
//  commandField 
//---------------------------------------------------------- 
@synthesize commandField=mCommandField;

//---------------------------------------------------------- 
//  parameterName 
//---------------------------------------------------------- 
@synthesize parameterName=mParameterName;

//---------------------------------------------------------- 
//  parameterPanel 
//---------------------------------------------------------- 
@synthesize parameterPanel=mParameterPanel;

//---------------------------------------------------------- 
//  parameterPrompt 
//---------------------------------------------------------- 
@synthesize parameterPrompt=mParameterPrompt;

//---------------------------------------------------------- 
//  parameterValue 
//---------------------------------------------------------- 
@synthesize parameterValue=mParameterValue;

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
	int move = [[[aNotification userInfo] objectForKey:@"NSTextMovement"] intValue];
	
	NSString *command =  [[self commandField] stringValue];
	if (command == nil || [[command stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
		return;
				
	switch (move) 
	{
		case 16: // Return key
			[mTerm runCommand:command];
			break;
		case 17: // Tab key
			[mTerm addNewSession: [[ITAddressBookMgr sharedInstance] defaultBookmarkData] withCommand:[self commandField].stringValue withURL:nil];
			break;
		default:
			break;
	}
}

//----------------------------------------------------------
//  commandView 
//---------------------------------------------------------- 
@synthesize commandView=mCommandView;

@end


