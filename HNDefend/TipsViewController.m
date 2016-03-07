//
//  TipsViewController.m
//  HNDefend
//
//  Created by LOUGUOPENG on 15-7-24.
//  Copyright (c) 2015年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "TipsViewController.h"

@interface TipsViewController ()

@end

@implementation TipsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _web.delegate = self;
    _web.scalesPageToFit = YES;
    _web.userInteractionEnabled = YES;
    _web.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:_web];
    NSURL *url = [NSURL URLWithString:@"http://dl.bizmsg.net/appupload/release/bin/hnfx/tips/hnxcs.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_web loadRequest:request];
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

#pragma UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *url = request.URL;
    if (UIWebViewNavigationTypeLinkClicked == navigationType)
    {
        [[UIApplication sharedApplication] openURL:url];
        NSLog(@"BA");
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    NSLog(@"B");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    NSLog(@"C");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    NSLog(@"D");
}
@end
