// $Id: PreferencePanel.m,v 1.152 2007/01/23 04:46:12 yfabian Exp $
/*
 **  PreferencePanel.m
 **
 **  Copyright (c) 2002, 2003
 **
 **  Author: Fabian, Ujwal S. Setlur
 **
 **  Project: iTerm
 **
 **  Description: Implements the model and controller for the preference panel.
 **
 */

#import "PreferencePanel.h"
#import "NSStringITerm.h"
#import "iTermController.h"
#import "ITAddressBookMgr.h"
#import "iTermKeyBindingMgr.h"
#import "iTermDisplayProfileMgr.h"
#import "iTermTerminalProfileMgr.h"
#import "Tree.h"
#import <iTermBookmarkController.h>

static float versionNumber;
static NSString *NoHandler = @"<No Handler>";

@implementation PreferencePanel

+ (PreferencePanel*)sharedInstance;
{
    static PreferencePanel* shared = nil;

    if (!shared)
	{
		shared = [[self alloc] init];
	}
    
    return shared;
}

- (id)init
{
	unsigned int storedMajorVersion = 0, storedMinorVersion = 0, storedMicroVersion = 0;

	self = [super init];
	
	[self readPreferences];
	if (defaultEnableBonjour == YES)
		[[ITAddressBookMgr sharedInstance] locateBonjourServices];
	
	// get the version
	NSDictionary *myDict = [[NSBundle bundleForClass:[self class]] infoDictionary];
	versionNumber = [(NSNumber *)[myDict objectForKey:@"CFBundleVersion"] floatValue];
	if ([prefs objectForKey: @"iTerm Version"])
	{
		sscanf([[prefs objectForKey: @"iTerm Version"] UTF8String], "%d.%d.%d", &storedMajorVersion, &storedMinorVersion, &storedMicroVersion);
		// briefly, version 0.7.0 was stored as 0.70
		if (storedMajorVersion == 0 && storedMinorVersion == 70)
			storedMinorVersion = 7;
	}
	//NSLog(@"Stored version = %d.%d.%d", storedMajorVersion, storedMinorVersion, storedMicroVersion);
	
	
	// sync the version number
	[prefs setObject: [myDict objectForKey:@"CFBundleVersion"] forKey: @"iTerm Version"];

	[[NSNotificationCenter defaultCenter] addObserver: self
									 selector: @selector(_reloadURLHandlers:)
										 name: @"iTermReloadAddressBook"
									   object: nil];	

	return (self);
}


- (void)readPreferences
{
    prefs = [NSUserDefaults standardUserDefaults];
         
	defaultWindowStyle=[prefs objectForKey:@"WindowStyle"]?[prefs integerForKey:@"WindowStyle"]:0;
    defaultTabViewType=[prefs objectForKey:@"TabViewType"]?[prefs integerForKey:@"TabViewType"]:0;
    if (defaultTabViewType>1) defaultTabViewType = 0;
    defaultCopySelection=[prefs objectForKey:@"CopySelection"]?[prefs boolForKey:@"CopySelection"]:YES;
	defaultPasteFromClipboard=[prefs objectForKey:@"PasteFromClipboard"]?[prefs boolForKey:@"PasteFromClipboard"]:YES;
    defaultHideTab=[prefs objectForKey:@"HideTab"]?[prefs boolForKey:@"HideTab"]: NO;
    defaultPromptOnClose = [prefs objectForKey:@"PromptOnClose"]?[prefs boolForKey:@"PromptOnClose"]: NO;
    defaultFocusFollowsMouse = [prefs objectForKey:@"FocusFollowsMouse"]?[prefs boolForKey:@"FocusFollowsMouse"]: NO;
	defaultEnableBonjour = [prefs objectForKey:@"EnableRendezvous"]?[prefs boolForKey:@"EnableRendezvous"]: YES;
	defaultCmdSelection = [prefs objectForKey:@"CommandSelection"]?[prefs boolForKey:@"CommandSelection"]: YES;
	defaultMaxVertically = [prefs objectForKey:@"MaxVertically"]?[[prefs objectForKey:@"MaxVertically"] boolValue]: YES;
	defaultUseCompactLabel = [prefs objectForKey:@"UseCompactLabel"]?[prefs boolForKey:@"UseCompactLabel"]: YES;
	defaultRefreshRate = [prefs objectForKey:@"RefreshRate"]?[prefs integerForKey:@"RefreshRate"]: 25;
	defaultWordChars = [prefs stringForKey: @"WordCharacters"]?:@"";
    defaultOpenBookmark = [prefs objectForKey:@"OpenBookmark"]?[prefs boolForKey:@"OpenBookmark"]: NO;
	defaultCursorType=[prefs objectForKey:@"CursorType"]?[prefs integerForKey:@"CursorType"]:2;
	
	NSArray *urlArray;
	NSDictionary *tempDict = [prefs objectForKey:@"URLHandlers"];
	int i;
	
	// make sure bookmarks are loaded
	[iTermBookmarkController sharedInstance];
    
	// read in the handlers by converting the index back to bookmarks
	urlHandlers = [[NSMutableDictionary alloc] init];
	if (tempDict) {
		NSEnumerator *enumerator = [tempDict keyEnumerator];
		id key;
		int index;
	   
		while ((key = [enumerator nextObject])) {
			//NSLog(@"%@\n%@",[tempDict objectForKey:key], [[ITAddressBookMgr sharedInstance] bookmarkForIndex:[[tempDict objectForKey:key] intValue]]);
			index = [[tempDict objectForKey:key] intValue];
			if (index>=0 && index  < [[[ITAddressBookMgr sharedInstance] bookmarks] count])
				[urlHandlers setObject:[[ITAddressBookMgr sharedInstance] bookmarkForIndex:index]
								forKey:key];
		}
	}
	urlArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
	urlTypes = [[NSMutableArray alloc] initWithCapacity:[urlArray count]];
	for (i=0; i<[urlArray count]; i++) {
		[urlTypes addObject:[[[urlArray objectAtIndex:i] objectForKey: @"CFBundleURLSchemes"] objectAtIndex:0]];
	}
}

