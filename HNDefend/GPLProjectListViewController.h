//
//  GPLProjectListViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"

@interface GPLProjectListViewController : GPLParentViewController

@property(nonatomic,weak) IBOutlet UITableView *projectList;
@property(nonatomic,strong) NSMutableArray *heightArray;
@property(nonatomic,strong) NSMutableArray *projectArray;
@property(nonatomic,weak) IBOutlet UIButton *zzBtn;
@property(nonatomic,weak) IBOutlet UIButton *bzBtn;
@property(nonatomic,weak) IBOutlet UIButton *zbBtn;
@property(nonatomic,weak) IBOutlet UIButton *hsBtn;

@property(nonatomic,strong) NSString *nowType;
-(void)fetchDataByType:(NSString *)type;
-(IBAction)zzgq:(id)sender;
-(IBAction)bzgq:(id)sender;
-(IBAction)zbgq:(id)sender;
-(IBAction)hsgq:(id)sender;

@end
