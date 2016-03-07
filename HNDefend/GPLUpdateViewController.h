//
//  GPLUpdateViewController.h
//  HNDefend
//
//  Created by GPL on 14-2-13.
//  Copyright (c) 2014年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPLUpdateViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic,weak) IBOutlet UIWebView *web;
-(IBAction)backToTop:(id)sender;
@end
