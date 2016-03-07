//
//  TyphoonPathListController.h
//  navag
//
//  Created by DY LOU on 10-6-26.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TyphoonPathListOldController : UIViewController<UIScrollViewDelegate> {
	NSMutableArray *hiscPath;
	NSInteger parserSelection;
}

@property (nonatomic, retain) NSMutableArray *hiscPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withList:(NSMutableArray *)tfList;

@end
