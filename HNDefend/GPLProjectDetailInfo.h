//
//  GPLProjectDetailInfo.h
//  HNDefend
//
//  Created by GPL on 13-9-11.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPLProjectDetailInfo : NSObject
/*
 "duration":"29.00","end":"2013-09-10 09:38","id":"1","start":"2013-09-10 09:09"
 */
@property(nonatomic,strong) NSString *duration;
@property(nonatomic,strong) NSString *end;
@property(nonatomic,strong) NSString *detailID;
@property(nonatomic,strong) NSString *start;

@end
