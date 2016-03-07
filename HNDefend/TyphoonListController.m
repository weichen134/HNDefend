//
//  TyphoonList.m
//  navag
//
//  Created by DY LOU on 10-6-23.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "TyphoonListController.h"
#import "MyTableCell.h"
#import "typhoonXMLParser.h"
#import "WebServices.h"
#import "FileManager.h"
#import "NewTyphoonController.h"

static TyphoonListController *me=nil;
@implementation TyphoonListController
@synthesize hiscTyphoon, currentYear;

+(id)sharedController{
	return me;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withYear:iYear {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code		
		self.hiscTyphoon =[NSMutableArray array];
		me = self;
		currentYear=iYear;
		
		
        NSString *baseURL= @"http://pda.zjwater.gov.cn/DataCenterService/DataService.asmx/";
		NSString *converV  = [NSString stringWithFormat:@"%@",currentYear];
		NSURL *countURL=[WebServices getRestUrl:baseURL Function:@"TyphoonList" Parameter:converV];
		
		//parse XML
		typhoonListXMLParser *paser=[[typhoonListXMLParser alloc] init];
		[paser parseXMLFileAtURL:countURL parseError:nil];		
		
	}
	return self;
}

- (void)getTFList:(TFList *)tf{
	[hiscTyphoon addObject:tf];
}

-(IBAction)backToTop:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
}
 */


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
    return 35.0; //returns floating point which will be used for a cell row height at specified row index  
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [hiscTyphoon count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
	MyTableCell *cell = (MyTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil){
		cell = [[MyTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
		
		TFList * tf=[hiscTyphoon objectAtIndex:indexPath.row];
		
		//add Column
		UILabel *labID = [[UILabel	alloc] initWithFrame:CGRectMake(10.0, 0, 80.0, 
																	tableView.rowHeight)]; 
		labID.tag = 1; 
		labID.font = [UIFont systemFontOfSize:16.0]; 
		labID.text = tf.tfID;
        labID.backgroundColor = [UIColor clearColor];
		labID.textAlignment = UITextAlignmentLeft;
		labID.textColor = [UIColor blackColor]; 
		labID.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:labID];
		
		//add Column
		UILabel *labcName = [[UILabel	alloc] initWithFrame:CGRectMake(90.0, 0, 85.0, 
																	tableView.rowHeight)]; 
		labcName.tag = 2; 
		labcName.font = [UIFont systemFontOfSize:16.0]; 
		labcName.text = tf.cNAME;
        labcName.backgroundColor = [UIColor clearColor];
		labcName.textAlignment = UITextAlignmentLeft;
		labcName.textColor = [UIColor blackColor]; 
		labcName.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:labcName];
		
		//add Column
		UILabel *labName = [[UILabel	alloc] initWithFrame:CGRectMake(180.0, 0, 105, 
																		tableView.rowHeight)]; 
		labName.tag = 3; 
		labName.font = [UIFont systemFontOfSize:16.0]; 
		labName.text = tf.NAME;
        labName.backgroundColor = [UIColor clearColor];
		labName.textAlignment = UITextAlignmentLeft;
		labName.textColor = [UIColor blackColor]; 
		labName.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:labName];
	}
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//change look
	[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:parserSelection inSection:0]].accessoryType = UITableViewCellAccessoryNone;
	parserSelection = indexPath.row;
	[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];		
	//goto next
	NSUInteger row = indexPath.row;
    if (row != NSNotFound) {
		NSArray *controllers=[self navigationController].viewControllers;
		UIViewController *targetController=(UIViewController *)[controllers objectAtIndex:[controllers count]-3];
		TFList * tf=[hiscTyphoon objectAtIndex:indexPath.row];
		NSMutableArray *drawList = [NSMutableArray array];
		[drawList addObject:tf];
		[(NewTyphoonController *)targetController DrawNewlyTyphoon:drawList isCurrent:NO];
		[[self navigationController] popToViewController:targetController animated:YES];
	}
}
@end
