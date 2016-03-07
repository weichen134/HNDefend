//
//  GPLSearchListViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"

@class GPLPersonInfo;
@class GPLProjectInfo;
@class GPLSearchInfo;
@interface GPLSearchListViewController : GPLParentViewController<UITextFieldDelegate,UIActionSheetDelegate>
@property(nonatomic,weak) IBOutlet UITableView *searchList;
@property(nonatomic,weak) IBOutlet UITextField *textField;
@property(nonatomic,strong) NSMutableArray *searchArray;

@property(nonatomic,strong) GPLPersonInfo *personInfo;
@property(nonatomic,strong) GPLProjectInfo *projectInfo;
@property(nonatomic,strong) GPLSearchInfo *searchInfo;

-(IBAction)searchBegin:(id)sender;
@end