- (void)savePreferences
{
    [prefs setBool:defaultCopySelection forKey:@"CopySelection"];
	[prefs setBool:defaultPasteFromClipboard forKey:@"PasteFromClipboard"];
    [prefs setBool:defaultHideTab forKey:@"HideTab"];
	[prefs setInteger:defaultWindowStyle forKey:@"WindowStyle"];
    [prefs setInteger:defaultTabViewType forKey:@"TabViewType"];
    [prefs setBool:defaultPromptOnClose forKey:@"PromptOnClose"];
    [prefs setBool:defaultFocusFollowsMouse forKey:@"FocusFollowsMouse"];
	[prefs setBool:defaultEnableBonjour forKey:@"EnableRendezvous"];
	[prefs setBool:defaultCmdSelection forKey:@"CommandSelection"];
	[prefs setBool:defaultMaxVertically forKey:@"MaxVertically"];
	[prefs setBool:defaultUseCompactLabel forKey:@"UseCompactLabel"];
	[prefs setInteger:defaultRefreshRate forKey:@"RefreshRate"];
	[prefs setObject: defaultWordChars forKey: @"WordCharacters"];
	[prefs setBool:defaultOpenBookmark forKey:@"OpenBookmark"];
	[prefs setObject: [[iTermKeyBindingMgr singleInstance] profiles] forKey: @"iTermKeyBindings"];
	[prefs setObject: [[iTermDisplayProfileMgr singleInstance] profiles] forKey: @"iTermDisplays"];
	[prefs setObject: [[iTermTerminalProfileMgr singleInstance] profiles] forKey: @"iTermTerminals"];
	[prefs setObject: [[ITAddressBookMgr sharedInstance] bookmarks] forKey: @"Bookmarks"];
	[prefs setInteger:defaultCursorType forKey:@"CursorType"];
	
	// save the handlers by converting the bookmark into an index
	NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
	NSEnumerator *enumerator = [urlHandlers keyEnumerator];
	id key;
   
	while ((key = [enumerator nextObject])) {
		[tempDict setObject:[NSNumber numberWithInteger:[[ITAddressBookMgr sharedInstance] indexForBookmark:[urlHandlers objectForKey:key]]]
					 forKey:key];
	}
	[prefs setObject: tempDict forKey:@"URLHandlers"];

	[prefs synchronize];
}

- (void)windowDidLoad
{
	[NTLocalizedString localizeWindow:[self window] table:@"terminal"];
}

