//
//  GPLPhoneListViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLDepartListViewController.h"
#import "GPLPhoneCell.h"
#import "GPLDepartInfo.h"
#import "GPLPersonInfo.h"

@interface GPLDepartListViewController ()

@end

@implementation GPLDepartListViewController

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
    _phoneArray = [[NSMutableArray alloc] init];
    _personArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    NSString *url = [NSString stringWithFormat:@"http://42.120.40.150/haining/DataService/PersonList/%@",_departInfo.unitid];
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
    BOOL isOK = NO;
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
                info.mobile = [contentDic objectForKey:@"mobile"];
                info.nickName = [contentDic objectForKey:@"nickName"];
                info.position = [contentDic objectForKey:@"position"];
                info.tel = [contentDic objectForKey:@"tel"];
                info.uid = [contentDic objectForKey:@"uid"];
                info.username = [contentDic objectForKey:@"username"];
                info.depar = _departInfo.unitname;
                [_personArray addObject:info];
            }
        }
    }
    [self.phoneList reloadData];
}

-(void)updateScreen {    
//    for (int i =0; i < [_phoneArray count]; i++) {
//        GPLDepartInfo *info = [_phoneArray objectAtIndex:i];
//        NSString *url2 = [NSString stringWithFormat:@"http://42.120.40.150/haining/DataService/PersonList/%@",info.unitid];
//        [self fetchDataWithURLString2:url2 withSpecial:info.unitname];
//    }
}

-(void)parseXML2:(NSData *)data withSpecial:(NSString *)string;
{
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
            NSArray *psArray = [totalDic objectForKey:@"Contents"];
            for (int i = 0; i < [psArray count]; i++) {
                //{"mobile":"13806701508","nickName":"虞铭华","position":"局长","tel":"","uid":"5","username":"虞铭华"}
                NSDictionary *contentDic = [psArray objectAtIndex:i];
                GPLPersonInfo *info = [[GPLPersonInfo alloc] init];
                info.mobile = [contentDic objectForKey:@"mobile"];
                info.nickName = [contentDic objectForKey:@"nickName"];
                info.position = [contentDic objectForKey:@"position"];
                info.tel = [contentDic objectForKey:@"tel"];
                info.uid = [contentDic objectForKey:@"uid"];
                info.username = [contentDic objectForKey:@"username"];
                info.depar = string;
                [_personArray addObject:info];
            }
        }
    }
    [self.phoneList reloadData];
}

#pragma UITableViewDelegate and UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_personArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    GPLPhoneCell *cell = (GPLPhoneCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLPhoneCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    GPLPersonInfo *info = [_personArray objectAtIndex:indexPath.row];
    cell.personName.text = [NSString stringWithFormat:@"%@(%@)",info.nickName,info.position];
    cell.personDepart.text = info.depar;
    cell.personMobile.text = info.mobile;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    GPLPersonInfo *info = [_personArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *msg = [[NSString alloc] initWithFormat:@"是否接通%@%@%@？", info.depar,info.nickName,info.position];
	self.phoneNmber = info.mobile;
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:msg
								  delegate:self
								  cancelButtonTitle:@"取消"
								  destructiveButtonTitle:[NSString stringWithFormat:@"拨打%@",info.mobile]
								  otherButtonTitles:nil];
	[actionSheet showInView:self.view];
}



#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (!buttonIndex == [actionSheet cancelButtonIndex])
	{
		NSString *msg = [[NSString alloc] initWithFormat:@"tel://%@", _phoneNmber];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:msg]];
	}
	
}

@end
