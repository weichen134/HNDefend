//
//  BookInfo.m
//  navag
//
//  Created by DY LOU on 10-5-8.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "BookInfo.h"


@implementation BookInfo

@synthesize UserName,Department,PhoneNumber,FaxNumber,UserJob,UserType;
+(id)info{
	return [[self alloc] init];
}
-(id)infoWithDefaultValue{
	self.UserName=@"";
	self.Department=@"";
	self.PhoneNumber=@"";
	self.FaxNumber=@"";
	self.UserJob=@"";
	self.UserType=0;
	return self;
}


@end
