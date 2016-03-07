//
//  GPLProjectListViewController.m
//  HNDefend
//
//  Created by GPL on 13-9-9.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLProjectListViewController.h"
#import "GPLProjectCell.h"
#import "GPLProjectInfo.h"
#import "GPLProjectDetailViewController.h"
#import "GPLHsTableViewCell.h"
@interface GPLProjectListViewController ()
@property(nonatomic,strong)NSMutableArray *updateTimeArray;
@property(nonatomic,strong)NSMutableArray *nameArray;
@end

@implementation GPLProjectListViewController

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
    //http://42.120.40.150/haining/DataService/PumpList
    _projectArray = [[NSMutableArray alloc] init];
    _heightArray = [[NSMutableArray alloc] init];
    self.nowType = @"闸站";
    [self fetchDataByType:@"闸站"]; 
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

-(void)fetchDataByType:(NSString *)type
{
    [_projectArray removeAllObjects];
    [_heightArray removeAllObjects];
    
    if ([type isEqualToString:@"闸站"]) {
        self.nowType = @"闸站";
        NSString *url = @"http://42.120.40.150/haining/DataService/GateList";
        [self fetchDataWithURLString:url];
    } else if ([type isEqualToString:@"泵站"]) {
        self.nowType = @"泵站";
        NSString *url = @"http://42.120.40.150/haining/DataService/PumpList";
        [self fetchDataWithURLString:url];
    } else if ([type isEqualToString:@"周边"]) {
        self.nowType = @"周边";
        NSString *url = @"http://m.jxwater.gov.cn/share/haining?p=$AL^!a8";
        [self fetchDataWithURLString2:url withSpecial:@""];
    }
    else if ([type isEqualToString:@"活水"])
    {
        self.nowType = @"活水";
        NSString *url = @"http://www.zjhnsl.com/Base/pumpstatelist2";
        [self fetchDataWithURLString2:url withSpecial:@""];
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
            [_projectArray removeAllObjects];
            NSArray *waterTemArray = [totalDic objectForKey:@"Contents"];
            for (int i = 0; i < [waterTemArray count]; i++) {
                NSDictionary *contentDic = [waterTemArray objectAtIndex:i];
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
                [_projectArray addObject:info];

            }
        }
    }
}

-(void)updateScreen;
{
    //正确处理
    [_projectList reloadData];
    //异常处理
    if ([_projectArray count] == 0) {
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
    
}


-(void)parseXML2:(NSData *)data withSpecial:(NSString *)string;
{
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(str);
    //整个JSON
    NSDictionary *totalDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSMutableArray *totalArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    BOOL isOK = NO;
//运输河闸站、石西河闸站、青寺河闸站、金安港闸站、糜家闸站、胜利闸站、枉品闸站
//   13         9        7           6          8      5        17
    if ([self.nowType isEqualToString:@"活水"])
    {

        NSDictionary *dic = [NSDictionary dictionary];
        NSDictionary *PGState2Dic = [NSDictionary dictionary];
        NSDictionary *cilentDic = [NSDictionary dictionary];
        NSMutableArray *mutableArray = [NSMutableArray array];

        self.updateTimeArray = [NSMutableArray array];
        self.nameArray = [NSMutableArray array];
        NSString *updateTime = @"";
//        NSString *name = @"";
        NSMutableArray *tempArray = [NSMutableArray array];
        for(int i= 0 ;i<totalArray.count;i++)
        {

            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:totalArray[i]];
            NSString *clientID =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"ClientID"]];

            NSDictionary *dict2 = [dict objectForKey:@"Client"];
            NSString *name = [dict2 objectForKey:@"Name"];
            NSLog(@"clientID=%@",clientID);
            
            if([clientID isEqualToString:@"13"])
            {
                [dict setObject:@"1" forKey:@"tag"];

                [tempArray addObject:dict];
            }else if ([clientID isEqualToString:@"9"]){
                [dict setObject:@"2" forKey:@"tag"];
                
                [tempArray addObject:dict];
            }else if ([clientID isEqualToString:@"7"]){
                [dict setObject:@"3" forKey:@"tag"];
                [tempArray addObject:dict];
            }else if([clientID isEqualToString:@"6"]){
                [dict setObject:@"4" forKey:@"tag"];
                [tempArray addObject:dict];
            }else if ([clientID isEqualToString:@"8"]){
                [dict setObject:@"5" forKey:@"tag"];
                [tempArray addObject:dict];
            }else if ([clientID isEqualToString:@"5"]){
                [dict setObject:@"6" forKey:@"tag"];
                [tempArray addObject:dict];
            }else if ([clientID isEqualToString:@"17"]){
                [dict setObject:@"7" forKey:@"tag"];
                [tempArray addObject:dict];
            }

        }
        NSLog(@"排序后的array=%@",tempArray);

        NSSortDescriptor *_sorter = [[NSSortDescriptor alloc] initWithKey:@"tag"
                                                                 ascending:YES];//按照tag升序
        NSArray *arr = [tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:_sorter, nil]];
            for (int i = 0; i < arr.count; i++)
            {
                
                dic = arr[i];
                cilentDic = [dic objectForKey:@"Client"];
                NSString *name = [cilentDic objectForKey:@"Name"];
                
                PGState2Dic = [dic objectForKey:@"PGState2"];
                
                updateTime = [dic objectForKey:@"UpdateTimeString"];
                [mutableArray addObject:PGState2Dic];
                [self.updateTimeArray addObject:updateTime];
                [self.nameArray addObject:name];
            }
