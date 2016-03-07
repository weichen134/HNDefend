//
//  NewTyphoonController.m
//  navag
//
//  Created by DY LOU on 10-7-22.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "NewTyphoonController.h"
#import "FileManager.h"
#import "WebServices.h"
#import "typhoonXMLParser.h"
#import "YearListController.h"
#import "TyphoonPathListOldController.h"
#import "CSMapRouteLayerView.h"
#import "TyphoonNousController.h"
#import "TyphoonPathListController.h"
#import "UIDevice+Resolutions.h"

@implementation POI 

@synthesize coordinate, subtitle, title, type;

- (id) initWithCoords:(CLLocationCoordinate2D) coords{
	self = [super init];
	
	if(self != nil){
		coordinate = coords;
	}
	
	return self;
}
@end

//////////////////////////////////////////////////////////

@implementation DrawPoint
@synthesize tfID,RQSJ2,JD,WD,QY,FS,FL,movesd,R7,R10,TT;
+(id)drawpoint{
	return [[self alloc] init];
}

@end

//////////////////////////////////////////////////////////

@implementation TyphoonsPoints
@synthesize routePoints,zgybPoints,xgybPoints,twybPoints,rbybPoints;
+(id)typhoonspoints{
	return [[self alloc] init];
}


@end

//////////////////////////////////////////////////////////

static NewTyphoonController *me=nil;

@implementation NewTyphoonController

@synthesize mapbg,myHistory,myZoomOut,myList,myRefresh,routeView;
@synthesize TFNewlyPath, TFPaths,TFNewList,TFYBZGList,TFYBTWList,TFYBXGList,TFYBMGList,TFYBRBList, gtfName, gtfYear,iTest;
@synthesize PointsList, PointsRoute, PointsZG, PointsXG, PointsTW, PointsRB, PointsArray;
@synthesize whichSheet, isCurrentTyphoon,myActivity,notFromSearch;

+(id)sharedController{
	return me;
}

-(IBAction)nousgo{
	UIViewController *targetViewController;
	targetViewController=[[TyphoonNousController alloc] initWithNibName:@"RainNous" bundle:nil];
	if(targetViewController!=nil){
		targetViewController.navigationItem.title=@"台风等级划分标准";
		[[self navigationController] pushViewController:targetViewController animated:YES];
	}
}
-(void)createNousbuttont{
	UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"小常识" style:UIBarButtonItemStyleBordered target:self action:@selector(nousgo)];
	self.navigationItem.rightBarButtonItem = right;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFromKey:(BOOL)key {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		me = self;
		self.TFPaths = [NSMutableArray array];
		self.TFNewList = [NSMutableArray array];
		self.TFYBZGList = [NSMutableArray array];
		self.TFYBTWList = [NSMutableArray array];
		self.TFYBXGList = [NSMutableArray array];
		self.TFYBMGList = [NSMutableArray array];
		self.TFYBRBList = [NSMutableArray array];
		self.PointsList = [NSMutableArray array];
		self.PointsRoute = [NSMutableArray array];
		self.PointsZG = [NSMutableArray array];
		self.PointsXG = [NSMutableArray array];
		self.PointsTW = [NSMutableArray array];
		self.PointsRB = [NSMutableArray array];
		self.PointsArray = [NSMutableArray array];
		self.gtfName = @"";
		myList.enabled=NO;
		isCurrentTyphoon = YES;
        self.notFromSearch = key;
		
		[TFNewList removeAllObjects];
		//add WebView
		UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 36)];
		[web setOpaque:NO];
		web.tag=1;
		[self.view addSubview:web];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    
	MKCoordinateRegion theRegion;
	
	//set region center
	CLLocationCoordinate2D theCenter;
	theCenter.latitude = 23.332054;
	theCenter.longitude = 126.229266;
	theRegion.center = theCenter;
	
	//set zoom level
	MKCoordinateSpan theSpan;
	theSpan.latitudeDelta = 20;
	theSpan.longitudeDelta = 20;
	theRegion.span = theSpan;
	
	//set scroll and zoom action
	mapbg.scrollEnabled = YES;
	mapbg.zoomEnabled = YES;
	
	//set map Region
	[mapbg setRegion:theRegion];
	[mapbg regionThatFits:theRegion];
	
	//Background
	self.myActivity.hidden = NO;
	[self.myActivity startAnimating];
	
    if(notFromSearch)
        [NSThread detachNewThreadSelector:@selector(backgroundFetchUpData) toTarget:self withObject:nil];
}

