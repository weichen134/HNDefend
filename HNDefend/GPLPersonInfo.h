//
//  GPLPersonInfo.h
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPLPersonInfo : NSObject
/*
 {"mobile":"13806701508","nickName":"虞铭华","position":"局长","tel":"","uid":"5","username":"虞铭华"}
 */
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *nickName;
@property(nonatomic,strong) NSString *position;
@property(nonatomic,strong) NSString *tel;
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *depar;
@end
