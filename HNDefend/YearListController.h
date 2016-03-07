//
//  YearList.h
//  navag
//
//  Created by DY LOU on 10-6-23.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YearListController : UIViewController {
	NSMutableArray *hiscYears;
	NSInteger parserSelection;
}

@property (nonatomic, retain) NSMutableArray *hiscYears;

@end