- (void)run
{
	
	// load nib if we haven't already
	if ([self window] == nil)
		[self initWithWindowNibName: @"PreferencePanel"];
			    	
	[[self window] setDelegate: self]; // also forces window to load
	[wordChars setDelegate: self];
	
	[windowStyle selectItemAtIndex: defaultWindowStyle];
	[tabPosition selectItemAtIndex: defaultTabViewType];
    [selectionCopiesText setState:defaultCopySelection?NSOnState:NSOffState];
	[middleButtonPastesFromClipboard setState:defaultPasteFromClipboard?NSOnState:NSOffState];
    [hideTab setState:defaultHideTab?NSOnState:NSOffState];
    [promptOnClose setState:defaultPromptOnClose?NSOnState:NSOffState];
	[focusFollowsMouse setState: defaultFocusFollowsMouse?NSOnState:NSOffState];
	[enableBonjour setState: defaultEnableBonjour?NSOnState:NSOffState];
	[cmdSelection setState: defaultCmdSelection?NSOnState:NSOffState];
	[maxVertically setState: defaultMaxVertically?NSOnState:NSOffState];
	[useCompactLabel setState: defaultUseCompactLabel?NSOnState:NSOffState];
    [openBookmark setState: defaultOpenBookmark?NSOnState:NSOffState];
    [refreshRate setIntValue: defaultRefreshRate];
	[wordChars setStringValue: ([defaultWordChars length] > 0)?defaultWordChars:@""];	
	[cursorType selectCellWithTag:defaultCursorType];
    
	[self showWindow: self];
	[[self window] setLevel:CGShieldingWindowLevel()];
	
	// Show the window.
	[[self window] makeKeyAndOrderFront:self];
	
}

- (IBAction)settingChanged:(id)sender
{    

    if (sender == windowStyle || 
        sender == tabPosition ||
        sender == hideTab ||
        sender == useCompactLabel ||
		sender == cursorType)
    {
        defaultWindowStyle = [windowStyle indexOfSelectedItem];
        defaultTabViewType=[tabPosition indexOfSelectedItem];
        defaultUseCompactLabel = ([useCompactLabel state] == NSOnState);
        defaultHideTab=([hideTab state]==NSOnState);
		defaultCursorType = [[cursorType selectedCell] tag];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"iTermRefreshTerminal" object: nil userInfo: nil];    
    }
    else
    {
        defaultCopySelection=([selectionCopiesText state]==NSOnState);
        defaultPasteFromClipboard=([middleButtonPastesFromClipboard state]==NSOnState);
        defaultPromptOnClose = ([promptOnClose state] == NSOnState);
        defaultFocusFollowsMouse = ([focusFollowsMouse state] == NSOnState);
        defaultEnableBonjour = ([enableBonjour state] == NSOnState);
        defaultCmdSelection = ([cmdSelection state] == NSOnState);
        defaultMaxVertically = ([maxVertically state] == NSOnState);
        defaultOpenBookmark = ([openBookmark state] == NSOnState);
        defaultRefreshRate = [refreshRate intValue];
        defaultWordChars = [wordChars stringValue];
    }
}

// NSWindow delegate
- (void)windowWillLoad
{
    // We finally set our autosave window frame name and restore the one from the user's defaults.
    [self setWindowFrameAutosaveName: @"Preferences"];
}

