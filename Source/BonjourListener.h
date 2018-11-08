
#import <Cocoa/Cocoa.h>

@interface BonjourListener : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
   NSNetServiceBrowser *primaryBrowser;
   NSNetServiceBrowser *secondaryBrowser;
   NSMutableArray *services;   
   NSDictionary *bonjourDict;
}

@property (readonly, strong) NSMutableArray *services;

- (void)setBonjourDict;
-(IBAction)search:(id)sender;

@end
