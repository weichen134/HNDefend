//
//  GPLViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"

@class GPLUserInfo;
@interface GPLViewController : GPLParentViewController
@property(nonatomic,strong) GPLUserInfo *info;
@property(nonatomic,weak) IBOutlet UILabel *label;
@end
