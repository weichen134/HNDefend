//
//  GPLWaterDetailViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLWaterDetailViewController.h"
#import "GPLWaterListInfo.h"
#import "GPLWaterDetailCell.h"
#import "NSString+HXAddtions.h"


@interface GPLWaterDetailViewController ()

@end

@implementation GPLWaterDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectType = @"hour";
        _waterDetailArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    //处理横屏
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
    self.navigationController.view.transform = CGAffineTransformIdentity;
    self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI * (-90)/180);
    int valueDevice = [[UIDevice currentDevice] resolution];
    int plus = 0;
    if (valueDevice == 3)
    {
        plus = 88;
    }
    CGRect nFrame = self.navigationController.view.bounds;
    int width = nFrame.size.height;
    int height = nFrame.size.width;
    self.navigationController.view.bounds = CGRectMake(0,0, width, height);
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.view.transform = CGAffineTransformIdentity;
    self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI * (0)/180);
    int valueDevice = [[UIDevice currentDevice] resolution];
    int plus = 0;
    if (valueDevice == 3)
    {
        plus = 88;
    }
    CGRect nFrame = self.navigationController.view.bounds;
    int width = nFrame.size.height;
    int height = nFrame.size.width;
    self.navigationController.view.bounds = CGRectMake(0,0, width, height);
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    _webView.scalesPageToFit = NO;
    _waterDetailArray = [[NSMutableArray alloc] init];
    self.titleLabel.text = _portNm;
    //默认加载时间段
    [self setHourStandardTime];
    //所有的资源都在source.bundle这个文件夹里
    int valueDevice = [[UIDevice currentDevice] resolution];
    NSString *sub;
    if (valueDevice == 3)
    {
        sub = @"5";
    }
    else
    {
        sub = @"";
    }
    NSString *stringPath = [NSString stringWithFormat:@"source.bundle/index%@.html",sub];
    NSString* htmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:stringPath];
    NSURL* url = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    int trueWidth = self.view.frame.size.width;
    if (trueWidth < self.view.frame.size.height && ![UIApplication sharedApplication].statusBarHidden)
    {
        trueWidth = self.view.frame.size.height + MIN([UIApplication sharedApplication].statusBarFrame.size.height,[UIApplication sharedApplication].statusBarFrame.size.width);
    }
    
    //初始加载的是小时水位统计
    [self fetchDatabyType:@"hour"];
    
    //不允许缩放
    for (UIView *view in _webView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            scrollView.scrollEnabled = NO;
        }
    }
}

-(void)fetchDatabyType:(NSString *)type;
{
    //NSString *url = @"http://42.120.40.150/haining/DataService/HistoryWaterList/day/13732591584/2013-07-25/2013-08-26";
    NSString *begin = self.beginDateLabel.text;
    NSString *end = self.endDateLabel.text;
    NSString *url = [NSString stringWithFormat:@"http://42.120.40.150/haining/DataService/HistoryWaterList/%@/%@/%@/%@",type,_portClient,begin,end];
    [self fetchDataWithURLString:url];
}

