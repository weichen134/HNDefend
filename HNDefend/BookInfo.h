//
//  BookInfo.h
//  navag
//
//  Created by DY LOU on 10-5-8.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookInfo : NSObject {
	NSInteger UserType;
	NSString *UserName;
	NSString *Department;
	NSString *PhoneNumber;
	NSString *FaxNumber;
	NSString *UserJob;
}
+(id)info;
-(id)infoWithDefaultValue;
@property(copy)NSString *UserName;
@property(copy)NSString *Department;
@property(copy)NSString *PhoneNumber;
@property(copy)NSString *FaxNumber;
@property(copy)NSString *UserJob;
@property NSInteger UserType;
@end
