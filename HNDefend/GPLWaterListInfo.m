//
//  GPLWaterListInfo.m
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLWaterListInfo.h"

@implementation GPLWaterListInfo
-(void)setSpecial:(NSString *)str;
{
    NSArray *array = [str componentsSeparatedByString:@"M--"];
    if ([array count] == 2) {
        NSString *jjVirgin = [array objectAtIndex:0];
        NSString *wjVirgin = [array objectAtIndex:1];
        NSString *jjMature = [jjVirgin stringByReplacingOccurrencesOfString:@"--警戒水位" withString:@""];
        NSString *wjVirgin2 = [wjVirgin stringByReplacingOccurrencesOfString:@"危急水位" withString:@""];
        NSString *wjMature = [wjVirgin2 stringByReplacingOccurrencesOfString:@"M" withString:@""];
        _warnLevel = jjMature;
        _dangerousLevel = wjMature;
        if ([_warnLevel intValue] >5) {
            NSLog(@"我的大于5:%@---%@",_warnLevel,_dangerousLevel);
        }
    } else {
        _warnLevel = @"--";
        _dangerousLevel = @"--";
    }
}
@end
