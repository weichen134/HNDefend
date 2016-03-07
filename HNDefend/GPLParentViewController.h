//
//  GPLParentViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+Resolutions.h"

@interface GPLParentViewController : UIViewController
@property(nonatomic,weak) IBOutlet UIActivityIndicatorView *activityIndicator;
-(IBAction)backToTop:(id)sender;
-(void)fetchDataWithURLString:(NSString *)urlString;
-(void)parseXML:(NSData *)data;
-(void)updateScreen;
-(void)prepareThings;

-(void)fetchDataWithURLString2:(NSString *)urlString withSpecial:(NSString *)string;
-(void)parseXML2:(NSData *)data;
-(void)updateScreen2;
@end