- (void)windowWillClose:(NSNotification *)aNotification
{
	[self savePreferences];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification
{
}

// accessors for preferences

@synthesize copySelection=defaultCopySelection;
@synthesize pasteFromClipboard=defaultPasteFromClipboard;

- (BOOL) hideTab
{
    return (defaultHideTab);
}

@synthesize tabViewType=defaultTabViewType;
@synthesize windowStyle=defaultWindowStyle;

- (BOOL)promptOnClose
{
    return (defaultPromptOnClose);
}

- (BOOL) focusFollowsMouse
{
    return (defaultFocusFollowsMouse);
}

- (BOOL) enableBonjour
{
	return (defaultEnableBonjour);
}

- (BOOL) cmdSelection
{
	return (defaultCmdSelection);
}

- (BOOL) maxVertically
{
	return (defaultMaxVertically);
}

- (BOOL) useCompactLabel
{
	return (defaultUseCompactLabel);
}

- (BOOL) openBookmark
{
	return (defaultOpenBookmark);
}

- (int) refreshRate
{
	return (defaultRefreshRate);
}

- (NSString *) wordChars
{
	if ([defaultWordChars length] <= 0)
		return (@"");
	return (defaultWordChars);
}

@synthesize cursorType=defaultCursorType;

// The following are preferences with no UI, but accessible via "defaults read/write"
// examples:
//  defaults write iTerm UseUnevenTabs -bool true
//  defaults write iTerm MinTabWidth -int 100        
//  defaults write iTerm MinCompactTabWidth -int 120
//  defaults write iTerm OptimumTabWidth -int 100
//  defaults write iTerm StrokeWidth -float -1
//  defaults write iTerm BoldStrokeWidth -float -3

- (BOOL) useUnevenTabs
{
    return [prefs objectForKey:@"UseUnevenTabs"]?[prefs boolForKey:@"UseUnevenTabs"]:NO;
}

- (NSInteger) minTabWidth
{
    return [prefs objectForKey:@"MinTabWidth"]?[prefs integerForKey:@"MinTabWidth"]:75;
}

- (NSInteger) minCompactTabWidth
{
    return [prefs objectForKey:@"MinCompactTabWidth"]?[prefs integerForKey:@"MinCompactTabWidth"]:60;
}

- (NSInteger) optimumTabWidth
{
    return [prefs objectForKey:@"OptimumTabWidth"]?[prefs integerForKey:@"OptimumTabWidth"]:175;
}

- (CGFloat) strokeWidth
{
    return [prefs objectForKey:@"StrokeWidth"]?[prefs doubleForKey:@"StrokeWidth"]:0;
}

- (CGFloat) boldStrokeWidth
{
    return [prefs objectForKey:@"BoldStrokeWidth"]?[prefs doubleForKey:@"BoldStrokeWidth"]:-2;
}

- (NSInteger) cacheSize
{
    return [prefs objectForKey:@"CacheSize"]?[prefs integerForKey:@"CacheSize"]:2048;
}

- (NSString *) searchCommand
{
	return [prefs stringForKey:@"SearchCommand"]?:@"http://google.com/search?q=%@";
}

// URL handler stuff
- (TreeNode *) handlerBookmarkForURL:(NSString *)url
{
	return [urlHandlers objectForKey: url];
}

// NSTableView data source
- (NSInteger) numberOfRowsInTableView: (NSTableView *)aTableView
{
	return [urlTypes count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    //NSLog(@"%s: %@", __PRETTY_FUNCTION__, aTableView);
    
	return [urlTypes objectAtIndex: rowIndex];
}

// NSTableView delegate
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	NSInteger i;
	
    //NSLog(@"%s", __PRETTY_FUNCTION__);
	if ((i=[urlTable selectedRow])<0) 
		[urlHandlerOutline deselectAll:nil];
	else {
		id temp = [urlHandlers objectForKey: [urlTypes objectAtIndex: i]];
		if (temp) {
			[urlHandlerOutline selectRowIndexes:[NSIndexSet indexSetWithIndex: [urlHandlerOutline rowForItem: temp]] byExtendingSelection:NO];
		}
		else {
			[urlHandlerOutline selectRowIndexes:[NSIndexSet indexSetWithIndex: 0] byExtendingSelection:NO];
		}
		[urlHandlerOutline scrollRowToVisible: [urlHandlerOutline selectedRow]];
	}
}

// NSOutlineView delegate methods
- (void)outlineViewSelectionDidChange: (NSNotification *) aNotification
{
}

// NSOutlineView data source methods
// required
- (id)outlineView:(NSOutlineView *)ov child:(NSInteger)index ofItem:(id)item
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
	if (item)
		return [[ITAddressBookMgr sharedInstance] child:index ofItem: item];
	else if (index)
		return [[ITAddressBookMgr sharedInstance] child:index-1 ofItem: item];
	else
		return NoHandler;
}

- (BOOL)outlineView:(NSOutlineView *)ov isItemExpandable:(id)item
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
	if ([item isKindOfClass:[NSString class]])
		return NO;
	else
		return [[ITAddressBookMgr sharedInstance] isExpandable: item];
}

