#import <Cocoa/Cocoa.h>

@interface ManagingViewController : NSViewController {
   
   NSManagedObjectContext *managedObjectContext;
   NSArrayController *sessionsArrayController;   
   NSArrayController *profilesArrayController;
   
   NSArrayController *notesInHostArrayController;
   NSArrayController *hostsInSessionArrayController; 
      
   NSView *workspacePlaceholder;
   
}

@property (strong) NSManagedObjectContext *managedObjectContext;
@property (strong) NSArrayController *sessionsArrayController;
@property (strong) NSArrayController *profilesArrayController;

@property (strong) NSArrayController *notesInHostArrayController;
@property (strong) NSArrayController *hostsInSessionArrayController;

@property (strong) NSView *workspacePlaceholder;

@end
