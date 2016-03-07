//
//  GPLWaterListViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLWaterListViewController.h"
#import "GPLWaterCell.h"
#import "GPLWaterListInfo.h"
#import "GPLWaterDetailViewController.h"
#import "TipsViewController.h"

@interface GPLWaterListViewController ()

@end

@implementation GPLWaterListViewController

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
    _waterListArray = [[NSMutableArray alloc] init];
    _waterShowArray = [[NSMutableArray alloc] init];
    _typeIndex = 0; //0:所有 1:超警 2：超危级
    _szsx = @"所有水系"; //上塘河、下塘河、涂内、钱塘江
    // Do any additional setup after loading the view from its nib.
    NSString *url = @"http://42.120.40.150/haining/DataService/WaterList";
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
            [_waterListArray removeAllObjects];
            [_waterShowArray removeAllObjects];
            NSArray *waterTemArray = [totalDic objectForKey:@"Contents"];
            for (int i = 0; i < [waterTemArray count]; i++) {
                NSDictionary *contentDic = [waterTemArray objectAtIndex:i];
                GPLWaterListInfo *info = [[GPLWaterListInfo alloc] init];
                info.waterID = [contentDic objectForKey:@"id"];
                info.name = [contentDic objectForKey:@"name"];
                info.river = [contentDic objectForKey:@"river"];
                info.time = [contentDic objectForKey:@"time"];
                info.river = [contentDic objectForKey:@"river"];
                NSString *special = [contentDic objectForKey:@"tip"];
                [info setSpecial:special];
                info.wusongLevel = [contentDic objectForKey:@"water_ws"];
                [_waterListArray addObject:info];
            }
        }
    }
}

