//
//  LocationInfo.h
//  navag
//
//  Created by DY LOU on 10-8-29.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocationInfo : NSObject {
	NSString *pac;
	NSString *pacname;
}
+(id)locationinfo;
-(id)infoWithDefaultValue;
@property(copy)NSString *pac;
@property(copy)NSString *pacname;
@end
