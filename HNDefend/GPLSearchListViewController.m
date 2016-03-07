//
//  GPLSearchListViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLSearchListViewController.h"
#import "GPLSearchCell.h"
#import "GPLSearchInfo.h"
#import "GPLRainDetailViewController.h"
#import "GPLWaterDetailViewController.h"
#import "GPLProjectDetailViewController.h"
#import "GPLReportDetailViewController.h"
#import "GPLPersonInfo.h"
#import "GPLProjectInfo.h"

@interface GPLSearchListViewController ()

@end

@implementation GPLSearchListViewController

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
    _searchArray = [[NSMutableArray alloc] init];
    [_textField becomeFirstResponder];
}

-(IBAction)searchBegin:(id)sender
{
    [_textField resignFirstResponder];
    [_searchArray removeAllObjects];
    [self searchWithText:_textField.text];
}

-(void)searchWithText:(NSString *)text
{
    NSString *url = [NSString stringWithFormat:@"http://42.120.40.150/haining/DataService/SearchList/%@",text];
    [self fetchDataWithURLString:url];
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
            [_searchArray removeAllObjects];
            NSArray *searchArr = [totalDic objectForKey:@"Contents"];
            for (int i = 0; i < [searchArr count]; i++) {
                NSDictionary *contentDic = [searchArr objectAtIndex:i];
                GPLSearchInfo *info = [[GPLSearchInfo alloc] init];
                info.name = [contentDic objectForKey:@"name"];
                info.value = [contentDic objectForKey:@"value"];
                info.type = [contentDic objectForKey:@"type"];
                [_searchArray addObject:info];
            }
        }
    }
}

-(void)updateScreen;
{
    //正确处理
    [_searchList reloadData];
}


-(void)prepareThings;
{
    //这是一个父对象，方法在子对象中实现
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

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[_textField resignFirstResponder];
    //获取数据
    [_searchArray removeAllObjects];
    [self searchWithText:_textField.text];
	return YES;
}

#pragma UITableViewDelegate and UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_searchArray count];
}

-(void)parseXML2:(NSData *)data withSpecial:(NSString *)string;
{
    self.personInfo = nil;
    self.projectInfo = nil;
    //整个JSON
    NSString *strin = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(strin);
    NSArray *totalArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    BOOL isOK = NO;
    if ([string isEqualToString:@"通讯录"]) {
        if ([totalArray count] > 0) {
            //这个对象都在了
            NSDictionary *totalDic = [totalArray objectAtIndex:0];
            //Result对象
            NSNumber *resNum = [totalDic objectForKey:@"Result"];
            isOK = [resNum boolValue];
            if (isOK) {
                NSArray *psArray = [totalDic objectForKey:@"Contents"];
                for (int i = 0; i < [psArray count]; i++) {
                    //{"mobile":"13806701508","nickName":"虞铭华","position":"局长","tel":"","uid":"5","username":"虞铭华"}
                    NSDictionary *contentDic = [psArray objectAtIndex:i];
                    GPLPersonInfo *info = [[GPLPersonInfo alloc] init];
                    info.username = [contentDic objectForKey:@"username"];
                    info.nickName = [contentDic objectForKey:@"nickName"];
                    info.mobile = [contentDic objectForKey:@"mobile"];
                    info.position = [contentDic objectForKey:@"position"];
                    info.tel = [contentDic objectForKey:@"tel"];
                    info.uid = [contentDic objectForKey:@"uid"];
                    info.depar = string;
                    if ([info.username isEqualToString:_searchInfo.name] || [info.nickName isEqualToString:_searchInfo.name]) {
                        //找到了
                        self.personInfo = info;
                        [self callPhone];
                        break;
                    }
                }
            }
        }
    } else if([string isEqualToString:@"闸门"]) {
        if ([totalArray count] > 0) {
            //这个对象都在了
            NSDictionary *totalDic = [totalArray objectAtIndex:0];
            //Result对象
            NSNumber *resNum = [totalDic objectForKey:@"Result"];
            isOK = [resNum boolValue];
            if (isOK) {
                NSArray *psArray = [totalDic objectForKey:@"Contents"];
                for (int i = 0; i < [psArray count]; i++) {
                    //{"mobile":"13806701508","nickName":"虞铭华","position":"局长","tel":"","uid":"5","username":"虞铭华"}
                    NSDictionary *contentDic = [psArray objectAtIndex:i];
                    GPLProjectInfo *info = [[GPLProjectInfo alloc] init];
                    info.alarm = [contentDic objectForKey:@"alarm"];
                    info.height = [contentDic objectForKey:@"height"];
                    NSString *special1 = [contentDic objectForKey:@"height"];
                    NSString *specialFinal1 = [special1 stringByReplacingOccurrencesOfString:@"<br\/>" withString:@"\n"];
                    NSString *specialFinal12 = [specialFinal1 stringByReplacingOccurrencesOfString:@"[0]" withString:@""];
                    info.height = specialFinal12;
                    info.projectID = [contentDic objectForKey:@"id"];
                    info.name = [contentDic objectForKey:@"name"];
                    info.time = [contentDic objectForKey:@"time"];
                    NSString *special = [contentDic objectForKey:@"status"];
                    NSString *specialFinal = [special stringByReplacingOccurrencesOfString:@"<br\/>" withString:@"\n"];
                    info.status = specialFinal;
                    if ([info.projectID isEqualToString:_searchInfo.value]) {
                        //找到了
                        self.projectInfo = info;
                        [self jumpToGate];
                        break;
                    }
                }
            }
        }
    } else if([string isEqualToString:@"泵站"]) {
        if ([totalArray count] > 0) {
            //这个对象都在了
            NSDictionary *totalDic = [totalArray objectAtIndex:0];
            //Result对象
            NSNumber *resNum = [totalDic objectForKey:@"Result"];
            isOK = [resNum boolValue];
            if (isOK) {
                NSArray *psArray = [totalDic objectForKey:@"Contents"];
                for (int i = 0; i < [psArray count]; i++) {
                    NSDictionary *contentDic = [psArray objectAtIndex:i];
                    GPLProjectInfo *info = [[GPLProjectInfo alloc] init];
                    info.alarm = [contentDic objectForKey:@"alarm"];
                    info.height = [contentDic objectForKey:@"height"];
                    NSString *special1 = [contentDic objectForKey:@"height"];
                    NSString *specialFinal1 = [special1 stringByReplacingOccurrencesOfString:@"<br\/>" withString:@"\n"];
                    NSString *specialFinal12 = [specialFinal1 stringByReplacingOccurrencesOfString:@"[0]" withString:@""];
                    info.height = specialFinal12;
                    info.projectID = [contentDic objectForKey:@"id"];
                    info.name = [contentDic objectForKey:@"name"];
                    info.time = [contentDic objectForKey:@"time"];
                    NSString *special = [contentDic objectForKey:@"status"];
                    NSString *specialFinal = [special stringByReplacingOccurrencesOfString:@"<br\/>" withString:@"\n"];
                    info.status = specialFinal;
                    if ([info.projectID isEqualToString:_searchInfo.value]) {
                        //找到了
                        self.projectInfo = info;
                        [self jumpToPump];
                        break;
                    }
                }
            }
        }
    }
}

