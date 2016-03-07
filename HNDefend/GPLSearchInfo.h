//
//  GPLSearchInfo.h
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPLSearchInfo : NSObject
/*
 {"name":"许村翻水站","type":"泵站","value":"8"
 */
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *value;

@end
