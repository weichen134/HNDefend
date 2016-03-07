//
//  GPLRainListInfo.h
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPLRainListInfo : NSObject
/*
 {"dayrain":"0.0","hourrain":"0","id":"13736475684","name":"许巷","river":"上塘河","time":"9:55"}
 */
@property(nonatomic,strong) NSString *dayrain;
@property(nonatomic,strong) NSString *hourrain;
@property(nonatomic,strong) NSString *rainID;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *river;
@property(nonatomic,strong) NSString *time;
@end
