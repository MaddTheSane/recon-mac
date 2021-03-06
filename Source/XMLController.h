//
//  XMLController.h
//  Recon
//
//  Created by Sumanth Peddamatham on 6/30/09.
//  Copyright 2009 bafoontecha.com. All rights reserved.
//
//  http://developer.apple.com/documentation/Cocoa/Conceptual/XMLParsing/Articles/UsingParser.html
//

#import <Cocoa/Cocoa.h>

@class Session;
@class Host;
@class Port;
@class OsMatch;
@class OsClass;
@class IpIdSeqValue;
@class TcpSeqValue;
@class TcpTsSeqValue;
@class Port_Script;

@interface XMLController : NSObject <NSXMLParserDelegate>
{
   NSXMLParser *addressParser;
   NSMutableString *currentStringValue;

   // Managed objects that we populate
   Session *currentSession;
   Host *currentHost;
   Port *currentPort;
   OsMatch *currentOsMatch;
   OsClass *currentOsClass;

   // State-machine helper flag
   BOOL inRunstats;   
   
   NSManagedObjectContext *temporaryContext;
   NSEntityDescription *hostEntity;
}


- (void)parseXMLFile:(NSString *)pathToFile inSession:(Session *)session;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict ;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;

@end
