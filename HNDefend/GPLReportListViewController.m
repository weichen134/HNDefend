//
//  GPLReportListViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLReportListViewController.h"
#import "GPLReportCell.h"
#import "GPLReportInfo.h"
#import "GPLReportDetailViewController.h"

@interface GPLReportListViewController ()

@end

@implementation GPLReportListViewController

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
    _reportInfos = [[NSMutableArray alloc] init];
    NSString *url = @"http://42.120.40.150/haining/DataService/ArticleList?pageIndex=1&pageSize=20";
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
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(string);
    //整个JSON
    NSArray *totalArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    BOOL isOK = NO;
    if ([totalArray count] > 0) {
        //这个对象都在了
        NSDictionary *totalDic = [totalArray objectAtIndex:0];
        //Result对象
        NSNumber *resNum = [totalDic objectForKey:@"Result"];
        isOK = [resNum boolValue];
        if (isOK) {
            /*
             @property(nonatomic,strong) NSString *content;
             @property(nonatomic,strong) NSString *contentID;
             @property(nonatomic,strong) NSString *summary;
             @property(nonatomic,strong) NSString *title;
             @property(nonatomic,strong) NSString *type;
             @property(nonatomic,strong) NSString *updatetime;
             */
            //如果正确地话，移除所有对象先
            [_reportInfos removeAllObjects];
            NSArray *weatherArray = [totalDic objectForKey:@"Contents"];
            for (int i = 0; i < [weatherArray count]; i++) {
                NSDictionary *contentDic = [weatherArray objectAtIndex:i];
                GPLReportInfo *info = [[GPLReportInfo alloc] init];
                info.content = [contentDic objectForKey:@"content"];
                info.contentID = [contentDic objectForKey:@"id"];
                info.summary = [contentDic objectForKey:@"summary"];
                info.title = [contentDic objectForKey:@"title"];
                info.type = [contentDic objectForKey:@"type"];
                info.updatetime = [contentDic objectForKey:@"updatetime"];
                [_reportInfos addObject:info];
            }
        }
    }
}

-(NSDate *)stringToDate:string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

-(void)updateScreen;
{
    //需要排下顺序
    [_reportInfos sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GPLReportInfo *info1 = obj1;
        GPLReportInfo *info2 = obj2;
        NSDate *a = [self stringToDate:info1.updatetime];
        NSDate *b = [self stringToDate:info2.updatetime];
        return [b compare:a];
    }];
    
    [_reportList reloadData];
}

-(void)prepareThings;
{
    //这是一个父对象，方法在子对象中实现
}


#pragma UITableViewDelegate and UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_reportInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    GPLReportCell *cell = (GPLReportCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLReportCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    GPLReportInfo *info = [_reportInfos objectAtIndex:indexPath.row];
    cell.reportName.text = info.title;
    cell.reportTime.text = info.updatetime;
    return cell;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GPLReportInfo *info = [_reportInfos objectAtIndex:indexPath.row];
    
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        GPLReportDetailViewController *vc = [[GPLReportDetailViewController alloc] initWithNibName:@"GPLReportDetailViewController5" bundle:nil];
        vc.portID = info.contentID;
        vc.portName = info.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        GPLReportDetailViewController *vc = [[GPLReportDetailViewController alloc] initWithNibName:@"GPLReportDetailViewController" bundle:nil];
        vc.portID = info.contentID;
        vc.portName = info.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