-(void)parseXML:(NSData *)data;
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(string);
    //整个JSON
    NSArray *totalArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    Boolean isOK = true;
    if ([totalArray count] > 0) {
        //这个对象都在了
        NSDictionary *totalDic = [totalArray objectAtIndex:0];
        //Result对象
        NSNumber *resNum = [totalDic objectForKey:@"Result"];
        isOK = [resNum boolValue];
        if (isOK) {
            //如果正确地话，移除所有对象先
            [_waterDetailArray removeAllObjects];
            NSArray *waterTemArray = [totalDic objectForKey:@"Contents"];
            //特殊
            NSArray *waterMaxArray = [totalDic objectForKey:@"Max"];
            NSArray *waterMinArray = [totalDic objectForKey:@"Min"];
            NSString *waterAvgArray = [totalDic objectForKey:@"Avg"];
            //最大
            if (waterMaxArray != [NSNull null]) {
                for (int i=0; i<[waterMaxArray count]; i++) {
                    NSDictionary *contentDic = [waterMaxArray objectAtIndex:i];
                    _myMax = [[GPLWaterListInfo alloc] init];
                    _myMax.waterID = [contentDic objectForKey:@"id"];
                    _myMax.time = [contentDic objectForKey:@"time"];
                    _myMax.wusongLevel = [contentDic objectForKey:@"data"];
                }
            } else {
                self.myMax = [[GPLWaterListInfo alloc] init];;
            }
            //最小
            if (waterMinArray != [NSNull null]) {
                for (int i=0; i<[waterMinArray count]; i++) {
                    NSDictionary *contentDic = [waterMinArray objectAtIndex:i];
                    _myMin = [[GPLWaterListInfo alloc] init];
                    _myMin.waterID = [contentDic objectForKey:@"id"];
                    _myMin.time = [contentDic objectForKey:@"time"];
                    _myMin.wusongLevel = [contentDic objectForKey:@"data"];
                }
            } else {
                self.myMin = [[GPLWaterListInfo alloc] init];;
            }
            //平均
            if (waterAvgArray != [NSNull null]) {
                _myAvg = [[GPLWaterListInfo alloc] init];
                _myAvg.wusongLevel = waterAvgArray;
            } else {
                self.myAvg = [[GPLWaterListInfo alloc] init];
            }
            
            //数据：赋值myJSON对象 myJSON对象在画图中需要用到
            if (waterTemArray != [NSNull null]) {
                self.myJSON = [NSString jsonStringWithArray:waterTemArray];
                NSLog(_myJSON);
                for (int i = 0; i < [waterTemArray count]; i++) {
                    NSDictionary *contentDic = [waterTemArray objectAtIndex:i];
                    GPLWaterListInfo *info = [[GPLWaterListInfo alloc] init];
                    info.waterID = [contentDic objectForKey:@"id"];
                    NSString *temTime = [contentDic objectForKey:@"time"];
                    if ([temTime isEqualToString:_myMax.time]) {
                        info.time = [NSString stringWithFormat:@"%@(最大)",[contentDic objectForKey:@"time"]];
                    } else if ([temTime isEqualToString:_myMin.time]) {
                        info.time =  [NSString stringWithFormat:@"%@(最小)",[contentDic objectForKey:@"time"]];
                    } else {
                        info.time = [contentDic objectForKey:@"time"];
                    }
                    info.wusongLevel = [contentDic objectForKey:@"data"];
                    [_waterDetailArray addObject:info];
                }
            } else {
                self.myJSON = @"[]";
            }
        }
    }
}

-(void)updateScreen;
{
    [self.waterDetailList reloadData];
    [self.waterDetailList scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
    //警戒值
    //NSLog(@"convertStringToJSON(%@,%.2f)",_myJSON,[_myJJV floatValue]);
    [jsStr appendFormat:@"convertStringToJSON(%@,%.2f)",_myJSON,[_myJJV floatValue]];
    [_webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    //更新特征值
    if (_myMax != nil) {
        _oneDateLabel.text = [NSString stringWithFormat:@"%.2f",[_myMax.wusongLevel floatValue]];
    } else {
        _oneDateLabel.text = @"--";
    }
    if (_myMin !=nil) {
        _twoDateLabel.text = [NSString stringWithFormat:@"%.2f",[_myMin.wusongLevel floatValue]];
    } else {
        _twoDateLabel.text = @"--";
    }
    if (_myAvg !=nil) {
        _threeDateLabel.text = [NSString stringWithFormat:@"%.2f",[_myAvg.wusongLevel floatValue]];
    } else {
        _threeDateLabel.text = @"--";
    }
    if (_myJJV !=nil && [_myJJV isEqualToString:@"--"]== NO) {
        _fourDateLabel.text = [NSString stringWithFormat:@"%.2f",[_myJJV floatValue]];
    } else {
        _fourDateLabel.text = @"--";
    }
    
//    if ([_waterDetailArray count] == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无数据或获取数据出错~"
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }
}

#pragma IBAction
-(IBAction)changeType:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"水位统计方式选择"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"小时水位统计"
                                              otherButtonTitles:@"日水位8时统计", nil];
    sheet.tag = 666;
    [sheet showInView:self.view];
}

