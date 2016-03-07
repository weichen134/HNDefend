//
//  SatelliteController.m
//  navag
//
//  Created by DY LOU on 10-4-6.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "SatelliteController.h"
#import "FileManager.h"
#import "SatelliteXMLParser.h"
#import "WebServices.h"

static SatelliteController *me=nil;
@implementation SatelliteController

@synthesize myScroll,selDate,imageV,mySeg,sPath;
@synthesize ytType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
		isPlaying=NO;
		downLoading=NO;
		
		ytType = @"error";
		sPath = [[NSMutableArray alloc] init];
		[sPath addObject:@"0"];
		[sPath addObject:@"0"];
		[sPath addObject:@"0"];
		me = self;
	}
	return self;
}


 /*Implement loadView if you want to create a view hierarchy programmatically*/
 - (void)viewDidLoad {	 
	 //获取图片
	 NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	 
     NSString *baseURL= @"http://pda.zjwater.gov.cn/DataCenterService/DataService.asmx/";
	 NSURL *cloudURL=[WebServices getRestUrl:baseURL Function:@"CloudImage" Parameter:[NSString stringWithFormat:@""]];

	 //parse XML
	 SatelliteAllXMLParser *paser=[[SatelliteAllXMLParser alloc] init];
	 [paser parseXMLFileAtURL:cloudURL parseError:nil]; 
	 [paser release];
	 
	 [pool release];
	 
	 if([[sPath objectAtIndex:0]isEqualToString:@"0"])
	  [mySeg setEnabled:NO forSegmentAtIndex:0];
	  if([[sPath objectAtIndex:1]isEqualToString:@"0"])
	  [mySeg setEnabled:NO forSegmentAtIndex:1];
	  if([[sPath objectAtIndex:2]isEqualToString:@"0"])
	  [mySeg setEnabled:NO forSegmentAtIndex:2];
 }

-(IBAction)backToTop:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}


+(id)sharedController{
	return me;
}

// If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidAppear:(BOOL)animated {
	for(int i=0; i<3; i++){
		if([[sPath objectAtIndex:i] isEqualToString:@"0"] == NO) {
			if([ytType compare:@"error"] == NSOrderedSame){
				switch (i) {
					case 1:
						ytType=@"sanwei";
						break;
					case 2:
						ytType=@"shuiqi";
						break;
					default:
						ytType=@"hongwai";
						break;
				}
			}
		}
	}
	
	[NSThread detachNewThreadSelector:@selector(refreshImages) toTarget:self withObject:nil];
}

-(void)loadLogo:(NSArray *)obj{
	UIImage *img=[obj objectAtIndex:0];
	NSString *title=[obj objectAtIndex:1];
	if(imageV==nil){
		imageV=[[UIImageView alloc] initWithImage:img];
		[self setScrollView];
	}else{
		imageV.image=img;
	}
	selDate.text=title;
}