- (NSInteger)outlineView:(NSOutlineView *)ov numberOfChildrenOfItem:(id)item
{
    //NSLog(@"%s: ov = 0x%x; item = 0x%x; numChildren: %d", __PRETTY_FUNCTION__, ov, item,
	//	  [[ITAddressBookMgr sharedInstance] numberOfChildrenOfItem: item]);
	if (item)
		return [[ITAddressBookMgr sharedInstance] numberOfChildrenOfItem: item];
	else
		return [[ITAddressBookMgr sharedInstance] numberOfChildrenOfItem: item] + 1;
}

- (id)outlineView:(NSOutlineView *)ov objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    //NSLog(@"%s: outlineView = 0x%x; item = %@; column= %@", __PRETTY_FUNCTION__, ov, item, [tableColumn identifier]);
	// item should be a tree node witha dictionary data object
	if ([item isKindOfClass:[NSString class]])
        return item;
	else
		return [[ITAddressBookMgr sharedInstance] objectForKey:@"Name" inItem: item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	return NO;
}

- (IBAction)connectURL:(id)sender
{
	NSInteger i, j;

	if ((i=[urlTable selectedRow])<0 ||(j=[urlHandlerOutline selectedRow])<0) return;
	if (!j) { // No Handler
		[urlHandlers removeObjectForKey:[urlTypes objectAtIndex: i]];
	}
	else {
		[urlHandlers setObject:[urlHandlerOutline itemAtRow:j] forKey: [urlTypes objectAtIndex: i]];
		
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4
		CFURLRef cfAppURL = NULL;
		NSURL *appURL = nil;
		OSStatus err;
		BOOL set = NO;
		
		err = LSGetApplicationForURL((__bridge CFURLRef)[NSURL URLWithString:[[urlTypes objectAtIndex: i] stringByAppendingString:@":"]], kLSRolesAll, NULL, &cfAppURL);
		appURL = (__bridge NSURL *)cfAppURL;
		if (err != noErr) {
			set = NSRunAlertPanel([NSString stringWithFormat:NTLocalizedStringFromTableInBundle(@"iTerm is not the default handler for %@. Would you like to set iTerm as the default handler?", @"iTerm", [NSBundle bundleForClass: [self class]], @"URL Handler"), [urlTypes objectAtIndex: i]],
								  @"%@",
								  NTLocalizedStringFromTableInBundle(@"OK",@"iTerm", [NSBundle bundleForClass: [self class]], @"OK"),
								  NTLocalizedStringFromTableInBundle(@"Cancel",@"iTerm", [NSBundle bundleForClass: [self class]], @"Cancel")
								  ,nil, NTLocalizedStringFromTableInBundle(@"There is no handler currently.",@"iTerm", [NSBundle bundleForClass: [self class]], @"URL Handler")) == NSAlertDefaultReturn;
		}
		else if (![[[NSFileManager defaultManager] displayNameAtPath:[appURL path]] isEqualToString:@"iTerm"]) {
			set = NSRunAlertPanel([NSString stringWithFormat:NTLocalizedStringFromTableInBundle(@"iTerm is not the default handler for %@. Would you like to set iTerm as the default handler?", @"iTerm", [NSBundle bundleForClass: [self class]], @"URL Handler"), [urlTypes objectAtIndex: i]],
								  NTLocalizedStringFromTableInBundle(@"The current handler is: %@" ,@"iTerm", [NSBundle bundleForClass: [self class]], @"URL Handler"),
								  NTLocalizedStringFromTableInBundle(@"OK",@"iTerm", [NSBundle bundleForClass: [self class]], @"OK"),
								  NTLocalizedStringFromTableInBundle(@"Cancel",@"iTerm", [NSBundle bundleForClass: [self class]], @"Cancel")
								  ,nil, [[NSFileManager defaultManager] displayNameAtPath:[appURL path]]) == NSAlertDefaultReturn;
		}
			
		if (set) {
			  LSSetDefaultHandlerForURLScheme ((__bridge CFStringRef)[urlTypes objectAtIndex: i],(__bridge CFStringRef)[[NSBundle mainBundle] bundleIdentifier]);
		}
#endif
	}
	//NSLog(@"urlHandlers:%@", urlHandlers);
}

- (IBAction)closeWindow:(id)sender
{
	[[self window] close];
}


// NSTextField delegate
- (void)controlTextDidChange:(NSNotification *)aNotification
{
	defaultWordChars = [wordChars stringValue];
}

- (void)_reloadURLHandlers: (NSNotification *) aNotification
{
	[urlHandlerOutline reloadData];
}

@end
