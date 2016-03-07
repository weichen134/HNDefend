//
//  SatelliteController.h
//  navag
//
//  Created by DY LOU on 10-4-6.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SatelliteInfo;
@interface SatelliteController : UIViewController<UIScrollViewDelegate> {
	NSMutableData *receivedData;
	NSTimer *myTimer;
	bool isPlaying;
	bool downLoading;
	UIAlertView *alert;
	UIImageView *imageV;
	IBOutlet UIScrollView *myScroll;
	IBOutlet UILabel *selDate;
	IBOutlet UISegmentedControl *mySeg;
	NSString *ytType;
	NSMutableArray *sPath;
}
+(id)sharedController;
-(void)refreshImages;
-(void)getImages:(NSString *)wxytType;
-(void)setScrollView;
-(IBAction)changeType:(id)sender;
- (void)getYTPath:(NSString *)item;
- (void)getYTAllPath:(SatelliteInfo *)item;
-(IBAction)backToTop:(id)sender;
-(NSMutableArray *)getFileNameFromURL:(NSString *)type;
@property(nonatomic,retain)UIScrollView *myScroll;
@property(nonatomic,retain)UILabel *selDate;
@property(nonatomic,retain)UIImageView *imageV;
@property(nonatomic,retain)UISegmentedControl *mySeg;
@property(nonatomic,retain)NSString *ytType;
@property(nonatomic,retain)NSMutableArray *sPath;
@end
