//
//  LocationInfo.m
//  navag
//
//  Created by DY LOU on 10-8-29.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "LocationInfo.h"


@implementation LocationInfo

@synthesize pac, pacname;
+(id)locationinfo{
	return [[self alloc] init];
}
-(id)infoWithDefaultValue{
	self.pac=@"000000";
	self.pacname=@"全部";
	return self;
}


@end
