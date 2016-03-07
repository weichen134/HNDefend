//
//  GPLWeatherViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"

@interface GPLWeatherViewController : GPLParentViewController
@property(nonatomic,strong) NSMutableArray *weathers;

//IBOutlet
//1
@property(nonatomic,weak) IBOutlet UILabel *weekL1;
@property(nonatomic,weak) IBOutlet UILabel *dateL1;
@property(nonatomic,weak) IBOutlet UIImageView *imageV1;
@property(nonatomic,weak) IBOutlet UILabel *desc1;
@property(nonatomic,weak) IBOutlet UILabel *temp1L;
@property(nonatomic,weak) IBOutlet UILabel *temp1H;

//2
@property(nonatomic,weak) IBOutlet UIImageView *imageV2;
@property(nonatomic,weak) IBOutlet UILabel *weekL2;
@property(nonatomic,weak) IBOutlet UILabel *desc2;
@property(nonatomic,weak) IBOutlet UILabel *temp2;
//3
@property(nonatomic,weak) IBOutlet UIImageView *imageV3;
@property(nonatomic,weak) IBOutlet UILabel *weekL3;
@property(nonatomic,weak) IBOutlet UILabel *desc3;
@property(nonatomic,weak) IBOutlet UILabel *temp3;
//4
@property(nonatomic,weak) IBOutlet UIImageView *imageV4;
@property(nonatomic,weak) IBOutlet UILabel *weekL4;
@property(nonatomic,weak) IBOutlet UILabel *desc4;
@property(nonatomic,weak) IBOutlet UILabel *temp4;

@end
