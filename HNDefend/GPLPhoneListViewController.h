//
//  GPLPhoneListViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"

@interface GPLPhoneListViewController : GPLParentViewController<UIActionSheetDelegate>
@property(nonatomic,weak) IBOutlet UITableView *phoneList;
@property(nonatomic,strong) NSMutableArray *phoneArray;
@property(nonatomic,strong) NSMutableArray *personArray;
@property(nonatomic,strong) NSString *phoneNmber;
-(void)parseXML:(NSData *)data;
-(void)updateScreen;
@end