-(void)backgroundFetchUpData{
	
    NSString *baseURL = @"http://pda.zjwater.gov.cn/DataCenterService/DataService.asmx/";
	NSURL *countURL=[WebServices getRestUrl:baseURL Function:@"TyhoonActivity" Parameter:@""];
	//parse XML
	typhoonNewXMLParser *paser=[[typhoonNewXMLParser alloc] init];
	[paser parseXMLFileAtURL:countURL parseError:nil];

    //调试模拟台风
    //[self getSimulator];
    
	if([TFNewList count] > 0){
		// show typhoon info
		self.iTest = [NSMutableString stringWithString:@"当前有台风 - "];
		
		TFList *tf=[TFNewList objectAtIndex:[TFNewList count]-1];
		[iTest appendString:tf.cNAME];
		
		for(int i=[TFNewList count]-2; i>=0; i--)
		{
			tf=[TFNewList objectAtIndex:i];
			[self.iTest appendString:@", "];
			[self.iTest appendString:tf.cNAME];
		}
		
		[self.iTest appendString: @" (请点击［当前台风］刷新数据)"];
		
		myRefresh.enabled = YES;
		myList.enabled = YES;
	}
	else
	{
		self.iTest = [NSMutableString stringWithString:@"当前西太平洋上无台风"];
		myRefresh.enabled = NO;
		myList.enabled = NO;
	}
	
	[self performSelectorOnMainThread:@selector(showThingsOnMap) withObject:nil waitUntilDone:YES];

}

-(void)showThingsOnMap{	
	[self DrawNewlyTyphoon:TFNewList isCurrent:YES];
	
	
	UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 36)];
	[web setOpaque:NO];
	web.tag=1;
	[web loadHTMLString:[[NSString alloc] initWithFormat:@"<html><head><style>body{background-color:transparent;front-size:10px;font-weight:bold}</style></head><body><marquee scrollamount=2><font color=\"#FFFFFF\">%@</font></marquee></body></html>", self.iTest] baseURL:nil];
	[self.view addSubview:web];


	
	if([TFNewList count] > 0){
		myRefresh.enabled = YES;
		myList.enabled = YES;
	}else{
		myRefresh.enabled = NO;
		myList.enabled = NO;
	}
}


/*
 Implement loadView if you want to create a view hierarchy programmatically
 - (void)loadView {
 }
 */

//XML解析，获取台风路径信息
- (void)getTFPath:(TFPathInfo *)tfp{
	[TFPaths addObject:tfp];
}

-(void)getSimulator
{
    TFList *tf = [[TFList alloc] init];
    tf.tfID = @"201302";
    tf.NAME = @"S1";
    tf.cNAME = @"模拟1";
    [TFNewList addObject:tf];
    TFList *tf2 = [[TFList alloc] init];
    tf2.tfID = @"201303";
    tf2.NAME = @"S2";
    tf2.cNAME = @"模拟2";
    [TFNewList addObject:tf2];
//    TFList *tf3 = [[TFList alloc] init];
//    tf3.tfID = @"201301";
//    tf3.NAME = @"S3";
//    tf3.cNAME = @"模拟3";
//    [TFNewList addObject:tf3];
}

//XML解析，获取最新台风路径信息
- (void)getNewTF:(TFList *)tf{
	[TFNewList addObject:tf];
}

//XML解析，获取台风预报路径信息
-(void)getTFYB:(TFYBList *)ybtf{
	NSString *strTM = [ybtf.TM substringToIndex:2];
	if([strTM compare:@"中国"] == NSOrderedSame){
		[TFYBZGList addObject:ybtf];
	}else if([strTM compare:@"台湾"] == NSOrderedSame){
		[TFYBTWList addObject:ybtf];
	}else if([strTM compare:@"香港"] == NSOrderedSame){
		[TFYBXGList addObject:ybtf];
	}else if([strTM compare:@"日本"] == NSOrderedSame){
		[TFYBRBList addObject:ybtf];
	}
} 

