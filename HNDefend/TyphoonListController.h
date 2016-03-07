//
//  TyphoonList.h
//  navag
//
//  Created by DY LOU on 10-6-23.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFList;
@interface TyphoonListController : UIViewController {
	NSMutableArray *hiscTyphoon;
	NSInteger parserSelection;
	NSString *currentYear;
}

@property (nonatomic, retain) NSMutableArray *hiscTyphoon;
@property (nonatomic, retain) NSString *currentYear;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withYear:iYear;
- (void)getTFList:(TFList *)tf;
+(id)sharedController;

@end
