//
//  TyphoonPathListController.m
//  navag
//
//  Created by DY LOU on 10-6-26.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "TyphoonPathListController.h"
#import "MyTableCell.h"
#import "typhoonXMLParser.h"
#import "NewTyphoonController.h"
#import "GPLGlobalDistance.h"


@implementation TyphoonPathListController

@synthesize infoArray,hisArray,myTableArray,myIndex;
@synthesize myTable, mySeg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withList:(NSMutableArray *)tfList {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	}
	return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTyphoonInfoArray:(NSMutableArray *)temInfoArray historyArray:(NSMutableArray *)temHisArray;
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        infoArray = temInfoArray ;//为什么不能用copy呢？
        hisArray =  temHisArray;
        myTableArray = [[NSMutableArray alloc] init];
        myIndex = 0;
    }
    return self;
}

-(IBAction)backToTop:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

 // If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
    //这里反正看到的都是那个肯定是当前台风，加入标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(230, 26, 80, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    label.text = @"";
    label.tag = 20126;
    label.hidden = YES;
    [self.navigationController.view addSubview:label];
    
    //initial the seg array
	NSMutableArray *mySegArray = [NSMutableArray array];
	for (int i = 0; i<[self.infoArray count]; i++) {
		TFList *list = [self.infoArray objectAtIndex:i];
		NSString *tyNM = list.cNAME;
		if ([tyNM length]==0) {
			tyNM = @"未命名";
		}
		[mySegArray addObject:tyNM];
	}
	mySeg = [[UISegmentedControl alloc] initWithItems:mySegArray];
    mySeg.tintColor = [UIColor colorWithRed:74/255.0 green:178/255.0 blue:227/255.0 alpha:1.0];
	mySeg.frame = CGRectMake(0, 385+44, 320, 31);
	if ([mySegArray count]>1) {
		mySeg.selectedSegmentIndex = 0;
	}else {
		mySeg.userInteractionEnabled = NO;
	}
    
	[mySeg addTarget:self action:@selector(changeTheSegOfTyphoon) forControlEvents:UIControlEventValueChanged];
	mySeg.segmentedControlStyle = UISegmentedControlStyleBar;
	[self.view addSubview:mySeg];
	
	//UITableView
	CGRect myTableFrame = CGRectMake(0, 0+44+25, 320, 360);
	if ([infoArray count]<2) {
		myTableFrame.size.height +=31;
	}
	[self.myTable setFrame:myTableFrame];
	[self.view addSubview:myTable];
	
	//init data
	[self changeTheSegOfTyphoon];
}

-(void)viewWillDisappear:(BOOL)animated
{
    UILabel *label = (UILabel *)[self.navigationController.view viewWithTag:20126];
    if (label.superview != nil) {
        [label removeFromSuperview];
    }
}