//更改地图类型（命名有误）
-(IBAction)zoomOutMap:(id)sender{
	whichSheet = 1;
	UIActionSheet *options = [[UIActionSheet alloc]
							  initWithTitle:@"请选择地图类型" 
							  delegate:self
							  cancelButtonTitle:@"取消"
							  destructiveButtonTitle:nil
							  otherButtonTitles:@"标准地图",@"卫星地图",@"混合地图",nil];
	[options showInView:self.view];
}

//转到历史台风
-(IBAction)goHistory:(id)sender{
	YearListController *targetViewController;
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice == 3)
    {
        targetViewController=[[YearListController alloc] initWithNibName:@"YearList5" bundle:nil];
    } else {
        targetViewController=[[YearListController alloc] initWithNibName:@"YearList" bundle:nil];
    }
	if(targetViewController!=nil){
		targetViewController.navigationItem.title=@"选择年份";
		[[self navigationController] pushViewController:targetViewController animated:YES];
	}
}

-(IBAction)backToTop:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

//转到当前台风数据列表
-(IBAction)goList:(id)sender{
	if([TFNewList count] >=  1 && isCurrentTyphoon)
	{
        //在这里初始化显示第一个台风的信息，但是传入的信息是多个台风的数据的
        int length = [PointsArray count];
        NSMutableArray *routeArray = [NSMutableArray array];
        //获取历史路径
        for (int i = 0; i < length; i ++) {
            TyphoonsPoints * typhoonPoints = [PointsArray objectAtIndex:i];
            [routeArray addObject:typhoonPoints.routePoints];
        }
        TyphoonPathListController *targetViewController;
        int valueDevice = [[UIDevice currentDevice] resolution];
        if (valueDevice == 3)
        {
        targetViewController=[[TyphoonPathListController alloc] initWithNibName:@"TyphoonPathList5" bundle:nil withTyphoonInfoArray:TFNewList historyArray:routeArray];
        } else {
        targetViewController=[[TyphoonPathListController alloc] initWithNibName:@"TyphoonPathList" bundle:nil withTyphoonInfoArray:TFNewList historyArray:routeArray];
        }
        if(targetViewController!=nil){
            targetViewController.navigationItem.title= [NSString stringWithFormat:@"%@", gtfName];
            [[self navigationController] pushViewController:targetViewController animated:YES];
        }
	}
	else
	{
        //历史台风
		TyphoonPathListOldController *targetViewController;
        int valueDevice = [[UIDevice currentDevice] resolution];
        if (valueDevice == 3)
        {
            targetViewController=[[TyphoonPathListOldController alloc] initWithNibName:@"TyphoonPathListOldController5" bundle:nil withList:TFPaths];
        } else {
            targetViewController=[[TyphoonPathListOldController alloc] initWithNibName:@"TyphoonPathListOldController" bundle:nil withList:TFPaths];
        }
		if(targetViewController!=nil){
			targetViewController.navigationItem.title= [NSString stringWithFormat:@"路径●%@", gtfName];
			[[self navigationController] pushViewController:targetViewController animated:YES];
		}
	}
}

//刷新台风
-(IBAction)mapRefresh:(id)sender{
	self.myActivity.hidden = NO;
	[self.myActivity startAnimating];
	[self performSelector:@selector(forWatting) withObject:nil afterDelay:0.1];
}

-(void)forWatting{
	[self DrawNewlyTyphoon:TFNewList isCurrent:YES];
	self.myActivity.hidden = YES;
	[self.myActivity stopAnimating];
}

