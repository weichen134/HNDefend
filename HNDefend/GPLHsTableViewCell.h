//
//  GPLHsTableViewCell.h
//  HNDefend
//
//  Created by 不贱不粘 on 16/1/20.
//  Copyright © 2016年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPLProjectInfo;


@interface GPLHsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *powerStateLabel;

@property (strong, nonatomic) IBOutlet UILabel *updateTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *AIsOpenLabel;
@property (strong, nonatomic) IBOutlet UILabel *BIsOpenLabel;
@property (strong, nonatomic) IBOutlet UILabel *CIsOpenLabel;
@property (strong, nonatomic) IBOutlet UILabel *DIsOpenLabel;

@property (strong, nonatomic) IBOutlet UILabel *AStarting;
@property (strong, nonatomic) IBOutlet UILabel *BStarting;
@property (strong, nonatomic) IBOutlet UILabel *CStarting;
@property (strong, nonatomic) IBOutlet UILabel *DStarting;

@property (strong, nonatomic) IBOutlet UILabel *AElectric;
@property (strong, nonatomic) IBOutlet UILabel *BElectric;
@property (strong, nonatomic) IBOutlet UILabel *CElectric;
@property (strong, nonatomic) IBOutlet UILabel *DElectric;


-(void)setStatusModel:(GPLProjectInfo *)status;

@end
