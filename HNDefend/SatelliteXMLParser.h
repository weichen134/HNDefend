//
//  SatelliteXMLParser.h
//  navag
//
//  Created by DY LOU on 10-8-15.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"


@interface SatelliteInfo : NSObject
{
	NSString* sType;
	NSString* sPath;
}
+(id)satelliteinfo;
@property(copy)NSString* sType;
@property(copy)NSString* sPath;
@end

//////////////////////////////////// 

@interface SatelliteXMLParser : Parser {
	NSMutableString *contentOfCurrentElement;
	NSStream *SatellitePath;
}

@end

//////////////////////////////////// 

@interface SatelliteAllXMLParser : Parser {
	NSMutableString *contentOfCurrentElement;
	SatelliteInfo *item;
}

@end