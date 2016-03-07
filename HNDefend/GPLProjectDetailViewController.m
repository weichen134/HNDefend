//
//  GPLProjectDetailViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-11.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLProjectDetailViewController.h"
#import "GPLProjectDetailInfo.h"
#import "GPLProjectDetailCell.h"

@interface GPLProjectDetailViewController ()

@end

@implementation GPLProjectDetailViewController

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
	// Do any additional setup after loading the view.
    _projectDetailArray = [[NSMutableArray alloc] init];
    [self setDayStandardTime];
    self.titleLabel.text = _portNm;
    _nowIndex = 1;
    [self fetchDataByType:1];
    [self chushihuaSeg];
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

-(void)chushihuaSeg
{
    NSString *eraseData1 = [_portStatus stringByReplacingOccurrencesOfString:@"关闭"
                                                                 withString:@""];
    NSString *eraseData2 = [eraseData1 stringByReplacingOccurrencesOfString:@"开启"
                                                                 withString:@""];
    NSArray *mySegArray = [eraseData2 componentsSeparatedByString:@"\n"];
    _mySeg = [[UISegmentedControl alloc] initWithItems:mySegArray];
    _mySeg.tintColor = [UIColor colorWithRed:83.0/255.0 green:177.0/255.0 blue:232.0/255.0 alpha:1.0];
    
    int valueDevice = [[UIDevice currentDevice] resolution];
    int plus = 0;
    if (valueDevice == 3) {
        plus = 88;
    }
    
    _mySeg.frame = CGRectMake(0, 450 + plus, 320, 31);
    if ([mySegArray count] > 1) {
        _mySeg.selectedSegmentIndex = 0;
    } else {
        _mySeg.userInteractionEnabled = NO;
    }
    [_mySeg addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
    _mySeg.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.view addSubview:_mySeg];
    CGRect myTableFrame = CGRectMake(0, 144, 320, 306 + plus);
    if ([mySegArray count] < 2) {
        myTableFrame.size.height += 31;
        [_mySeg removeFromSuperview];
    }
    _projectDetailList.frame = myTableFrame;
}

-(void)setDayStandardTime
{
    //其实就是当天了
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:nowDate]; // Get necessary date components
    int month = [comps month];
    int year = [comps year];
    int day = [comps day];
    if (month == 1) {
        year -= 1;
        month = 12;
    } else {
        month -= 1;
    }
    NSString *beginDateT = [NSString stringWithFormat:@"%d-%02d-%02d",year,month,day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *now = [formatter stringFromDate:nowDate];
    self.beginLabel.text = beginDateT;
    self.endLabel.text = now;
}

-(IBAction)chooseBeginDate:(id)sender
{
    [self selectValue:0];
}

-(IBAction)chooseEndDate:(id)sender
{
    [self selectValue:1];
}

-(void)selectValue:(int)index
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    actionSheet.tag = 888 + index;
    [actionSheet showInView:self.view];
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.tag = 101;
    datePicker.datePickerMode = 1;
    [actionSheet addSubview:datePicker];
    [actionSheet showInView:self.view];
}

-(BOOL)timeCheck
{
    BOOL isOK = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginT = self.beginLabel.text;
    NSString *endT = self.endLabel.text;
    NSDate *nowDate = [NSDate date];
    NSDate *beginD=[formatter dateFromString:beginT];
    NSDate *endD=[formatter dateFromString:endT];
    //双重时间检测
    if ([beginD compare:nowDate] != NSOrderedDescending) {
        isOK = YES;
    } else {
        //不可以
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"时间选择错误"
                                                       message:@"您选的开始时间是未来时间噢~"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [view show];
    }
    if (isOK) {
        if ([beginD compare:endD] != NSOrderedDescending ) {
            isOK = YES;
        } else {
            //不可以
            isOK = NO;
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"时间选择错误"
                                                           message:@"开始时间不能晚于结束时间~"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [view show];
        }
    }
    return isOK;
}


