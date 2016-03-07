//
//  GPLReportDetailViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLReportDetailViewController.h"

@interface GPLReportDetailViewController ()

@end

@implementation GPLReportDetailViewController

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
    //DataService/ArticleDetail
    NSString *url = [NSString stringWithFormat:@"http://42.120.40.150/haining/DataService/ArticleDetail/%@",_portID];
    [self fetchDataWithURLString:url];
}

-(void)parseXML:(NSData *)data {
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(str);
    //parseJson,其实很像一个dictionary
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                     options:kNilOptions
                                                       error:nil];
    if ([array count]>0 ) {
        //第二级1
        NSDictionary *dic = [array objectAtIndex:0];
        //第二级1如果没有衍生下去，那就是到头了，不需要Array
        BOOL result = (BOOL)[dic objectForKey:@"Result"];
        //第二级2如果有的话就是array，看得出来的
        NSArray *finalString1 = [dic objectForKey:@"Contents"];
        if (result && [finalString1 count] >0) {
            NSDictionary *dic = [finalString1 objectAtIndex:0];
            self.reportContent = [dic objectForKey:@"content"];
        }
    }
}

-(void)updateScreen;
{
    [_webView loadHTMLString:_reportContent baseURL:nil];
    [self.activityIndicator stopAnimating];
//    if (_info.result) {
//        GPLMainViewController *vc = [[GPLMainViewController alloc] initWithNibName:@"GPLMainViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        
//    }
}

-(void)prepareThings;
{
    
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

@end
