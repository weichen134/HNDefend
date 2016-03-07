//
//  GPLReportListViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"

@interface GPLReportListViewController : GPLParentViewController
@property(nonatomic,weak) IBOutlet UITableView *reportList;
@property(nonatomic,strong) NSMutableArray *reportInfos;
-(NSDate *)stringToDate:string;
@end
