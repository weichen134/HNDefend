//
//  GPLWaterDetailCell.h
//  HNDefend
//
//  Created by GPL on 13-9-11.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPLWaterDetailCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *waterName;
@property(nonatomic,weak) IBOutlet UILabel *waterCode;
@property(nonatomic,weak) IBOutlet UILabel *waterTime;
@property(nonatomic,weak) IBOutlet UILabel *waterLevel;
@end
