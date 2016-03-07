//
//  TipsViewController.h
//  HNDefend
//
//  Created by LOUGUOPENG on 15-7-24.
//  Copyright (c) 2015年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic,weak) IBOutlet UIWebView *web;

-(IBAction)backToTop:(id)sender;

@end