-(void)updateScreen;
{
    //确认隐藏对象
    [self hideKeyByType];
    //正确处理
    [_waterList reloadData];
    //异常处理
    if ([_waterListArray count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取数据出错~"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)hideKeyByType {
    //先去掉
    [_waterShowArray removeAllObjects];
    //初始化为 1
    [_waterShowArray removeAllObjects];

    for (int i = 0; i < [_waterListArray count]; i++) {
        GPLWaterListInfo *info = [_waterListArray objectAtIndex:i];
        float wusong = [info.wusongLevel floatValue];
        float warnLevel = [info.warnLevel floatValue];
        float dangerLevel = [info.dangerousLevel floatValue];
        NSString *rever = info.river;
        if (_typeIndex == 0 ) {
            //所有站点
            if ([_szsx isEqualToString:@"所有水系"]) {
                [_waterShowArray addObject:info];
            } else if([_szsx isEqualToString:rever])  {
                [_waterShowArray addObject:info];
            }
        } else if (_typeIndex == 1 ) {
            //超警
            if (wusong >= warnLevel && warnLevel >0) {
                if ([_szsx isEqualToString:@"所有水系"]) {
                    [_waterShowArray addObject:info];
                } else if([_szsx isEqualToString:rever])  {
                    [_waterShowArray addObject:info];
                }            }
        } else if (_typeIndex == 2) {
            //超危
            if (wusong >= dangerLevel && dangerLevel >0) {
                if ([_szsx isEqualToString:@"所有水系"]) {
                    [_waterShowArray addObject:info];
                } else if([_szsx isEqualToString:rever])  {
                    [_waterShowArray addObject:info];
                }
            }
        }
    }
}

-(IBAction)sxWater:(id)sender;
{
    //弹出选择
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"所有水系",@"上塘河",@"下塘河",@"涂内",@"钱塘江", nil];
    [sheet showInView:self.view];
}

-(IBAction)goToTips:(id)sender
{
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3) {
        TipsViewController *vc = [[TipsViewController alloc] initWithNibName:@"TipsViewController5" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        TipsViewController *vc = [[TipsViewController alloc] initWithNibName:@"TipsViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }}

-(IBAction)allWater:(id)sender;
{
    
}

-(IBAction)cjWater:(id)sender;
{
    
}

-(IBAction)wjWater:(id)sender;
{
    
}

-(IBAction)changeSeg:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    int selectIndex = seg.selectedSegmentIndex;
    switch (selectIndex) {
        case 0:
            //所有
            [_syBtn setEnabled:NO];
            [_jjBtn setEnabled:YES];
            [_wjBtn setEnabled:YES];
            _typeIndex = 0;
            [self updateScreen];
            break;
        case 1:
            //超警
            [_syBtn setEnabled:YES];
            [_jjBtn setEnabled:NO];
            [_wjBtn setEnabled:YES];
            _typeIndex = 1;
            [self updateScreen];
            break;
        case 2:
            //危急
            [_syBtn setEnabled:YES];
            [_jjBtn setEnabled:YES];
            [_wjBtn setEnabled:NO];
            _typeIndex = 2;
            [self updateScreen];
            break;
        default:
            break;
    }
}


#pragma UITableViewDelegate and UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_waterShowArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GPLWaterListInfo *info = [_waterShowArray objectAtIndex:indexPath.row];
    float warnLevel = [info.warnLevel floatValue];
    float dangerLevel = [info.dangerousLevel floatValue];
    if (dangerLevel!=0) {
        static NSString *CellIdentifier = @"CustomCellIdentifier";
        GPLWaterCell *cell = (GPLWaterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLWaterCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        cell.nameLabel.text = info.name;
        cell.waterName.text = info.river;
        cell.timeLabel.text = info.time;
        cell.waterLevel.text = info.wusongLevel;
        //cell.waterLevel2.text = info.dangerousLevel;
        //判断
        float wusong = [info.wusongLevel floatValue];
        
        if (wusong > warnLevel && warnLevel !=0 ) {
            UIImage *image = [UIImage imageNamed:@"ico_water_chao"];
            cell.warnImgV.image = image;
        }
        if (wusong > dangerLevel && dangerLevel !=0 ) {
            UIImage *image = [UIImage imageNamed:@"ico_water_wei"];
            cell.warnImgV.image = image;
        }
        return cell;
    } else {
        static NSString *CellIdentifier2 = @"CustomCellIdentifier2";
        GPLWaterCell *cell = (GPLWaterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLWaterCell2" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        cell.nameLabel.text = info.name;
        cell.waterName.text = info.river;
        cell.timeLabel.text = info.time;
        cell.waterLevel.text = info.wusongLevel;
        //判断
        float wusong = [info.wusongLevel floatValue];
        
        if (wusong > warnLevel && warnLevel !=0 ) {
            UIImage *image = [UIImage imageNamed:@"ico_water_chao"];
            cell.warnImgV.image = image;
        }
        if (wusong > dangerLevel && dangerLevel !=0 ) {
            UIImage *image = [UIImage imageNamed:@"ico_water_wei"];
            cell.warnImgV.image = image;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    GPLWaterListInfo *info = [_waterShowArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int valueDevice = [[UIDevice currentDevice] resolution];
    NSString *string;
    GPLWaterDetailViewController *vc;
    if (valueDevice == 3) {
        string = @"GPLWaterDetailViewController5";
        vc = [[GPLWaterDetailViewController alloc] initWithNibName:string bundle:nil];
    } else {
        string = @"GPLWaterDetailViewController";
        vc = [[GPLWaterDetailViewController alloc] initWithNibName:string bundle:nil];
    }
    vc.portNm = info.name;
    vc.portClient = info.waterID;
    vc.myJJV = info.warnLevel;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        //所有水系
        self.szsx = @"所有水系";
        [self updateScreen];
    } else if (buttonIndex == 1) {
        //上塘河
        self.szsx = @"上塘河";
        [self updateScreen];
    } else if (buttonIndex == 2) {
        //下塘河
        self.szsx = @"下塘河";
        [self updateScreen];
    } else if (buttonIndex == 3) {
        //涂内‘
        self.szsx = @"涂内";
        [self updateScreen];
    } else if (buttonIndex == 4) {
        //钱塘江
        self.szsx = @"钱塘江";
        [self updateScreen];
    }
    self.szsxLabel.title = _szsx;
    NSLog(@"%d",buttonIndex);
}



@end
