//
//  GPLProjectDetailViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-11.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"

@interface GPLProjectDetailViewController : GPLParentViewController<UIActionSheetDelegate>
//@property(nonatomic,weak) IBOutlet UIButton *beginBtn;
//@property(nonatomic,weak) IBOutlet UIButton *endBtn;
@property(nonatomic,weak) IBOutlet UILabel *beginLabel;
@property(nonatomic,weak) IBOutlet UILabel *endLabel;
@property(nonatomic,weak) IBOutlet UILabel *titleLabel;
@property(nonatomic,weak) IBOutlet UITableView *projectDetailList;
@property(nonatomic,strong) IBOutlet UISegmentedControl *mySeg;

@property(nonatomic,strong) NSMutableArray *projectDetailArray;
@property(nonatomic,strong) NSString *portNm;
@property(nonatomic,strong) NSString *portID;
@property(nonatomic,strong) NSString *portStatus;
@property(nonatomic,strong) NSString *portType;
@property(nonatomic) int nowIndex;

-(IBAction)chooseBeginDate:(id)sender;
-(IBAction)chooseEndDate:(id)sender;
-(IBAction)changeSeg:(id)sender;

@end
