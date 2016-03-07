//
//  TyphoonPathListController.h
//  navag
//
//  Created by DY LOU on 10-6-26.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TyphoonPathListController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {    
    NSMutableArray *infoArray;
    NSMutableArray *hisArray;
    NSMutableArray *myTableArray;
    NSInteger myIndex;
    
    UITableView *myTable;
    UISegmentedControl *mySeg;
}

@property (nonatomic, retain) NSMutableArray *infoArray;
@property (nonatomic, retain) NSMutableArray *hisArray;
@property (nonatomic, retain) NSMutableArray *myTableArray;
@property (nonatomic) NSInteger myIndex;

@property (nonatomic, retain) IBOutlet UITableView *myTable;
@property (nonatomic, retain) IBOutlet UISegmentedControl *mySeg;

@property (nonatomic,weak) IBOutlet UIImageView *titleImgV;

//新台风信息
@property (nonatomic,weak) IBOutlet UILabel *typhoonLevel;
@property (nonatomic,weak) IBOutlet UILabel *typhoonDistance;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTyphoonInfoArray:(NSMutableArray *)temInfoArray historyArray:(NSMutableArray *)temHisArray;
-(void)changeTheSegOfTyphoon;


@end
