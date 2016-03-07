//
//  GPLWaterDetailViewController.h
//  HNDefend
//
//  Created by GPL on 13-9-10.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLParentViewController.h"

@class GPLWaterListInfo;
@interface GPLWaterDetailViewController : GPLParentViewController<UIWebViewDelegate,UIActionSheetDelegate>
//top bar
@property(nonatomic,weak) IBOutlet UILabel *titleLabel; //顶部
@property(nonatomic,weak) IBOutlet UILabel *beginDateLabel;//开始日期
@property(nonatomic,weak) IBOutlet UILabel *endDateLabel;//结束日期
//chart
@property(nonatomic,weak) IBOutlet UILabel *mainDescLabel;//按小时统计
@property(nonatomic,weak) IBOutlet UIButton *tableBtn;
@property(nonatomic,weak) IBOutlet UIButton *chartBtn;
//webview
@property(nonatomic,strong) IBOutlet UIWebView *webView;
//tableview
@property(nonatomic,weak) IBOutlet UITableView *waterDetailList;

@property(nonatomic,weak) IBOutlet UILabel *oneDateLabel;//1
@property(nonatomic,weak) IBOutlet UILabel *twoDateLabel;//2
@property(nonatomic,weak) IBOutlet UILabel *threeDateLabel;//3
@property(nonatomic,weak) IBOutlet UILabel *fourDateLabel;//4

//params
@property(nonatomic,strong) NSString *portNm;
@property(nonatomic,strong) NSString *portClient;

@property(nonatomic,strong) NSString *selectType;
@property(nonatomic,strong) NSString *myJJV;

//fetch data
@property(nonatomic,strong) NSMutableArray *waterDetailArray;
@property(nonatomic,strong) NSString *myJSON;

//otherData 注意选择时间后需要充值为‘--’
@property(nonatomic,strong) GPLWaterListInfo *myAvg;
@property(nonatomic,strong) GPLWaterListInfo *myMin;
@property(nonatomic,strong) GPLWaterListInfo *myMax;


-(IBAction)changeType:(id)sender;
-(IBAction)selectBeginDate:(id)sender;
-(IBAction)selectEndDate:(id)sender;

-(IBAction)chooseTable:(id)sender;
-(IBAction)chooseChart:(id)sender;

-(void)fetchDatabyType:(NSString *)type;

@end