-(void)changeTheSegOfTyphoon{
	//the selectedIndex
	myIndex = mySeg.selectedSegmentIndex;
	if (myIndex<0) {
		myIndex = 0;
	}
    
    //海宁经纬度 120.69	30.53
    NSString *lat1 = @"30.53";
    NSString *lng1 = @"120.69";
    
    UILabel *label = (UILabel *)[self.navigationController.view viewWithTag:20126];
	//Set Title
	TFList *myList = [self.infoArray objectAtIndex:myIndex];
	NSString *tyCNM = myList.cNAME;
	NSString *tyNM = myList.tfID;
	//judge the chinese name
	if ([tyCNM length]==0||[tyCNM isEqualToString:@"未命名"]==YES) {
		tyCNM = @"未命名";
	}
	//judge the english name
	if ([tyNM length]==0||[tyNM isEqualToString:@"NAMELESS"]==YES) {
		tyNM = @"NAMELESS";
	}
	
	self.navigationItem.title = [NSString stringWithFormat:@"%@(%@)",tyCNM,tyNM];
    
	//Not a terrible bug as I think ,breath, It' OK here!!!
	if ([self.hisArray count]>0) {
		self.myTableArray = [self.hisArray objectAtIndex:myIndex];
	}
	
	//SetSubTitle
	if ([self.myTableArray count]>0) {
		DrawPoint *myPathInfo = [self.myTableArray objectAtIndex:[self.myTableArray count]-1];
        //台风类型
		NSString *tyType = myPathInfo.TT;
        //台风经度
        NSString *lng2 = myPathInfo.JD;
        //台风纬度
        NSString *lat2 = myPathInfo.WD;
        //diliberately set out to write the typhoon type name as white color
        if ([tyType isEqualToString:@"热带低压"]||[tyType isEqualToString:@"热带低气压"]) {
			label.textColor  = [UIColor whiteColor];
			tyType = @"热带低压";
		} else if ([tyType isEqualToString:@"热带风暴"]) {
			label.textColor  = [UIColor whiteColor];
		}  else if ([tyType isEqualToString:@"强热带风暴"]) {
			label.textColor  = [UIColor whiteColor];
		} else if ([tyType isEqualToString:@"台风"]) {
			label.textColor  = [UIColor whiteColor];
		} else if ([tyType isEqualToString:@"强台风"]) {
			label.textColor  = [UIColor whiteColor];
		} else if ([tyType isEqualToString:@"超强台风"]) {
			label.textColor  = [UIColor whiteColor];
		} else {
			label.textColor  = [UIColor whiteColor];
			tyType = @"";
		}
		label.text = tyType;
        //台风等级
        _typhoonLevel.text = tyType;
        //台风距离
        _typhoonDistance.text = [NSString stringWithFormat:@"%.2f公里",[GPLGlobalDistance getDistanceBeginLat:lat1 BeginLng:lng2 EndLat:lat2 EndLng:lng2]];
	}else {
		//if there is no historyPathInfo , set it empty!
		label.text = @"";
        //台风等级
        _typhoonLevel.text = @"--";
        //台风距离
        _typhoonDistance.text = @"--";
	}
	//Reload TableView
	[self.myTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    return 32.0; //returns floating point which will be used for a cell row height at specified row index  
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [myTableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i %d", indexPath.row,myIndex];
	MyTableCell *cell = (MyTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil){
		cell = [[MyTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
		
		TFPathInfo * tfinfo=[myTableArray objectAtIndex:([myTableArray count] - indexPath.row - 1)];
		
		//add Column
		UILabel *labSJ = [[UILabel	alloc] initWithFrame:CGRectMake(10.0, 6, 90.0, 30)]; 
		labSJ.tag = 1; 
		labSJ.font = [UIFont systemFontOfSize:13.0]; 
        if ([tfinfo.RQSJ2 intValue]==0||[tfinfo.RQSJ2 isEqualToString:@""]==YES) {
			labSJ.text = @"无时间信息";
		} else {
			labSJ.text = tfinfo.RQSJ2;
		}	
		labSJ.textAlignment = UITextAlignmentLeft; 
		labSJ.textColor = [UIColor blueColor]; 
		labSJ.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:labSJ];
		
		//add Column
		UILabel *labFL = [[UILabel	alloc] initWithFrame:CGRectMake(100.0, 6, 60.0, 30)]; 
		labFL.tag = 2; 
		labFL.font = [UIFont systemFontOfSize:13.0]; 
        if ([tfinfo.FL intValue]==0||[tfinfo.FL isEqualToString:@""]==YES) {
			labFL.text = @"风力：---";
		} else {
			labFL.text = [NSString stringWithFormat:@"风力：%@", tfinfo.FL];
		}	
        labFL.textAlignment = UITextAlignmentLeft; 
		labFL.textColor = [UIColor blackColor]; 
		labFL.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:labFL];
		
		//add Column
		UILabel *labFS = [[UILabel	alloc] initWithFrame:CGRectMake(170.0, 6, 70.0, 30)]; 
		labFS.tag = 3; 
		labFS.font = [UIFont systemFontOfSize:13.0]; 
        if ([tfinfo.movesd intValue]==0||[tfinfo.movesd isEqualToString:@""]==YES) {
			labFS.text = @"移速：---";
		} else {
			labFS.text = [NSString stringWithFormat:@"移速：%@", tfinfo.movesd];
		}
        labFS.textAlignment = UITextAlignmentLeft; 
		labFS.textColor = [UIColor blackColor]; 
		labFS.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:labFS];
		
		//add Column
		UILabel *labQY = [[UILabel	alloc] initWithFrame:CGRectMake(240.0, 6, 70.0, 30)]; 
		labQY.tag = 6; 
		labQY.font = [UIFont systemFontOfSize:13.0]; 
        if ([tfinfo.QY intValue]==0||[tfinfo.QY isEqualToString:@""]==YES) {
			labQY.text = @"气压：---";
		} else {
			labQY.text = [NSString stringWithFormat:@"气压：%@", tfinfo.QY];
		}
        labQY.textAlignment = UITextAlignmentLeft; 
		labQY.textColor = [UIColor blackColor]; 
		labQY.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:labQY];
	}
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//change look
	return;
}
@end
