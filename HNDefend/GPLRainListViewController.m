//
//  GPLRainListViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLRainListViewController.h"
#import "GPLRainListCell.h"
#import "GPLRainListInfo.h"
#import "GPLRainDetailViewController.h"

@interface GPLRainListViewController ()

@end

@implementation GPLRainListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isSortByDay = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rainArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    NSString *url = @"http://42.120.40.150/haining/DataService/RainList";
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
            //如果正确地话，移除所有对象先
            [_rainArray removeAllObjects];
            NSArray *rainListArray = [totalDic objectForKey:@"Contents"];
            for (int i = 0; i < [rainListArray count]; i++) {
                NSDictionary *contentDic = [rainListArray objectAtIndex:i];
                GPLRainListInfo *info = [[GPLRainListInfo alloc] init];
                info.dayrain = [contentDic objectForKey:@"dayrain"];
                info.hourrain = [contentDic objectForKey:@"hourrain"];
                info.rainID = [contentDic objectForKey:@"id"];
                info.name = [contentDic objectForKey:@"name"];
                info.river = [contentDic objectForKey:@"river"];
                info.time = [contentDic objectForKey:@"time"];
                [_rainArray addObject:info];
            }
        }
    }
}

-(void)updateScreen;
{
    //需要排下顺序
    [_rainArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GPLRainListInfo *info1 = obj1;
        GPLRainListInfo *info2 = obj2;
        if (_isSortByDay == NO) {
            float a = [info1.hourrain floatValue];
            float b = [info2.hourrain floatValue];
            if (a < b) {
                return NSOrderedDescending;
            } else if (a > b) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        } else {
            float a = [info1.dayrain floatValue];
            float b = [info2.dayrain floatValue];
            if (a < b) {
                return NSOrderedDescending;
            } else if (a > b) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }
    }];
    //正确处理
    [_rainList reloadData];
    //异常处理
    if ([_rainArray count] == 0) {
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

-(IBAction)sortChange:(id)sender;
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择列表排序"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"按时雨量排序",@"按日雨量排序",nil];
    [action showInView:self.view];
}

-(void)confirmSortByType;
{
    if (_isSortByDay == NO) {
        //到这里说明要切换到日雨量排序
        _isSortByDay = YES;
    } else {
        //到这里说明要切换到时雨量排序
        _isSortByDay = NO;
    }
}


#pragma UITableViewDelegate and UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_rainArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    GPLRainListCell *cell = (GPLRainListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLRainListCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    GPLRainListInfo *info = [_rainArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = info.name;
    cell.waterName.text = info.river;
    cell.timeLabel.text = info.time;
    cell.hourLabel.text = info.hourrain;
    cell.dayLabel.text = info.dayrain;
    return cell;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    GPLRainListInfo *info = [_rainArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GPLRainDetailViewController *vc;
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        vc = [[GPLRainDetailViewController alloc] initWithNibName:@"GPLRainDetailViewController5" bundle:nil];
    } else {
        vc = [[GPLRainDetailViewController alloc] initWithNibName:@"GPLRainDetailViewController" bundle:nil];;
    }
    
    
    vc.portNm = info.name;
    vc.portClient = info.rainID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        //时间
        _isSortByDay = NO;
        [self updateScreen];
    } else if (buttonIndex == 1) {
        //日期
        _isSortByDay = YES;
        [self updateScreen];
    }
    NSLog(@"%d",buttonIndex);
}
@end