//画最新台风
-(void)DrawNewlyTyphoon:(NSArray *)TFLists isCurrent:(BOOL)current{	
	[PointsArray removeAllObjects];
	
	myList.enabled = YES;
	
	if(routeView != nil)
		[self.routeView removeFromSuperview];
	
	self.isCurrentTyphoon = current;
	
	NSMutableString *mulName = [[NSMutableString alloc] initWithString:@"台风"];
	for(int i=0; i<[TFLists count]; i++)
	{
		TFList *tf=[TFLists objectAtIndex:i];
		[self initTyphoons:tf.tfID withName:tf.cNAME];
		
		if(i==0)
		{
			[mulName appendFormat:@"●%@", tf.cNAME];
			gtfName = tf.cNAME;
			
			TFNewlyPath = [TFPathInfo tfpathinfo];
			TFNewlyPath = [TFPaths objectAtIndex:([TFPaths count]-1)];
		}
		else
		{
			[mulName appendFormat:@", %@", tf.cNAME];
		}
	}
	//change title
	self.navigationItem.title=[NSString stringWithFormat:@"%@", mulName];
	
	if([TFLists count] > 0)
	{
		// draw typhoon
		routeView = [[CSMapRouteLayerView alloc] initWithRoute:PointsArray mapView:mapbg lineColor:nil];
	}
	
    //如果是实时台风的话，就不出详细东西的滚动条
    if (isCurrentTyphoon == false) {
        TFPathInfo *tf = TFNewlyPath;
        // show typhoon info
        NSString *iTestB;
        iTestB = [[NSString alloc] initWithFormat:@"<font color=\"#FFAAAA\">%@</font> 时间:<font color=\"#FFAAAA\">%@</font> 北纬:<font color=\"#FFAAAA\">%@</font> 东经:<font color=\"#FFAAAA\">%@</font> 中心气压:<font color=\"#FFAAAA\">%@百帕</font> 最大风速:<font color=\"#FFAAAA\">%@米/秒</font> 风力:<font color=\"#FFAAAA\">%@级</font> 移动速度:<font color=\"#FFAAAA\">%@公里/时</font> 移动方向:<font color=\"#FFAAAA\">%@</font> 7级风圈半径:<font color=\"#FFAAAA\">%@公里</font> 10级风圈半径:<font color=\"#FFAAAA\">%@公里</font>",gtfName, tf.RQSJ2, tf.WD, tf.JD, tf.QY, tf.FS, tf.FL, tf.movesd, tf.movefx, (tf.radius7==@"0")?@"--":tf.radius7, ([tf.radius10 compare:@"0"]==NSOrderedSame)?@"--":tf.radius10];
        UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 36)];
        //web.backgroundColor = [UIColor clearColor];
        [web setOpaque:NO];
        [web loadHTMLString:[[NSString alloc] initWithFormat:@"<html><head><style>body{background-color:transparent;front-size:10px;font-weight:bold}</style></head><body><marquee scrollamount=2><font color=\"#FFFFFF\">%@</font></marquee></body></html>", iTestB] baseURL:nil];
        web.tag=1;
        [self.view addSubview:web];
    } else {
        NSString *finalStr = [NSString stringWithFormat:@"当前有%@ (请点击［当前台风］刷新数据)",mulName];
        NSString *finalString = [finalStr stringByReplacingOccurrencesOfString:@"●" withString:@"-"];
        UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 36)];
        [web setOpaque:NO];
        web.tag=1;
        [web loadHTMLString:[[NSString alloc] initWithFormat:@"<html><head><style>body{background-color:transparent;front-size:10px;font-weight:bold}</style></head><body><marquee scrollamount=2><font color=\"#FFFFFF\">%@</font></marquee></body></html>", finalString] baseURL:nil];
        [self.view addSubview:web];
    }

	myList.enabled = YES;
	
	self.myActivity.hidden = YES;
	[self.myActivity stopAnimating];
}

-(void)initTyphoons:(NSString *)mYear withName:(NSString *)tfName{		
	// Clear the objects
	[TFPaths removeAllObjects];
	[TFYBZGList removeAllObjects];
	[TFYBTWList removeAllObjects];
	[TFYBXGList removeAllObjects];
	[TFYBRBList removeAllObjects];
	
	
    NSString *baseURL= @"http://pda.zjwater.gov.cn/DataCenterService/DataService.asmx/";
	// Get Typhoon History Path List
	NSString *convertV1 = [NSString stringWithFormat:@"%@",mYear];
	NSURL *countURL=[WebServices getRestUrl:baseURL Function:@"TyphoonHistoryTracks" Parameter:convertV1];
	
	//parse XML
	typhoonXMLParser *paser=[[typhoonXMLParser alloc] init];
	[paser parseXMLFileAtURL:countURL parseError:nil];		
	
	// Get Typhoon yubao Path List
	NSString *convertV2 = [NSString stringWithFormat:@"%@",mYear];
	NSURL *countURL2=[WebServices getRestUrl:baseURL Function:@"TyphoonForecastTracks" Parameter:convertV2];
	
	//parse XML
	typhoonYBXMLParser *paser2=[[typhoonYBXMLParser alloc] init];
	[paser2 parseXMLFileAtURL:countURL2 parseError:nil];		
	
	
	// add the data
	[self addAllPoints:TFPaths];
	[self addAllYBPoints:TFYBZGList withXG:TFYBXGList withTW:TFYBTWList withRB:TFYBRBList];
	
	TyphoonsPoints *tp = [TyphoonsPoints typhoonspoints];
	tp.routePoints = PointsList;
	tp.zgybPoints = PointsZG;
	tp.xgybPoints = PointsXG;
	tp.twybPoints = PointsTW;
	tp.rbybPoints = PointsRB;
	[PointsArray addObject:tp];
}

