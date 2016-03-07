//
//  GPLMainViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"
@interface GPLMainViewController : GPLParentViewController

@property(nonatomic,weak) IBOutlet UIWebView *scrollView;

@property(nonatomic,weak) IBOutlet UIButton *updateButton;

@property(nonatomic,strong) NSString *scrollStr;

@property(nonatomic,assign) BOOL isV;
@property(nonatomic,assign) BOOL isNew;

-(IBAction)rain:(id)sender;
-(IBAction)water:(id)sender;
-(IBAction)project:(id)sender;
-(IBAction)typhoon:(id)sender;
-(IBAction)satellite:(id)sender;
-(IBAction)weather:(id)sender;
-(IBAction)phone:(id)sender;
-(IBAction)report:(id)sender;
-(IBAction)search:(id)sender;
-(IBAction)update:(id)sender;
@end
