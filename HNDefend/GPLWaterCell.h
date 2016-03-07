//
//  GPLWaterCell.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPLWaterCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *nameLabel;
@property(nonatomic,weak) IBOutlet UILabel *waterName;
@property(nonatomic,weak) IBOutlet UILabel *timeLabel;
@property(nonatomic,weak) IBOutlet UILabel *waterLevel;
@property(nonatomic,weak) IBOutlet UILabel *waterLevel2;
@property(nonatomic,weak) IBOutlet UIImageView *warnImgV;
@end
