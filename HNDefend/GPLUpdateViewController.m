//
//  GPLUpdateViewController.m
//  HNDefend
//
//  Created by GPL on 14-2-13.
//  Copyright (c) 2014年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLUpdateViewController.h"

@interface GPLUpdateViewController ()

@end

@implementation GPLUpdateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _web.delegate = self;
    _web.scalesPageToFit = YES;
    _web.userInteractionEnabled = YES;
    _web.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:_web];
    NSURL *url = [NSURL URLWithString:@"http://42.120.40.150/haining/hnfx.html"];
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
