//
//  GPLHNWeatherInfo.m
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLHNWeatherInfo.h"

@implementation GPLHNWeatherInfo

-(void)getFourDateAndWeek;
{
    //得到索引
    int index = [_theIndex intValue];
    
    //得到(24 * 60 * 60)即24小时之前的日期，dateWithTimeIntervalSinceNow:
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: +(24* 60* 60*(index-1))];
    NSLog(@"IndexDay:%@",yesterday);
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    //int week=0;week1是星期天,week7是星期六;
    
    comps = [calendar components:unitFlags fromDate:yesterday];
    int year = [comps year];
    int week = [comps weekday];
    int month = [comps month];
    int day = [comps day];
    
    //设置星期
    _weeak = [self week:week];
    //设置日期
    _theDate = [NSString stringWithFormat:@"%d/%d/%d",year,month,day];
}

-(NSString*)week:(NSInteger)week
{
    NSString*weekStr=nil;
    if(week==1)
    {
        weekStr=@"星期天";
    }else if(week==2){
        weekStr=@"星期一";
        
    }else if(week==3){
        weekStr=@"星期二";
        
    }else if(week==4){
        weekStr=@"星期三";
        
    }else if(week==5){
        weekStr=@"星期四";
        
    }else if(week==6){
        weekStr=@"星期五";
        
    }else if(week==7){
        weekStr=@"星期六";
        
    }
    return weekStr;
}

@end
