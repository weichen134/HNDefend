//
//  TyphoonPathListController.m
//  navag
//
//  Created by DY LOU on 10-6-26.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "TyphoonPathListOldController.h"
#import "MyTableCell.h"
#import "typhoonXMLParser.h"


@implementation TyphoonPathListOldController

@synthesize hiscPath;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withList:(NSMutableArray *)tfList {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
		self.hiscPath =[NSMutableArray array];
		self.hiscPath = tfList;
		
		//[self createRootbuttont];
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

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int i=0;
	i++;
}

-(IBAction)backToTop:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
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
	return [hiscPath count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
	MyTableCell *cell = (MyTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil){
		cell = [[MyTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
		
		TFPathInfo * tfinfo=[hiscPath objectAtIndex:([hiscPath count] - indexPath.row - 1)];
		
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

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellAccessoryNone;
}

@end
