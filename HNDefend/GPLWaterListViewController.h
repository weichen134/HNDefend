//
//  GPLWaterListViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"

@interface GPLWaterListViewController : GPLParentViewController<UIActionSheetDelegate>
@property(nonatomic,weak) IBOutlet UITableView *waterList;
@property(nonatomic,strong) NSMutableArray *waterListArray;
@property(nonatomic,strong) NSMutableArray *waterShowArray;
@property(nonatomic) NSInteger typeIndex;
@property(nonatomic,strong) NSString *szsx;

@property(nonatomic,weak) IBOutlet UIBarButtonItem *szsxLabel;
@property(nonatomic,weak) IBOutlet UIButton *sxBtn;
@property(nonatomic,weak) IBOutlet UIButton *syBtn;
@property(nonatomic,weak) IBOutlet UIButton *jjBtn;
@property(nonatomic,weak) IBOutlet UIButton *wjBtn;

-(IBAction)sxWater:(id)sender;
-(IBAction)allWater:(id)sender;
-(IBAction)cjWater:(id)sender;
-(IBAction)wjWater:(id)sender;

-(IBAction)goToTips:(id)sender;

@end