-(IBAction)chooseTable:(id)sender;
{
    [self.tableBtn setEnabled:NO];
    [self.chartBtn setEnabled:YES];
    [self.waterDetailList setHidden:NO];
    [self.webView setHidden:YES];
}

-(IBAction)selectBeginDate:(id)sender
{
    [self selectValue:0];
}

-(IBAction)selectEndDate:(id)sender
{
    [self selectValue:1];
}

-(IBAction)chooseChart:(id)sender;
{
    [self.tableBtn setEnabled:YES];
    [self.chartBtn setEnabled:NO];
    [self.waterDetailList setHidden:YES];
    [self.webView setHidden:NO];
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
    NSString *beginT = self.beginDateLabel.text;
    NSString *endT = self.endDateLabel.text;
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

-(void)setHourStandardTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSString *now = [formatter stringFromDate:nowDate];
    self.beginDateLabel.text = now;
    self.endDateLabel.text = now;
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
    self.beginDateLabel.text = beginDateT;
    self.endDateLabel.text = now;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIDeviceOrientationIsLandscape(interfaceOrientation);
}

#pragma UITableViewDelegate and UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_waterDetailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    GPLWaterDetailCell *cell = (GPLWaterDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLWaterDetailCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    GPLWaterListInfo *info = [_waterDetailArray objectAtIndex:indexPath.row];
    cell.waterCode.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    cell.waterName.text = _portNm;
    cell.waterTime.text = info.time;
    cell.waterLevel.text = [NSString stringWithFormat:@"%.2f",[info.wusongLevel floatValue]];
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
        NSString *oldTime = self.beginDateLabel.text;
        //设定开始时间
        self.beginDateLabel.text = timesp;
        //时间检测
        if(buttonIndex == 0 && [self timeCheck] == YES) {
            //更新数据 过程线和表格
            [self fetchDatabyType:_selectType];
        } else {
            //时间出错，重新纠正复原
            self.beginDateLabel.text = oldTime;
        }
    } else if (actionSheet.tag == 889) {
        //结束时间
        UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *timesp = [formatter stringFromDate:datePicker.date];
        NSString *oldTime = self.endDateLabel.text;
        //设定结束时间
        self.endDateLabel.text = timesp;
        //时间检测
        if(buttonIndex == 0 && [self timeCheck] == YES) {
            //更新数据 过程线和表格
            [self fetchDatabyType:_selectType];
        } else {
            //时间出错，重新纠正复原
            self.endDateLabel.text = oldTime;
        }
    } else if (actionSheet.tag == 666) {
        if (buttonIndex == 0) {
            //日水位统计
            self.selectType = @"hour";
            self.mainDescLabel.text = @"小时水位统计(m)";
            //时间变换
            [self setHourStandardTime];
            //更新数据 过程线和表格
            [self fetchDatabyType:@"hour"];
        } else if (buttonIndex == 1) {
            //月水位统计
            self.selectType = @"day";
            self.mainDescLabel.text = @"日水位8时统计(m)";
            //时间变换
            [self setDayStandardTime];
            //更新数据 过程线和表格
            [self fetchDatabyType:@"day"];
        }
    }
}

#pragma mark - delegate of webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
    [jsStr appendFormat:@"convertStringToJSON(%@,%.2f)",_myJSON,[_myJJV floatValue]];
    [_webView stringByEvaluatingJavaScriptFromString:jsStr];
}

@end
