//
//  GPLDepartInfo.h
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPLDepartInfo : NSObject
/*
 {"unitid":"10","unitname":"市人武部","unitorder":"3"}
 */
@property(nonatomic,strong) NSString *unitid;
@property(nonatomic,strong) NSString *unitname;
@property(nonatomic,strong) NSString *unitorder;
@end
