//
//  typhoonXMLParser.h
//  navag
//
//  Created by DY LOU on 10-6-18.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"

@interface TFPathInfo : NSObject
{
	NSString *tfID;
	NSString *RQSJ2;
	NSString *SJ;
	NSString *JD;
	NSString *WD;
	NSString *QY;
	NSString *FS;
	NSString *FL;
	NSString *type;
	NSString *radius7;
	NSString *radius10;
	NSString *movesd;
	NSString *movefx;
}
+(id)tfpathinfo;
@property(copy)NSString *tfID;
@property(copy)NSString *RQSJ2;
@property(copy)NSString *SJ;
@property(copy)NSString *JD;
@property(copy)NSString *WD;
@property(copy)NSString *QY;
@property(copy)NSString *FS;
@property(copy)NSString *FL;
@property(copy)NSString *type;
@property(copy)NSString *radius7;
@property(copy)NSString *radius10;
@property(copy)NSString *movesd;
@property(copy)NSString *movefx;
@end

///////////////////////////////////////////////////

@interface TFList : NSObject
{
	NSString *tfID;
	NSString *cNAME;
	NSString *NAME;
}
+(id)tflist;
@property(copy)NSString *tfID;
@property(copy)NSString *cNAME;
@property(copy)NSString *NAME;
@end

///////////////////////////////////////////////////

@interface TFYBList : NSObject
{
	NSString *tfID;
	NSString *RQSJ2;
	NSString *YBSJ;
	NSString *jd;
	NSString *wd;
	NSString *QY;
	NSString *FS;
	NSString *FL;
	NSString *TM;
}
+(id)tfyblist;
@property(copy)NSString *tfID;
@property(copy)NSString *RQSJ2;
@property(copy)NSString *YBSJ;
@property(copy)NSString *jd;
@property(copy)NSString *wd;
@property(copy)NSString *QY;
@property(copy)NSString *FS;
@property(copy)NSString *FL;
@property(copy)NSString *TM;
@end

/////////////////////////////////////////////////// 

@interface typhoonXMLParser : Parser {
	NSMutableString *contentOfCurrentElement;
	TFPathInfo *Items;
}

@end

///////////////////////////////////////////////////

@interface typhoonListXMLParser : Parser {
	NSMutableString *contentOfCurrentElement;
	TFList *Items;
}

@end

///////////////////////////////////////////////////

@interface typhoonNewXMLParser : Parser {
	NSMutableString *contentOfCurrentElement;
	TFList *Items;
}

@end

///////////////////////////////////////////////////

@interface typhoonYBXMLParser : Parser {
	NSMutableString *contentOfCurrentElement;
	TFYBList *Items;
}

@end