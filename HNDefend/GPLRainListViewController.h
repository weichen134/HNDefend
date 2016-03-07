//
//  GPLRainListViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"

@interface GPLRainListViewController : GPLParentViewController<UIActionSheetDelegate>
@property(nonatomic,weak) IBOutlet UITableView *rainList;
@property(nonatomic,strong) NSMutableArray *rainArray;
@property(nonatomic) BOOL isSortByDay;

-(IBAction)sortChange:(id)sender;

@end
