//
//  GPLParentViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLParentViewController.h"
#import "GPLNetWorkRequest.h"
#import "Const.h"

@interface GPLParentViewController ()

@end

@implementation GPLParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)backToTop:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)fetchDataWithURLString:(NSString *)urlString;
{
    [GPLNetWorkRequest requestURLPathSy:urlString
                           onCompletion:^(NSData *result, NSError *error) {
                               NSLog(@"OK");
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   if (!error) {
                                       //no error
                                       NSLog(@"no error");
                                       //解析
                                       [self parseXML:result];
                                       //check is validate,if ok continue;
                                       [self updateScreen];
                                   } else {
                                       // handle error
                                       NSLog(@"error");
                                       [GPLNetWorkRequest dealWithError:error delegate:self];
                                       //置为空
                                       [self prepareThings];
                                   }
                               });
                           }];
    //停止wattingview
    [_activityIndicator stopAnimating];
}

-(void)parseXML:(NSData *)data;
{
    //这是一个父对象，方法在子对象中实现
}

-(void)updateScreen;
{
    //这是一个父对象，方法在子对象中实现
}

-(void)prepareThings;
{
    //这是一个父对象，方法在子对象中实现
}

-(void)fetchDataWithURLString2:(NSString *)urlString withSpecial:(NSString *)string;
{
    [GPLNetWorkRequest requestURLPathSy:urlString
                           onCompletion:^(NSData *result, NSError *error) {
                               NSLog(@"OK");
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   if (!error) {
                                       //no error
                                       NSLog(@"no error");
                                       //解析
                                       [self parseXML2:result withSpecial:string];
                                       //check is validate,if ok continue;
                                       [self updateScreen2];
                                   } else {
                                       // handle error
                                       NSLog(@"error");
                                       [GPLNetWorkRequest dealWithError:error delegate:self];
                                       //置为空
                                       [self prepareThings];
                                   }
                               });
                           }];
    //停止wattingview
    [_activityIndicator stopAnimating];
}

-(void)parseXML2:(NSData *)data withSpecial:(NSString *)string;
{
    //这是一个父对象，方法在子对象中实现
}

-(void)updateScreen2;
{
    //这是一个父对象，方法在子对象中实现
}

@end