-(void)drawTyphoon:(NSString *)mYear withName:(NSString *)tfName{
	if(routeView != nil)
		[self.routeView removeFromSuperview];
	
	[TFPaths removeAllObjects];
	
	
    NSString *baseURL= @"http://pda.zjwater.gov.cn/DataCenterService/DataService.asmx/";
	NSString *convertV3 = [NSString stringWithFormat:@"%@",mYear];
	NSURL *countURL=[WebServices getRestUrl:baseURL Function:@"TyphoonHistoryTracks" Parameter:convertV3];
	
	//parse XML
	typhoonXMLParser *paser=[[typhoonXMLParser alloc] init];
	[paser parseXMLFileAtURL:countURL parseError:nil];		
	
	////////////////
	[TFYBZGList removeAllObjects];
	[TFYBTWList removeAllObjects];
	[TFYBXGList removeAllObjects];
	[TFYBRBList removeAllObjects];
	NSString *convertV4 = [NSString stringWithFormat:@"%@",mYear];
	NSURL *countURL2=[WebServices getRestUrl:baseURL Function:@"TyphoonForecastTracks" Parameter:convertV4];
	
	//parse XML
	typhoonYBXMLParser *paser2=[[typhoonYBXMLParser alloc] init];
	[paser2 parseXMLFileAtURL:countURL2 parseError:nil];		
	
	
	//change title
	gtfName = tfName;
	self.navigationItem.title=[NSString stringWithFormat:@"台风路径●%@", gtfName];
	
	// draw typhoon
	TFPathInfo *tf = [TFPaths objectAtIndex:([TFPaths count]-1)];
	
	[self addAllPoints:TFPaths];
	[self addAllYBPoints:TFYBZGList withXG:TFYBXGList withTW:TFYBTWList withRB:TFYBRBList];
	routeView = [[CSMapRouteLayerView alloc] initWithRoute:PointsArray mapView:mapbg lineColor:nil];
	
	// show typhoon info
	NSString *iTestB;
	iTestB = [[NSString alloc] initWithFormat:@"时间:<font color=\"#FFAAAA\">%@</font> 北纬:<font color=\"#FFAAAA\">%@</font> 东经:<font color=\"#FFAAAA\">%@</font> 中心气压:<font color=\"#FFAAAA\">%@百帕</font> 最大风速:<font color=\"#FFAAAA\">%@米/秒</font> 风力:<font color=\"#FFAAAA\">%@级</font> 移动速度:<font color=\"#FFAAAA\">%@公里/时</font> 移动方向:<font color=\"#FFAAAA\">%@</font> 7级风圈半径:<font color=\"#FFAAAA\">%@公里</font> 10级风圈半径:<font color=\"#FFAAAA\">%@公里</font>", tf.RQSJ2, tf.WD, tf.JD, tf.QY, tf.FS, tf.FL, tf.movesd, tf.movefx, (tf.radius7==@"0")?@"--":tf.radius7, ([tf.radius10 compare:@"0"]==NSOrderedSame)?@"--":tf.radius10];
	UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 36)];
	//web.backgroundColor = [UIColor clearColor];
	[web setOpaque:NO];
	[web loadHTMLString:[[NSString alloc] initWithFormat:@"<html><head><style>body{background-color:transparent;front-size:10px;font-weight:bold}</style></head><body><marquee scrollamount=2><font color=\"#FFFFFF\">%@</font></marquee></body></html>", iTestB] baseURL:nil];
	web.tag=1;
	[self.view addSubview:web];
	
	myList.enabled = YES;
	
	MKCoordinateSpan theSpan = mapbg.region.span;
	if(theSpan.latitudeDelta < 15){
	//set zoom level
	MKCoordinateRegion theRegion;
	CLLocationCoordinate2D theCenter;
	theCenter.latitude = [tf.WD doubleValue];
	theCenter.longitude = [tf.JD doubleValue];
	theRegion.center = theCenter;
	
	
	theSpan.latitudeDelta = 15;
	theSpan.longitudeDelta = 15;
	theRegion.span = theSpan;
	
	//set map Region
	[mapbg setRegion:theRegion];
	[mapbg regionThatFits:theRegion];
	}
}

