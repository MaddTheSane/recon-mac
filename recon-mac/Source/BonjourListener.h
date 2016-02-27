
#import <Cocoa/Cocoa.h>

@interface BonjourListener : NSObject <NSNetServiceBrowserDelegate> {
   NSNetServiceBrowser *primaryBrowser;
   NSNetServiceBrowser *secondaryBrowser;
   NSMutableArray *services;   
   NSDictionary *bonjourDict;
}

@property (readonly, retain) NSMutableArray *services;

- (void)setBonjourDict;
-(IBAction)search:(id)sender;

@end
