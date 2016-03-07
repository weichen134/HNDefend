//
//  YearList.m
//  navag
//
//  Created by DY LOU on 10-6-23.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "YearListController.h"
#import "TyphoonListController.h"
#import "MyTableCell.h"
#import "UIDevice+Resolutions.h"


@implementation YearListController
@synthesize hiscYears;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code		
		//init data
		NSDate *today = [NSDate date];
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat: @"yyyy MM dd HH"]; 
		NSMutableString *startDate=[NSMutableString stringWithFormat:@"%@",[dateFormat stringFromDate: today]];
		NSArray *date = [startDate componentsSeparatedByString:@" "];
		
		self.hiscYears = [[NSMutableArray alloc] init];
		for(int i=[[date objectAtIndex:0] intValue]; i>1944; i--)
		{
			[hiscYears addObject:[NSString stringWithFormat:@"%d", i]];
		}
	}
	return self;
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

-(IBAction)backToTop:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

#pragma mark UITableView delegates and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    return 35.0; //returns floating point which will be used for a cell row height at specified row index  
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [hiscYears count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
	MyTableCell *cell = (MyTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil){
		cell = [[MyTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
		//add Column
		UILabel *label = [[UILabel	alloc] initWithFrame:CGRectMake(20.0, 0, 140.0, 
																	tableView.rowHeight)]; 
		[cell addColumn:160];
		label.tag = 1; 
		label.font = [UIFont systemFontOfSize:16.0]; 
		label.text = [hiscYears objectAtIndex:indexPath.row];
		label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor blackColor]; 
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:label];
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
		TyphoonListController *targetViewController;
        int valueDevice = [[UIDevice currentDevice] resolution];
        if (valueDevice == 3)
        {
            targetViewController=[[TyphoonListController alloc] initWithNibName:@"TyphoonList5" bundle:nil withYear:[hiscYears objectAtIndex:row]];
        } else {
            targetViewController=[[TyphoonListController alloc] initWithNibName:@"TyphoonList" bundle:nil withYear:[hiscYears objectAtIndex:row]];
        }
        
		if(targetViewController!=nil){
			targetViewController.navigationItem.title=@"选择当年台风";
			[[self navigationController] pushViewController:targetViewController animated:YES];
		}
	}
}
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//    return (indexPath.row==parserSelection) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
//}

@end