-(void) addAllPoints:(NSMutableArray *)tfPoints{
	TFPathInfo *tf;
	
	[PointsList removeAllObjects];
	
	for(int i=0; i<[tfPoints count]; i++)
	{
		tf = [tfPoints objectAtIndex:i];
		item=[DrawPoint drawpoint];
		item.tfID = tf.tfID;
		item.RQSJ2 = tf.RQSJ2;
		item.JD = tf.JD;
		item.WD = tf.WD;
		item.QY = tf.QY;
		item.FS = tf.FS;
		item.FL = tf.FL;
        item.movesd = tf.movesd;
		item.R7 = tf.radius7;
		item.R10 = tf.radius10;
		item.TT = tf.type;
		[PointsList addObject:item];
		//[self createMapPoint:mapbg coordinateX:[tf.WD doubleValue] coordinateY:[tf.JD doubleValue] Type:tf.type Title:tf.RQSJ2 Subtitle:tf.type];
	}
}

-(void) addAllYBPoints:(NSMutableArray *)ZG withXG:(NSMutableArray *)XG withTW:(NSMutableArray *)TW withRB:(NSMutableArray *)RB{
	TFYBList *tf;
	
	[PointsZG removeAllObjects];
	for(int i=0; i<[ZG count]; i++)
	{
		tf = [ZG objectAtIndex:i];
		item=[DrawPoint drawpoint];
		item.tfID = tf.tfID;
		item.RQSJ2 = tf.RQSJ2;
		item.JD = tf.jd;
		item.WD = tf.wd;
		item.QY = tf.QY;
		item.FS = tf.FS;
		item.FL = tf.FL;
		item.TT = @"";
		[PointsZG addObject:item];
		//[self createMapPoint:mapbg coordinateX:[tf.wd doubleValue] coordinateY:[tf.jd doubleValue] Type:nil Title:tf.RQSJ2 Subtitle:nil];
	}
	
	[PointsXG removeAllObjects];
	for(int i=0; i<[XG count]; i++)
	{
		tf = [XG objectAtIndex:i];
		item=[DrawPoint drawpoint];
		item.tfID = tf.tfID;
		item.RQSJ2 = tf.RQSJ2;
		item.JD = tf.jd;
		item.WD = tf.wd;
		item.QY = tf.QY;
		item.FS = tf.FS;
		item.FL = tf.FL;
		item.TT = @"";
		[PointsXG addObject:item];
		//[self createMapPoint:mapbg coordinateX:[tf.wd doubleValue] coordinateY:[tf.jd doubleValue] Type:nil Title:tf.RQSJ2 Subtitle:nil];
	}
	
	[PointsTW removeAllObjects];
	for(int i=0; i<[TW count]; i++)
	{
		tf = [TW objectAtIndex:i];
		item=[DrawPoint drawpoint];
		item.tfID = tf.tfID;
		item.RQSJ2 = tf.RQSJ2;
		item.JD = tf.jd;
		item.WD = tf.wd;
		item.QY = tf.QY;
		item.FS = tf.FS;
		item.FL = tf.FL;
		item.TT = @"";
		[PointsTW addObject:item];
		//[self createMapPoint:mapbg coordinateX:[tf.wd doubleValue] coordinateY:[tf.jd doubleValue] Type:nil Title:tf.RQSJ2 Subtitle:nil];
	}
	
	[PointsRB removeAllObjects];
	for(int i=0; i<[RB count]; i++)
	{
		tf = [RB objectAtIndex:i];
		item=[DrawPoint drawpoint];
		item.tfID = tf.tfID;
		item.RQSJ2 = tf.RQSJ2;
		item.JD = tf.jd;
		item.WD = tf.wd;
		item.QY = tf.QY;
		item.FS = tf.FS;
		item.FL = tf.FL;
		item.TT = @"";
		[PointsRB addObject:item];
		//[self createMapPoint:mapbg coordinateX:[tf.wd doubleValue] coordinateY:[tf.jd doubleValue] Type:nil Title:tf.RQSJ2 Subtitle:nil];
	}
}