/*
 - (void)viewWillAppear:(BOOL)animated{
 }*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	NSLog(@"内存不足！");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)getYTPath:(NSString *)item{
	if([ytType isEqualToString:@"hongwai"]){
		[sPath replaceObjectAtIndex:0 withObject:item];
	}else if([ytType isEqualToString:@"sanwei"]){
		[sPath replaceObjectAtIndex:1 withObject:item];
	}else if([ytType isEqualToString:@"shuiqi"]){
		[sPath replaceObjectAtIndex:2 withObject:item];
	}
}

- (void)getYTAllPath:(SatelliteInfo *)item{
	if([item.sType isEqualToString:@"hongwai"]){
		[sPath replaceObjectAtIndex:0 withObject:item.sPath];
	}else if([item.sType isEqualToString:@"sanwei"]){
		[sPath replaceObjectAtIndex:1 withObject:item.sPath];
	}else if([item.sType isEqualToString:@"shuiqi"]){
		[sPath replaceObjectAtIndex:2 withObject:item.sPath];
	}
}

-(void)getImages:(NSString *)wxytType{
	UIImage *img;
	
	//获取文件名数组
	NSMutableArray *imageNames=[[NSMutableArray alloc] init];
	NSMutableArray *fileInfo = [self getFileNameFromURL:wxytType];
	NSString *fileName=[fileInfo objectAtIndex:1];
	[imageNames addObject:fileName];
	
	//获取缓存信息
	FileManager *filem=[FileManager alloc];
	NSFileManager *file=[NSFileManager defaultManager];
	NSString *CacheDir=[NSString stringWithFormat:@"%@%@/", [filem getCacheDir],wxytType];
    NSArray *cacheFiles=[file contentsOfDirectoryAtPath:CacheDir error:nil];
	NSString *cacheName=[CacheDir stringByAppendingString:fileName];
	NSLog(cacheName);
		
	//加载图片
	if([file fileExistsAtPath:cacheName]==NO){
		//如果图片在本地不存在，下载保存
		NSString *url=[fileInfo objectAtIndex:0];
		NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
			
		img =(data==nil?nil:[[UIImage alloc] initWithData:data]);
		if(img!=nil){
			if([filem saveToCacheFile:data fileName:fileName withType:wxytType]){
				NSLog(@"save cache successfull!");
				//清除过期的缓存
				for(int n=0;n<[cacheFiles count];n++){
					NSString *cfile=[cacheFiles objectAtIndex:n];
					if([imageNames containsObject:cfile]==NO){
						NSString *cacheName=[CacheDir stringByAppendingString:cfile];
						if([file removeItemAtPath:cacheName error:nil]){
							NSLog(@"remove cache %@",cfile);
						}
					}
				}
			}else{
				NSLog(@"save cache fail!");
			}
		}
		else{
			//获取失败，加载前一张图片
			if([cacheFiles count] > 0){
				cacheName=[CacheDir stringByAppendingString:[cacheFiles objectAtIndex:0]];
				fileInfo = [self getFileNameFromURL:cacheName];
				img=[[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:cacheName]];
				NSLog(@"load from cache!");
			}
		}
		//NSLog(url);
	}else{
		//存在，从本地加载
		img=[[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:cacheName]];
		NSLog(@"load from cache!");
	}
	
	//显示图片
	if(img==nil){
		NSLog(@"data is invalid!");
		NSString *title=[fileInfo objectAtIndex:2];
		if([title compare:@"图片名称错误"] != NSOrderedSame)
			title = @"图片加载失败";
		selDate.text=title;
	}else{
		NSString *title=[fileInfo objectAtIndex:2];
		NSMutableArray *obj=[NSMutableArray array];
		[obj addObject:img];
		[obj addObject:title];
		[self performSelectorOnMainThread:@selector(loadLogo:) withObject:obj waitUntilDone:NO];
	}
	
	//释放内存
	if(img!=nil){
		[img release];
		img=nil;
	}
	
	[imageNames release];
	[filem release];
}

-(NSMutableArray *)getFileNameFromURL:(NSString *)type{
	NSMutableArray *retArray = [NSMutableArray array];
	
	NSString *strPath;
	if([type isEqualToString:@"hongwai"]){
		strPath = [sPath objectAtIndex:0];
	}else if([type isEqualToString:@"sanwei"]){
		strPath = [sPath objectAtIndex:1];
	}else if([type isEqualToString:@"shuiqi"]){
		strPath = [sPath objectAtIndex:2];
	}else{
		strPath = type;
	}
	
	// Add the image path
	[retArray addObject:strPath];
	
	// Add the image name
	NSRange nr = [strPath rangeOfString:@"/" options: NSBackwardsSearch];
	NSString *fileName = [strPath substringFromIndex:nr.location+1];
	[retArray addObject:fileName];
	
	// Add teh date title 200908170900.jpg
	NSString *title = @"";
	NSInteger temp = [[fileName substringToIndex:[fileName length]-3] intValue];
	if(temp > 0 && [fileName length] == 16)
	{
		fileName = [fileName substringFromIndex:2];
		title = [NSString stringWithFormat:@"%@-", [fileName substringToIndex:2]];
		fileName = [fileName substringFromIndex:2];
		title = [title stringByAppendingString:[fileName substringToIndex:2]];
		title = [title stringByAppendingString:@"-"];
		fileName = [fileName substringFromIndex:2];
		title = [title stringByAppendingString:[fileName substringToIndex:2]];
		title = [title stringByAppendingString:@"日"];
		fileName = [fileName substringFromIndex:2];
		title = [title stringByAppendingString:[fileName substringToIndex:2]];
		title = [title stringByAppendingString:@"点"];
		fileName = [fileName substringFromIndex:2];
		title = [title stringByAppendingString:[fileName substringToIndex:2]];
		title = [title stringByAppendingString:@"分"];
	}
	else
	{
		title = @"图片名称错误";
	}
	[retArray addObject:title];
	
	return retArray;
}

-(void)setScrollView{
	myScroll.showsHorizontalScrollIndicator = NO;
	myScroll.showsVerticalScrollIndicator = NO;
	myScroll.multipleTouchEnabled=YES;
	myScroll.scrollEnabled=YES;
	myScroll.clipsToBounds=YES;
	myScroll.delegate=self;
	myScroll.contentSize=imageV.image.size;
	myScroll.maximumZoomScale=1.5;
	myScroll.minimumZoomScale=0.55;
	[myScroll addSubview:imageV];
	
	[myScroll scrollRectToVisible:CGRectMake(0, 0, 200, 200) animated:YES];
}

-(void)refreshImages{	
	if([ytType compare:@"error"] == NSOrderedSame){
		selDate.text = @"未连接网络";
	}else{
		downLoading=YES;
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

		[self getImages:ytType];
	
		[pool release];
		downLoading=NO;
		mySeg.enabled = YES;
	}
}

-(IBAction)changeType:(id)sender{	
	mySeg.enabled = NO;
	NSInteger select = mySeg.selectedSegmentIndex;
	switch (select) {
		case 0:
			ytType=@"hongwai";
			break;
		case 1:
			ytType=@"sanwei";
			break;
		case 2:
			ytType=@"shuiqi";
			break;
		default:
			ytType=@"error";
			break;
	}
	
	[NSThread detachNewThreadSelector:@selector(refreshImages) toTarget:self withObject:nil];
}


#pragma mark UIScrollView
- (UIView *) viewForZoomingInScrollView: (UIScrollView *) scrollView{
	return imageV;
}
- (void) scrollViewDidEndZooming: (UIScrollView *) scrollView withView: (UIView *) view atScale: (float) scale{
	CGAffineTransform transform = CGAffineTransformIdentity;
	transform = CGAffineTransformScale(transform, scale, scale);
	view.transform = transform;
}
/*- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
 }
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 }*/

- (void)dealloc {
	[myScroll release];
	[selDate release];
	[imageV release];
	[mySeg release];
	[sPath release];
	
	if(isPlaying){
		[myTimer invalidate];
		[myTimer release];	
	}
	[super dealloc];
}

@end
