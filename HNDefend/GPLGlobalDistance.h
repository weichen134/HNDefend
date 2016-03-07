//
//  GPLGlobalDistance.h
//  HNDefend
//
//  Created by GPL on 14-2-13.
//  Copyright (c) 2014年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPLGlobalDistance : NSObject
//转化为弧度
+(double)rad:(double)d;
//计算距离
+(double)getDistanceBeginLat:(NSString *)lats1
                    BeginLng:(NSString *)lngs1
                      EndLat:(NSString *)lats2
                      EndLng:(NSString *)lngs2;
@end