-(void *) createMapPoint:(MKMapView *) mapView coordinateX:(double)coorX coordinateY:(double)coorY Type:(NSString *)type Title:(NSString *)title Subtitle:(NSString *)subtitle{
	if(mapView != nil){
		// set the POI lat and lng
		CLLocationCoordinate2D p1;
		POI *poi;
		
		if(coorX && coorY){
			p1.latitude = coorX;
			p1.longitude = coorY;
			poi = [[POI alloc] initWithCoords:p1];
			
			if(title != NULL)
				poi.title = title;
			
			if(subtitle != NULL)
				poi.subtitle = subtitle;
			
			if(type != NULL)
				poi.type = type;
			else
				poi.type = @"utf.gif";
			
			[mapView addAnnotation:poi];
		}
	}
	return NULL;
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKAnnotationView *newAnnotation = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
	POI *poi = (POI *)annotation;
	//NSString *symbol=[[NSString alloc] initWithString:@"utf.gif"];
	NSString *symbol=@"utf.gif";
	if([poi.type compare:@"热带低气压"] == NSOrderedSame){
		symbol=@"td.gif";
	}else if([poi.type compare:@"热带风暴"] == NSOrderedSame){
		symbol=@"min_blue.gif";
	}else if([poi.type compare:@"强热带风暴"] == NSOrderedSame){
		symbol=@"ts.gif";
	}else if([poi.type compare:@"台风"] == NSOrderedSame){
		symbol=@"min_yellow.gif";
	}else if([poi.type compare:@"强台风"] == NSOrderedSame){
		symbol=@"sts.gif";
	}else if([poi.type compare:@"超强台风"] == NSOrderedSame){
		symbol=@"tf.gif";
	}else{
		symbol=@"utf.gif";
	}
	newAnnotation.image = [UIImage imageNamed:symbol];
	newAnnotation.canShowCallout = YES;
	return newAnnotation;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if (buttonIndex != [actionSheet cancelButtonIndex])
	{
		if(whichSheet == 1)
		{
			switch(buttonIndex)
			{
				case 0:
					mapbg.mapType = MKMapTypeStandard;
					break;
				case 1:
					mapbg.mapType = MKMapTypeSatellite;
					break;
				case 2:
					mapbg.mapType = MKMapTypeHybrid;
					break;
				default:
					break;
		}
		}
		else
		{
			TyphoonsPoints * typhoonPoints = [PointsArray objectAtIndex:buttonIndex];
			
			TFList *tf=[TFNewList objectAtIndex:buttonIndex];
			gtfName = tf.cNAME;
			
			//TyphoonPathListController *targetViewController =[[TyphoonPathListController alloc] initWithNibName:@"TyphoonPathList" bundle:nil withList:typhoonPoints.routePoints];
            
            TyphoonPathListController *targetViewController;
            int valueDevice = [[UIDevice currentDevice] resolution];
            if (valueDevice == 3)
            {
                targetViewController = [[TyphoonPathListController alloc] initWithNibName:@"TyphoonPathList5" bundle:nil withTyphoonInfoArray:typhoonPoints historyArray:typhoonPoints.routePoints];
            } else {
                    targetViewController = [[TyphoonPathListController alloc] initWithNibName:@"TyphoonPathList" bundle:nil withTyphoonInfoArray:typhoonPoints historyArray:typhoonPoints.routePoints];            }
            
			if(targetViewController!=nil){
				targetViewController.navigationItem.title= [NSString stringWithFormat:@"%@", gtfName];
				[[self navigationController] pushViewController:targetViewController animated:YES];
			}
			
		}
	}
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end
