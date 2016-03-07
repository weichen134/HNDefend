//
//  GPLReportDetailViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"
@interface GPLReportDetailViewController : GPLParentViewController
@property(nonatomic,weak) IBOutlet UIWebView *webView;
@property(nonatomic,strong) NSString *portID;
@property(nonatomic,strong) NSString *portName;
@property(nonatomic,strong) NSString *reportContent;
@end
