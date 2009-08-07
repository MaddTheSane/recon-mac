#import <Cocoa/Cocoa.h>

@interface ManagingViewController : NSViewController {
   
   NSManagedObjectContext *managedObjectContext;
   NSArrayController *sessionsArrayController;   
   NSArrayController *profilesArrayController;
   
   NSView *workspacePlaceholder;
   
}

@property (retain) NSManagedObjectContext *managedObjectContext;
@property (retain) NSArrayController *sessionsArrayController;
@property (retain) NSArrayController *profilesArrayController;

@property (retain) NSView *workspacePlaceholder;

@end
