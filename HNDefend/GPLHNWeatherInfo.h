//
//  GPLHNWeatherInfo.h
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPLHNWeatherInfo : NSObject
@property(nonatomic,strong) NSString *descr;
@property(nonatomic,strong) NSString *image;
@property(nonatomic,strong) NSString *temperature;
@property(nonatomic,strong) NSString *theDate;
@property(nonatomic,strong) NSString *theIndex;
@property(nonatomic,strong) NSString *wind;
@property(nonatomic,strong) NSString *weeak;

-(void)getFourDateAndWeek;
-(NSString*)week:(NSInteger)week;
@end

/*
 "description":"多云转阴",
 "image":"1",
 "temperature":"34℃~24℃",
 "theDate":"",
 "theIndex":"1",
 "wind":"东南风3-4级"
*/