//
//  GPLMainViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLMainViewController.h"
#import "GPLRainListViewController.h"
#import "GPLWaterListViewController.h"
#import "GPLProjectListViewController.h"
#import "NewTyphoonController.h"
#import "SatelliteController.h"
#import "GPLWeatherViewController.h"
#import "GPLPhoneListViewController.h"
#import "GPLReportListViewController.h"
#import "GPLSearchListViewController.h"
#import "GPLUpdateViewController.h"
#import "Const.h"

@interface GPLMainViewController ()

@end

@implementation GPLMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *url = @"http://42.120.40.150/haining/DataService/WarnningList";
//    NSString *url = @"http://42.120.40.150/haining/DataService/RainList";
    [self fetchDataWithURLString:url];
    
    //默认不需要更新
    self.isNew = NO;
    NSString *url2 = @"https://dl.bizmsg.net/appupload/release/bin/hnfx/update/hnzst_ios_update.json";
    [self fetchDataWithURLString2:url2 withSpecial:@""];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)parseXML:(NSData *)data;
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(string);
//    //整个JSON
    NSArray *totalArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.isV = NO;
    if ([totalArray count] > 0) {
        //这个对象都在了
        NSDictionary *totalDic = [totalArray objectAtIndex:0];
        //Result对象
        NSNumber *resNum = [totalDic objectForKey:@"Result"];
        self.isV = [resNum boolValue];
        if (_isV) {
//            //如果正确地话，移除所有对象先
            NSArray *rainListArray = [totalDic objectForKey:@"Contents"];
            for (int i = 0; i < [rainListArray count]; i++) {
                NSDictionary *contentDic = [rainListArray objectAtIndex:i];
//                self.scrollStr = [NSString stringWithFormat:@"%@,%@",[contentDic objectForKey:@"addtime"],[contentDic objectForKey:@"title"]];
                self.scrollStr = [NSString stringWithFormat:@"%@",[contentDic objectForKey:@"title"]];

            }
        }
    }
}

-(void)updateScreen;
{
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setOpaque:NO];
    if (_isV) {
        [_scrollView loadHTMLString:[[NSString alloc] initWithFormat:@"<html><head><style>body{background-color:transparent;front-size:10px;font-weight:bold}</style></head><body><marquee scrollamount=2><font color=\"#FFFFFF\">%@</font></marquee></body></html>", _scrollStr] baseURL:nil];
        [_scrollView setHidden:NO];
    } else {
        [_scrollView setHidden:YES];
    }
}

-(void)parseXML2:(NSData *)data withSpecial:(NSString *)string;
{
    //NSString *string2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(string);
    //    //整个JSON
    NSDictionary *totalDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    int versionNum = [[totalDic objectForKey:@"version_number"] intValue];
    if (versionNum > HNVERSIONNUM) {
        self.isNew = YES;
    } else {
        self.isNew = NO;
    }
}

-(void)updateScreen2;
{
    //这是一个父对象，方法在子对象中实现
    if (_isNew) {
        [_updateButton setHidden:NO];
    } else {
        [_updateButton setHidden:YES];
    }
}

-(IBAction)rain:(id)sender;
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        GPLRainListViewController *vc = [[GPLRainListViewController alloc] initWithNibName:@"GPLRainListViewController5" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        GPLRainListViewController *vc = [[GPLRainListViewController alloc] initWithNibName:@"GPLRainListViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)water:(id)sender;
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        GPLWaterListViewController *vc = [[GPLWaterListViewController alloc] initWithNibName:@"GPLWaterListViewController5" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        GPLWaterListViewController *vc = [[GPLWaterListViewController alloc] initWithNibName:@"GPLWaterListViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)project:(id)sender;
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        GPLProjectListViewController *vc = [[GPLProjectListViewController alloc] initWithNibName:@"GPLProjectListViewController5" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        GPLProjectListViewController *vc = [[GPLProjectListViewController alloc] initWithNibName:@"GPLProjectListViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)typhoon:(id)sender;
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        NewTyphoonController *vc = [[NewTyphoonController alloc] initWithNibName:@"NewTyphoon5" bundle:nil withFromKey:YES];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NewTyphoonController *vc = [[NewTyphoonController alloc] initWithNibName:@"NewTyphoon" bundle:nil withFromKey:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)satellite:(id)sender;
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        SatelliteController *vc = [[SatelliteController alloc] initWithNibName:@"Satellite5" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SatelliteController *vc = [[SatelliteController alloc] initWithNibName:@"Satellite" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)weather:(id)sender;
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        GPLWeatherViewController *vc = [[GPLWeatherViewController alloc] initWithNibName:@"GPLWeatherViewController5" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        GPLWeatherViewController *vc = [[GPLWeatherViewController alloc] initWithNibName:@"GPLWeatherViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)phone:(id)sender;
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        GPLPhoneListViewController *vc = [[GPLPhoneListViewController alloc] initWithNibName:@"GPLPhoneListViewController5" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        GPLPhoneListViewController *vc = [[GPLPhoneListViewController alloc] initWithNibName:@"GPLPhoneListViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];    }
}

-(IBAction)report:(id)sender;
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        GPLReportListViewController *vc = [[GPLReportListViewController alloc] initWithNibName:@"GPLReportListViewController5" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        GPLReportListViewController *vc = [[GPLReportListViewController alloc] initWithNibName:@"GPLReportListViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)search:(id)sender;
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        GPLSearchListViewController *vc = [[GPLSearchListViewController alloc] initWithNibName:@"GPLSearchListViewController5" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        GPLSearchListViewController *vc = [[GPLSearchListViewController alloc] initWithNibName:@"GPLSearchListViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(IBAction)update:(id)sender;
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        GPLUpdateViewController *vc = [[GPLUpdateViewController alloc] initWithNibName:@"GPLUpdateViewController5" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        GPLUpdateViewController *vc = [[GPLUpdateViewController alloc] initWithNibName:@"GPLUpdateViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
