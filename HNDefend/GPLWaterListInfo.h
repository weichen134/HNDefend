//
//  GPLWaterListInfo.h
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPLWaterListInfo : NSObject

@property(nonatomic,strong) NSString *waterID;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *river;
@property(nonatomic,strong) NSString *time;
@property(nonatomic,strong) NSString *warnLevel;
@property(nonatomic,strong) NSString *dangerousLevel;
@property(nonatomic,strong) NSString *wusongLevel;//这个是标准
@property(nonatomic,strong) NSString *huanghaiLevel;

-(void)setSpecial:(NSString *)str;
@end