-(void)callPhone
{
    NSString *msg = [[NSString alloc] initWithFormat:@"是否接通%@%@？", _personInfo.nickName,_personInfo.position];
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:msg
								  delegate:self
								  cancelButtonTitle:@"取消"
								  destructiveButtonTitle:[NSString stringWithFormat:@"拨打%@",_personInfo.mobile]
								  otherButtonTitles:nil];
	[actionSheet showInView:self.view];
}

-(void)jumpToGate
{
    GPLProjectDetailViewController *vc;
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        vc = [[GPLProjectDetailViewController alloc]            initWithNibName:@"GPLProjectDetailViewController5" bundle:nil];
    } else {
        vc = [[GPLProjectDetailViewController alloc]            initWithNibName:@"GPLProjectDetailViewController" bundle:nil];
    }
    vc.portID = _projectInfo.projectID;
    vc.portNm = _projectInfo.name;
    vc.portStatus = _projectInfo.status;
    vc.portType = @"闸站";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)jumpToPump
{
    GPLProjectDetailViewController *vc;
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        vc = [[GPLProjectDetailViewController alloc]            initWithNibName:@"GPLProjectDetailViewController5" bundle:nil];
    } else {
        vc  = [[GPLProjectDetailViewController alloc]            initWithNibName:@"GPLProjectDetailViewController" bundle:nil];
    }
    vc.portID = _projectInfo.projectID;
    vc.portNm = _projectInfo.name;
    vc.portStatus = _projectInfo.height;
    vc.portType = @"泵站";
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    GPLSearchCell *cell = (GPLSearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLSearchCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    GPLSearchInfo *info = [_searchArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",info.name,info.type];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GPLSearchInfo *info = [_searchArray objectAtIndex:indexPath.row];
    self.searchInfo = info;
    int valueDevice = [[UIDevice currentDevice] resolution];
    if([info.type isEqualToString:@"雨情"]) {
        NSString *string;
        if (valueDevice == 3) {
            string = @"GPLRainDetailViewController5";
        } else {
            string = @"GPLRainDetailViewController";
        }
        GPLRainDetailViewController *vc = [[GPLRainDetailViewController alloc] initWithNibName:string bundle:nil];
        vc.portNm = info.name;
        vc.portClient = info.value;
        [self.navigationController pushViewController:vc animated:YES];
    } else if([info.type isEqualToString:@"水情"]) {
        NSString *string;
        if (valueDevice == 3) {
            string = @"GPLWaterDetailViewController5";
        } else {
            string = @"GPLWaterDetailViewController";
        }
        GPLWaterDetailViewController *vc = [[GPLWaterDetailViewController alloc]    initWithNibName:string bundle:nil];
        vc.portNm = info.name;
        vc.portClient = info.value;
        [self.navigationController pushViewController:vc animated:YES];
    } else if([info.type isEqualToString:@"泵站"]) {
        NSString *url2 = @"http://42.120.40.150/haining/DataService/PumpList";
        [self fetchDataWithURLString2:url2 withSpecial:@"泵站"];
    } else if([info.type isEqualToString:@"闸门"]) {
        NSString *url2 = @"http://42.120.40.150/haining/DataService/GateList";
        [self fetchDataWithURLString2:url2 withSpecial:@"闸门"];
    } else if([info.type isEqualToString:@"通知公告"]) {
        NSString *string;
        if (valueDevice == 3) {
            string = @"GPLReportDetailViewController5";
        } else {
            string = @"GPLReportDetailViewController";
        }
        GPLReportDetailViewController *vc = [[GPLReportDetailViewController alloc] initWithNibName:string bundle:nil];
        vc.portID = info.value;
        vc.portName = info.name;
        [self.navigationController pushViewController:vc animated:YES];
    } else if([info.type isEqualToString:@"通讯录"]) {
        NSString *url2 = [NSString stringWithFormat:@"http://42.120.40.150/haining/DataService/PersonDetail/%@",info.value];
        [self fetchDataWithURLString2:url2 withSpecial:@"通讯录"];
    }
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (!buttonIndex == [actionSheet cancelButtonIndex])
	{
		NSString *msg = [[NSString alloc] initWithFormat:@"tel://%@", _personInfo.mobile];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:msg]];
	}
	
}

@end
