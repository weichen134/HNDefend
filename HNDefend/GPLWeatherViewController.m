//
//  GPLWeatherViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLWeatherViewController.h"
#import "GPLHNWeatherInfo.h"

@interface GPLWeatherViewController ()

@end

@implementation GPLWeatherViewController

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
    _weathers = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    NSString *url = @"http://42.120.40.150/haining/DataService/Weather";
    [self fetchDataWithURLString:url];
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
    //整个JSON
    NSArray *totalArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
   // NSLog(@"%@",totalArray);
    BOOL isOK = NO;
    if ([totalArray count] > 0) {
        //这个对象都在了
        NSDictionary *totalDic = [totalArray objectAtIndex:0];
        //Result对象
        NSNumber *resNum = [totalDic objectForKey:@"Result"];
        isOK = [resNum boolValue];
        if (isOK) {
            //如果正确地话，移除所有对象先
            [_weathers removeAllObjects];
            NSArray *weatherArray = [totalDic objectForKey:@"Contents"];
            for (int i = 0; i < [weatherArray count]; i++) {
                NSDictionary *contentDic = [weatherArray objectAtIndex:i];
                GPLHNWeatherInfo *info = [[GPLHNWeatherInfo alloc] init];
                info.descr = [contentDic objectForKey:@"description"];

                info.image = [contentDic objectForKey:@"image"];

                info.temperature = [contentDic objectForKey:@"temperature"];
                info.theDate = [contentDic objectForKey:@"theDate"];
                info.theIndex = [contentDic objectForKey:@"theIndex"];
                info.wind = [contentDic objectForKey:@"wind"];
                [info getFourDateAndWeek];
                [_weathers addObject:info];
            }
        }
    }
}

-(void)updateScreen;
{
    //这是一个父对象，方法在子对象中实现
    for (int i = 0; i < [_weathers count]; i++) {
        GPLHNWeatherInfo *info = [_weathers objectAtIndex:i];
        NSString *imagePath = [NSString stringWithFormat:@"ico_weather_%@.png",info.image];
        UIImage *image = [UIImage imageNamed:imagePath];
        if (i == 0) {
            _weekL1.text = info.weeak;
            _dateL1.text = info.theDate;
            _imageV1.image = image;
            _desc1.text = info.descr;
            NSArray *temArray = [info.temperature componentsSeparatedByString:@"~"];
            if ([temArray count] == 2) {
                _temp1H.text = [temArray objectAtIndex:1];
                _temp1L.text = [temArray objectAtIndex:0];
            }
        } else if (i==1) {
            _weekL2.text = info.weeak;
            _imageV2.image = image;
            _desc2.text = info.descr;
            _temp2.text = info.temperature;
        } else if (i==2) {
            _weekL3.text = info.weeak;
            _imageV3.image = image;
            _desc3.text = info.descr;
            _temp3.text = info.temperature;
        } else if (i==3) {
            _weekL4.text = info.weeak;
            _imageV4.image = image;
            _desc4.text = info.descr;
            _temp4.text = info.temperature;
        }
    }
    
    if ([_weathers count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取数据出错~"
                                                    message:nil
                                                    delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)prepareThings;
{
    //这是一个父对象，方法在子对象中实现
}



@end
