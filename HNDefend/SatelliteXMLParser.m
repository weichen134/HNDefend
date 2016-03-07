//
//  SatelliteXMLParser.m
//  navag
//
//  Created by DY LOU on 10-8-15.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "SatelliteXMLParser.h"
#import "SatelliteController.h"

@implementation SatelliteXMLParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
    
    if ([[elementName lowercaseString] isEqualToString:@"string"]) {
		contentOfCurrentElement=[NSMutableString string];
    }else{
		contentOfCurrentElement=nil;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
    if (qName) {
        elementName = qName;
    }
    
	if([[elementName lowercaseString] isEqualToString:@"string"]){
		//add to list
		SatelliteController *tc=[SatelliteController sharedController];
		NSString *item = (contentOfCurrentElement==nil?@"":contentOfCurrentElement);
		[tc performSelectorOnMainThread:@selector(getYTPath:) withObject:item waitUntilDone:YES];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (contentOfCurrentElement) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [contentOfCurrentElement appendString:string];
    }
}

@end

///////////////////////////////////////////

@implementation SatelliteInfo
@synthesize sType;
@synthesize sPath;

+(id)satelliteinfo{
	return [[self alloc] init];
}

@end

////////////////////////////////////////////

@implementation SatelliteAllXMLParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
    
    if ([elementName isEqualToString:@"Table"]) {
        // An Table in the RSS feed represents an earthquake, so create an instance of it.
        item = [SatelliteInfo satelliteinfo] ;
        return;
    }
	
    if ([[elementName lowercaseString] isEqualToString:@"imagetype"]) {
		contentOfCurrentElement=[NSMutableString string];
		
	}else if([[elementName lowercaseString] isEqualToString:@"path"]){
		contentOfCurrentElement = [NSMutableString string];
		
	}else{
        // The element isn't one that we care about, so set the property that holds the 
        // character content of the current element to nil. That way, in the parser:foundCharacters:
        // callback, the string that the parser reports will be ignored.
        contentOfCurrentElement = nil;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
    if (qName) {
        elementName = qName;
    }
    
	if([elementName isEqualToString:@"Table"]){
		//add to list
		SatelliteController *tc=[SatelliteController sharedController];
		[tc performSelectorOnMainThread:@selector(getYTAllPath:) withObject:item waitUntilDone:YES];
		
	}else if([[elementName lowercaseString] isEqualToString:@"imagetype"]) {
		item.sType=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
		
	}else if([[elementName lowercaseString] isEqualToString:@"path"]){
		item.sPath=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (contentOfCurrentElement) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [contentOfCurrentElement appendString:string];
    }
}

@end

