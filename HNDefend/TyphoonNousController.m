//
//  TyphoonNousController.m
//  navag
//
//  Created by DY LOU on 10-7-24.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "TyphoonNousController.h"


@implementation TyphoonNousController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		// Initialization code
		NSString *html=@"<div style=\"margin:0;font-size:16px\"><br>【超强台风】 底层中心附近最大平均风速≥51.0米/秒，也即16级或以上。<br><br>【强台风】 底层中心附近最大平均风速41.5-50.9米/秒，也即14-15级。<br><br>【台风】 底层中心附近最大平均风速32.7-41.4米/秒，也即12-13级。<br><br>【强热带风暴】 底层中心附近最大平均风速24.5-32.6米/秒，也即风力10-11级。<br><br>【热带风暴】 底层中心附近最大平均风速17.2-24.4米/秒，也即风力8-9级。<br><br>【热带低压】 底层中心附近最大平均风速10.8-17.1米/秒，也即风力为6-7级。</div>";
		
		UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
		[self.view addSubview:web];
		
		[web loadHTMLString:html baseURL:nil];
    }
    return self;
}

-(IBAction)backToTop:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
