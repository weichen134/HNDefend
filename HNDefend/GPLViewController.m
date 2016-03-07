//
//  GPLViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLViewController.h"
#import "GPLNetWorkRequest.h"
#import "UIDevice+serialNumber.h"
#import "Const.h"
#import "GPLUserInfo.h"
#import "GPLMainViewController.h"

@interface GPLViewController ()

@end

@implementation GPLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //准备URL
    
    //NSString *sid = [UIDevice currentDevice].serialFinalNumber;
    NSString *sid = @"DX3KJL9CDPMW";
    NSString *url=[NSString stringWithFormat:@"http://42.120.40.150/haining/UserAuthService/%@",sid];

    //NSString *url = @"http://42.120.40.150/haining/UserAuthService/861147001143863";
    //NSString *url = @"http://42.120.40.150/haining/UserAuthService/DX3KJL9CDPMW";
    [self fetchDataWithURLString:url];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)parseXML:(NSData *)data {    
    //parseJson,其实很像一个dictionary
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
    _info = [[GPLUserInfo alloc] init];
    _info.result = [NSNumber numberWithBool:false];
    if ([array count]>0 ) {
        //第二级1
        NSDictionary *dic = [array objectAtIndex:0];
        //第二级1如果没有衍生下去，那就是到头了，不需要Array
        _info.result = (NSNumber *)[dic objectForKey:@"Result"];
    }
    if ([_info.result isEqualToNumber:[NSNumber numberWithBool:true]]) {
        //第二级2如果有的话就是array，看得出来的
        NSDictionary *dic = [array objectAtIndex:0];
        NSArray *finalString1 = [dic objectForKey:@"Contents"];
        if ([finalString1 count] >0) {
            NSDictionary *dic = [finalString1 objectAtIndex:0];
            _info.deviceId = [dic objectForKey:@"deviceId"];
            _info.nickName = [dic objectForKey:@"nickName"];
            _info.untName = [dic objectForKey:@"unitName"];
        }
        _label.text = @"登录成功";
    } else if ([_info.result isEqualToNumber:[NSNumber numberWithBool:false]]) {
        _info.result = [NSNumber numberWithBool:false];
        _label.text = @"用户未注册";
    } else {
        _info.result = [NSNumber numberWithInt:3];
        _label.text = @"服务器无数据返回";
    }
}

-(void)updateScreen;
{
    if ([_info.result isEqualToNumber:[NSNumber numberWithBool:true]]) {
        _label.text = @"登录成功";
        int valueDevice = [[UIDevice currentDevice] resolution];
        if (valueDevice == 3) {
            GPLMainViewController *vc = [[GPLMainViewController alloc] initWithNibName:@"GPLMainViewController5" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            GPLMainViewController *vc = [[GPLMainViewController alloc] initWithNibName:@"GPLMainViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else  if ([_info.result isEqualToNumber:[NSNumber numberWithBool:false]]) {
        _label.text = @"用户未注册";
    } else {
        _label.text = @"服务器无数据返回";
    }
}

-(void)prepareThings;
{
    
}

@end
