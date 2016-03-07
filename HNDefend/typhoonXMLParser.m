//
//  typhoonXMLParser.m
//  navag
//
//  Created by DY LOU on 10-6-18.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "typhoonXMLParser.h"
#import "TyphoonListController.h"
#import "NewTyphoonController.h"

@implementation TFPathInfo
@synthesize tfID,RQSJ2,SJ,JD,WD,QY,FS,FL,type,radius7,radius10,movesd,movefx;
+(id)tfpathinfo{
	return [[self alloc] init];
}

@end



////////////////////////////////////

@implementation typhoonXMLParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
    
    if ([elementName isEqualToString:@"Table"]) {
        Items=[TFPathInfo tfpathinfo];
		return;
    }else if([[elementName lowercaseString] isEqualToString:@"id"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"rqsj2"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"sj"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"jd"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"wd"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"qy"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"fs"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"fl"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"type"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"radius7"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"radius10"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"movesd"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"movefx"]){
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
    
	if([elementName isEqualToString:@"Table"]){
		//add to list
		NewTyphoonController *tc=[NewTyphoonController sharedController];
		[tc performSelectorOnMainThread:@selector(getTFPath:) withObject:Items waitUntilDone:YES];
	}else if([[elementName lowercaseString] isEqualToString:@"id"]){
		Items.tfID=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"rqsj2"]){
		Items.RQSJ2=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"sj"]){
		Items.SJ=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"jd"]){
		Items.JD=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"wd"]){
		Items.WD=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"qy"]){
		Items.QY=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"fs"]){
		Items.FS=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"fl"]){
		Items.FL=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"type"]){
		Items.type=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"radius7"]){
		Items.radius7=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"radius10"]){
		Items.radius10=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"movesd"]){
		Items.movesd=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"movefx"]){
		Items.movefx=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
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

//////////////////////////////////////////////////////

@implementation TFList
@synthesize tfID,cNAME,NAME;
+(id)tflist{
	return [[self alloc] init];
}

@end

////////////////////////////////////

@implementation typhoonListXMLParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
    
    if ([elementName isEqualToString:@"Table"]) {
        Items=[TFList tflist];
		return;
    }else if([[elementName lowercaseString] isEqualToString:@"id"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"cname"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"name"]){
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
    
	if([elementName isEqualToString:@"Table"]){
		//add to list
		TyphoonListController *tc=[TyphoonListController sharedController];
		[tc performSelectorOnMainThread:@selector(getTFList:) withObject:Items waitUntilDone:YES];
	}else if([[elementName lowercaseString] isEqualToString:@"id"]){
		Items.tfID=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"cname"]){
		Items.cNAME=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"name"]){
		Items.NAME=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
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


////////////////////////////////////

@implementation typhoonNewXMLParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
    
    if ([elementName isEqualToString:@"Table"]) {
        Items=[TFList tflist];
		return;
    }else if([[elementName lowercaseString] isEqualToString:@"id"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"cname"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"name"]){
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
    
	if([elementName isEqualToString:@"Table"]){
		//add to list
		NewTyphoonController *tc=[NewTyphoonController sharedController];
		[tc performSelectorOnMainThread:@selector(getNewTF:) withObject:Items waitUntilDone:YES];
	}else if([[elementName lowercaseString] isEqualToString:@"id"]){
		Items.tfID=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"cname"]){
		Items.cNAME=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"name"]){
		Items.NAME=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
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

////////////////////////////////////

@implementation TFYBList
@synthesize tfID,RQSJ2,YBSJ,jd,wd,QY,FS,FL,TM;

+(id)tfyblist{
	return [[self alloc] init];
}

@end

////////////////////////////////////

@implementation typhoonYBXMLParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
    
    if ([elementName isEqualToString:@"Table"]) {
        Items=[TFYBList tfyblist];
		return;
    }else if([[elementName lowercaseString] isEqualToString:@"id"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"rqsj2"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"ybsj"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"jd"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"wd"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"qy"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"fs"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"fl"]){
		contentOfCurrentElement=[NSMutableString string];
	}else if([[elementName lowercaseString] isEqualToString:@"tm"]){
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
    
	if([elementName isEqualToString:@"Table"]){
		//add to list
		NewTyphoonController *tc=[NewTyphoonController sharedController];
		[tc performSelectorOnMainThread:@selector(getTFYB:) withObject:Items waitUntilDone:YES];
	}else if([[elementName lowercaseString] isEqualToString:@"id"]){
		Items.tfID=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"rqsj2"]){
		Items.RQSJ2=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"ybsj"]){
		Items.YBSJ=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"jd"]){
		Items.jd=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"wd"]){
		Items.wd=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"qy"]){
		Items.QY=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"fs"]){
		Items.FS=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"fl"]){
		Items.FL=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
	}else if([[elementName lowercaseString] isEqualToString:@"tm"]){
		Items.TM=(contentOfCurrentElement==nil?@"":contentOfCurrentElement);
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

////////////////////////////////////
