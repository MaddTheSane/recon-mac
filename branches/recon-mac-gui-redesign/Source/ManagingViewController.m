#import "ManagingViewController.h"

@implementation ManagingViewController

@synthesize managedObjectContext;
@synthesize sessionsArrayController;
@synthesize profilesArrayController;
@synthesize workspacePlaceholder;

- (void)dealloc
{
   [managedObjectContext release];
   [sessionsArrayController release];
   [profilesArrayController release];   
   [workspacePlaceholder release];
   
   [super dealloc];
}

@end