//            NSLog(@"name=%@",self.nameArray);
            for (int i = 0; i < mutableArray.count; i ++)
            {
                GPLProjectInfo *info = [[GPLProjectInfo alloc] init];
                NSDictionary *contentDic = [NSDictionary dictionary];
                contentDic = mutableArray[i];
                info.PowerState = [contentDic objectForKey:@"PowerState"];
                
                info.AIsOpen = [contentDic objectForKey:@"AIsOpen"];
                info.BIsOpen = [contentDic objectForKey:@"BIsOpen"];
                info.CIsOpen = [contentDic objectForKey:@"CIsOpen"];
                info.DIsOpen = [contentDic objectForKey:@"DIsOpen"];
                
                info.AStarting = [contentDic objectForKey:@"AStarting"];
                info.BStarting = [contentDic objectForKey:@"BStarting"];
                info.CStarting = [contentDic objectForKey:@"CStarting"];
                info.DStarting = [contentDic objectForKey:@"DStarting"];
                
                info.AElectric = [contentDic objectForKey:@"AElectric"];
                info.BElectric = [contentDic objectForKey:@"BElectric"];
                info.CElectric = [contentDic objectForKey:@"CElectric"];
                info.DElectric = [contentDic objectForKey:@"DElectric"];
                
                info.GateCount = [contentDic objectForKey:@"GateCount"];
                info.PumpCount = [contentDic objectForKey:@"PumpCount"];
                
                [_projectArray addObject:info];
                // NSLog(@"%@",self.projectArray);
            }
            
        


       

    }
    else
    {
        if ([totalDic count] > 0) {
            NSArray *controllers = [totalDic objectForKey:@"Controls"];
            for (NSDictionary *dic in controllers) {
                NSDictionary *controlData = [dic objectForKey:@"ControlData"];
                //{"Stnm":"下河泵","OpenTime":"2015-07-08T08:22:55.84","Flags":"1,1,0,1"}
                NSString *stnm = [controlData objectForKey:@"Stnm"];
                if ([stnm isKindOfClass:[NSNull class]])
                {
                    return;
                }
                if ([stnm isEqualToString:@"长山闸"] || [stnm isEqualToString:@"下河闸"] || [stnm isEqualToString:@"下河泵"])
                {
                    NSString *openT = [controlData objectForKey:@"OpenTime"];
                    NSString *flags = [controlData objectForKey:@"Flags"];
                    GPLProjectInfo *info = [[GPLProjectInfo alloc] init];
                    
                    info.alarm = @"设备正常";
                    info.height = @"0";
                    info.name = stnm;
                    info.time = (openT == [NSNull null]) ? @"-":openT;
                    if ([info.time isEqualToString:@"-"] == NO)
                    {
                        NSString *openTT = [info.time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        //格式化时间
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                        NSDate *td = [formatter dateFromString:openTT];
                        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
                        [formatter2 setDateFormat:@"MM-dd HH:mm:ss"];
                        info.time = [formatter2 stringFromDate:td];
                    }
                    NSArray *sControllers = [flags componentsSeparatedByString:@","];
                    NSMutableString *ms = @"";
                    for (int i = 0; i< [sControllers count]; i++) {
                        NSString *s = [sControllers objectAtIndex:i];
                        NSString *stat = [s isEqualToString:@"0"]?@"关闭":@"开启";
                        NSString *fs;
                        if (i== ([sControllers count]-1)) {
                            fs = [NSString stringWithFormat:@"%d#%@",i+1,stat];
                        } else {
                            fs = [NSString stringWithFormat:@"%d#%@\n",i+1,stat];
                        }
                        ms = [ms stringByAppendingString:fs];
                    }
                    info.status = ms;
                    [_projectArray addObject:info];
                }
            }
    }
    
    }

}

