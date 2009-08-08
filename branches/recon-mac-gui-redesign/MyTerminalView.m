#import "MyTerminalView.h"
#import <CocoatechCore/NTCoreMacros.h>
#import <iTerm/iTermController.h>
#import <iTerm/ITAddressBookMgr.h>
#import <iTerm/ITTerminalView.h>

@implementation MyTerminalView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
}

- (void)awakeFromNib;
{
	// make sure this is initialized (yes goofy, I know)
 	[iTermController sharedInstance];
	
	NSDictionary* dict = [[ITAddressBookMgr sharedInstance] defaultBookmarkData];
	ITTerminalView* term = [ITTerminalView view:dict];
   
   NSLog(@"Dict: %@", dict);
   
	[term setFrame:[self bounds]];
	
	[self addSubview:term];
	[term addNewSession:dict withCommand:nil withURL:nil];
	
	// goofy hack to show window, ignore
	[self performSelector:@selector(showWindow) withObject:nil afterDelay:0];
}

- (void)showWindow;
{
	[[self window] makeKeyAndOrderFront:nil];
}

@end