-(void)fetchDataByType:(int)index
{
    if ([_portType isEqualToString:@"闸站"]) { //0
        NSString *url = [NSString stringWithFormat:@"http://42.120.40.150/haining/DataService/GatetHistoryList/%@/%d/%@/%@",_portID,index,self.beginLabel.text,self.endLabel.text];
        [self fetchDataWithURLString:url];
    } else if ([_portType isEqualToString:@"泵站"]) { //1
        NSString *url = [NSString stringWithFormat:@"http://42.120.40.150/haining/DataService/PumpHistoryList/%@/%d/%@/%@",_portID,index,self.beginLabel.text,self.endLabel.text];
        [self fetchDataWithURLString:url];
    }
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
            [_projectDetailArray removeAllObjects];
            NSArray *waterTemArray = [totalDic objectForKey:@"Contents"];
            for (int i = 0; i < [waterTemArray count]; i++) {
                NSDictionary *contentDic = [waterTemArray objectAtIndex:i];
                GPLProjectDetailInfo *info = [[GPLProjectDetailInfo alloc] init];
                info.detailID = [contentDic objectForKey:@"id"];
                NSString *dur = [contentDic objectForKey:@"duration"];
                if ([dur length]==0) {
                    continue;
                }
                info.duration = [contentDic objectForKey:@"duration"];
                NSString *s = [contentDic objectForKey:@"start"];
                NSString *e = [contentDic objectForKey:@"end"];
                NSArray *sArray = [s componentsSeparatedByString:@"-"];
                NSArray *eArray = [e componentsSeparatedByString:@"-"];
                if ([sArray count] == 3 && [eArray count] == 3) {
                    info.start = [NSString stringWithFormat:@"%@-%@",[sArray objectAtIndex:1],[sArray objectAtIndex:2]];
                    info.end = [NSString stringWithFormat:@"%@-%@",[eArray objectAtIndex:1],[eArray objectAtIndex:2]];
                }
                [_projectDetailArray addObject:info];
            }
        }
    }
}

-(void)updateScreen;
{
    //正确处理
    [_projectDetailList reloadData];
//    //异常处理
//    if ([_projectArray count] == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取数据出错~"
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }
}

-(IBAction)changeSeg:(id)sender;
{
    _nowIndex = _mySeg.selectedSegmentIndex + 1;
    [self fetchDataByType:_nowIndex];
}

#pragma UITableViewDelegate and UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_projectDetailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    GPLProjectDetailCell *cell = (GPLProjectDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLProjectDetailCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    GPLProjectDetailInfo *info = [_projectDetailArray objectAtIndex:indexPath.row];
    cell.number.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    cell.begin.text = info.start;
    cell.end.text = info.end;
    cell.duration.text = info.duration;
    return cell;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 27;
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (actionSheet.tag == 888) {
        //开始时间
        UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *timesp = [formatter stringFromDate:datePicker.date];
        NSString *oldTime = self.beginLabel.text;
        //设定开始时间
        self.beginLabel.text = timesp;
        //时间检测
        if(buttonIndex == 0 && [self timeCheck] == YES) {
            //更新数据 过程线和表格
            [self fetchDataByType:_nowIndex];
        } else {
            //时间出错，重新纠正复原
            self.beginLabel.text = oldTime;
        }
    } else if (actionSheet.tag == 889) {
        //结束时间
        UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *timesp = [formatter stringFromDate:datePicker.date];
        NSString *oldTime = self.endLabel.text;
        //设定结束时间
        self.endLabel.text = timesp;
        //时间检测
        if(buttonIndex == 0 && [self timeCheck] == YES) {
            //更新数据 过程线和表格
            [self fetchDataByType:_nowIndex];
        } else {
            //时间出错，重新纠正复原
            self.endLabel.text = oldTime;
        }
    }
}

@end