-(void)updateScreen2;
{
    //正确处理
    [_projectList reloadData];
    //异常处理
    if ([_projectArray count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取数据出错~"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}


-(IBAction)zzgq:(id)sender;
{
    [_zzBtn setEnabled:NO];
    [_bzBtn setEnabled:YES];
    [_zbBtn setEnabled:YES];
    [_hsBtn setEnabled:YES];

    [self fetchDataByType:@"闸站"];
}

-(IBAction)bzgq:(id)sender;
{
    [_zzBtn setEnabled:YES];
    [_bzBtn setEnabled:NO];
    [_zbBtn setEnabled:YES];
    [_hsBtn setEnabled:YES];

    [self fetchDataByType:@"泵站"];
}

-(IBAction)zbgq:(id)sender;
{
    [_zzBtn setEnabled:YES];
    [_bzBtn setEnabled:YES];
    [_zbBtn setEnabled:NO];
    [_hsBtn setEnabled:YES];
    
    [self fetchDataByType:@"周边"];
}

-(IBAction)hsgq:(id)sender
{
    [_zzBtn setEnabled:YES];
    [_bzBtn setEnabled:YES];
    [_zbBtn setEnabled:YES];
    [_hsBtn setEnabled:NO];
    [self fetchDataByType:@"活水"];

}

#pragma UITableViewDelegate and UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_projectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.nowType isEqualToString:@"周边"]) {
        static NSString *CellIdentifier = @"CustomCellIdentifier2";
        GPLProjectCell *cell = (GPLProjectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLProjectCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        GPLProjectInfo *info = [_projectArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = info.name;
        NSArray *timeArray = [info.time componentsSeparatedByString:@" "];
        if ([info.time isEqualToString:@"-"] == NO) {
            NSString *timeS = [NSString stringWithFormat:@"%@ %@",[timeArray objectAtIndex:0],[timeArray objectAtIndex:1]];
            cell.timeLabel.text = timeS;
        } else {
            cell.timeLabel.text = @"---";
        }
        if ([info.alarm isEqualToString:@"设备正常"] == NO) {
            UIImage *image = [UIImage imageNamed:@"ico_project_err"];
            cell.wrongBg.image = image;
        }
        NSString *heightString = [_heightArray objectAtIndex:indexPath.row];
        [cell setHeight:heightString];
        cell.waterLevel.text = info.status;
        return cell;
    }
    else if ([self.nowType isEqualToString:@"活水"])
    {
        static NSString *CellIdentifier = @"CustomCellIdentifier3";
        GPLHsTableViewCell *cell = (GPLHsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLHsTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell setStatusModel:_projectArray[indexPath.row]];
        cell.updateTimeLabel.text = self.updateTimeArray[indexPath.row];
        cell.nameLabel.text = self.nameArray[indexPath.row];
        cell.userInteractionEnabled = NO; 
        return cell;

    }
    else
    {
        static NSString *CellIdentifier = @"CustomCellIdentifier";
        GPLProjectCell *cell = (GPLProjectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GPLProjectCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        GPLProjectInfo *info = [_projectArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = info.name;
        NSArray *timeArray = [info.time componentsSeparatedByString:@"-"];
        if ([timeArray count] == 3) {
            NSString *timeS = [NSString stringWithFormat:@"%@-%@",[timeArray objectAtIndex:1],[timeArray objectAtIndex:2]];
            cell.timeLabel.text = timeS;
        } else {
            cell.timeLabel.text = @"---";
        }
        if ([info.alarm isEqualToString:@"设备正常"] == NO) {
            UIImage *image = [UIImage imageNamed:@"ico_project_err"];
            cell.wrongBg.image = image;
        }
        NSString *heightString = [_heightArray objectAtIndex:indexPath.row];
        [cell setHeight:heightString];
        cell.waterLevel.text = info.status;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.nowType isEqualToString:@"活水"])
    {
        return 220;
    }
    GPLProjectInfo *info = [_projectArray objectAtIndex:indexPath.row];
    NSString *string = info.status;
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    int plusHeight = 16 * [array count] - 16;
    [_heightArray addObject:[NSString stringWithFormat:@"%d",plusHeight]];
    return 65 + plusHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if ([self.nowType isEqualToString:@"周边"] == NO) {
        GPLProjectInfo *info = [_projectArray objectAtIndex:indexPath.row];
        GPLProjectDetailViewController *vc;
        int valueDevice = [[UIDevice currentDevice] resolution];
        if (valueDevice == 3) {
            vc = [[GPLProjectDetailViewController alloc]            initWithNibName:@"GPLProjectDetailViewController5" bundle:nil];
        } else {
            vc = [[GPLProjectDetailViewController alloc]            initWithNibName:@"GPLProjectDetailViewController" bundle:nil];
        }
        vc.portID = info.projectID;
        vc.portNm = info.name;
        if ([_nowType isEqualToString:@"泵站"]) {
            vc.portStatus = info.height;
        } else {
            vc.portStatus = info.status;
        }
        vc.portType = self.nowType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
