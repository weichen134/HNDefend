//
//  GPLProjectInfo.h
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPLProjectInfo : NSObject
/*
 {"alarm":"设备正常","height":"0","id":"2","name":"许村船闸","status":"关闭","time":"2013-09-10 13:53:06"}
 */
@property(nonatomic,strong) NSString *alarm;
@property(nonatomic,strong) NSString *height;
@property(nonatomic,strong) NSString *projectID;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *time;

@property(nonatomic,strong)NSString *PowerState;
@property(nonatomic,strong)NSString *UpdateTimeString;
@property(nonatomic,strong)NSString *Title;

//闸门状态
@property(nonatomic,strong)NSString *AIsOpen;
@property(nonatomic,strong)NSString *BIsOpen;
@property(nonatomic,strong)NSString *CIsOpen;
@property(nonatomic,strong)NSString *DIsOpen;

//水泵状态
@property(nonatomic,strong)NSString *AStarting;
@property(nonatomic,strong)NSString *BStarting;
@property(nonatomic,strong)NSString *CStarting;
@property(nonatomic,strong)NSString *DStarting;

//电流
@property(nonatomic,strong)NSString *AElectric;
@property(nonatomic,strong)NSString *BElectric;
@property(nonatomic,strong)NSString *CElectric;
@property(nonatomic,strong)NSString *DElectric;

//闸门个数
@property(nonatomic,strong)NSString * GateCount;

//水泵个数
@property(nonatomic,strong)NSString * PumpCount;
@end
