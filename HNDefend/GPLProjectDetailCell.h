//
//  GPLProjectDetailCell.h
//  HNDefend
//
//  Created by GPL on 13-9-11.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPLProjectDetailCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *number;
@property(nonatomic,weak) IBOutlet UILabel *begin;
@property(nonatomic,weak) IBOutlet UILabel *end;
@property(nonatomic,weak) IBOutlet UILabel *duration;
@end
