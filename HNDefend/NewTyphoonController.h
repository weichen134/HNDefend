//
//  NewTyphoonController.h
//  navag
//
//  Created by DY LOU on 10-7-22.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface POI : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
	NSString *subtitle;
	NSString *title;
	NSString *type;
}

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSString *subtitle;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *type;

- (id) initWithCoords:(CLLocationCoordinate2D) coords;

@end

/////////////////////////////////////////////

@interface DrawPoint : NSObject
{
	NSString *tfID;
	NSString *RQSJ2;
	NSString *JD;
	NSString *WD;
	NSString *QY;
	NSString *FS;
	NSString *FL;
    NSString *movesd;
	NSString *R7;
	NSString *R10;
	NSString *TT;
}
+(id)drawpoint;
@property(copy)NSString *tfID;
@property(copy)NSString *RQSJ2;
@property(copy)NSString *JD;
@property(copy)NSString *WD;
@property(copy)NSString *QY;
@property(copy)NSString *FS;
@property(copy)NSString *FL;
@property(copy)NSString *movesd;
@property(copy)NSString *R7;
@property(copy)NSString *R10;
@property(copy)NSString *TT;
@end

/////////////////////////////////////////////////// 

@interface TyphoonsPoints : NSObject
{
	NSMutableArray *routePoints;
	NSMutableArray *zgybPoints;
	NSMutableArray *xgybPoints;
	NSMutableArray *twybPoints;
	NSMutableArray *rbybPoints;
}
+(id)typhoonspoints;
@property(copy)NSMutableArray *routePoints;
@property(copy)NSMutableArray *zgybPoints;
@property(copy)NSMutableArray *xgybPoints;
@property(copy)NSMutableArray *twybPoints;
@property(copy)NSMutableArray *rbybPoints;
@end

/////////////////////////////////////////////////// 

@class TFPathInfo,TFList,TFYBList,CSMapRouteLayerView;
@interface NewTyphoonController : UIViewController<MKMapViewDelegate,UIActionSheetDelegate> {
	IBOutlet MKMapView *mapbg;
	IBOutlet UIBarButtonItem *myHistory;
	IBOutlet UIBarButtonItem *myZoomOut;
	IBOutlet UIBarButtonItem *myList;
	IBOutlet UIBarButtonItem *myRefresh;
	
	TFPathInfo *TFNewlyPath;
	NSMutableArray *TFPaths;
	NSMutableArray *TFNewList;
	NSMutableArray *TFYBZGList;
	NSMutableArray *TFYBXGList;
	NSMutableArray *TFYBTWList;
	NSMutableArray *TFYBMGList;
	NSMutableArray *TFYBRBList;
	NSMutableArray *PointsList;
	NSMutableArray *PointsRoute;
	NSMutableArray *PointsZG;
	NSMutableArray *PointsXG;
	NSMutableArray *PointsTW;
	NSMutableArray *PointsRB;
	NSMutableArray *PointsArray;
	DrawPoint *item;
	NSString *gtfName;
	NSString *gtfYear;
	NSMutableString *iTest;
	
	CSMapRouteLayerView *routeView;
	UIActivityIndicatorView *myActivity;
	
	NSInteger whichSheet;
	BOOL isCurrentTyphoon;
    BOOL notFromSearch;
}

@property(nonatomic, retain) MKMapView *mapbg;
@property(nonatomic, retain) UIBarButtonItem *myHistory;
@property(nonatomic, retain) UIBarButtonItem *myZoomOut;
@property(nonatomic, retain) UIBarButtonItem *myList;
@property(nonatomic, retain) UIBarButtonItem *myRefresh;

@property(nonatomic, retain) TFPathInfo *TFNewlyPath;
@property(nonatomic, retain) NSMutableArray *TFPaths;
@property(nonatomic, retain) NSMutableArray *TFNewList;
@property(nonatomic, retain) NSMutableArray *TFYBZGList;
@property(nonatomic, retain) NSMutableArray *TFYBXGList;
@property(nonatomic, retain) NSMutableArray *TFYBTWList;
@property(nonatomic, retain) NSMutableArray *TFYBMGList;
@property(nonatomic, retain) NSMutableArray *TFYBRBList;
@property(nonatomic, retain) NSMutableArray *PointsList;
@property(nonatomic, retain) NSMutableArray *PointsRoute;
@property(nonatomic, retain) NSMutableArray *PointsZG;
@property(nonatomic, retain) NSMutableArray *PointsXG;
@property(nonatomic, retain) NSMutableArray *PointsTW;
@property(nonatomic, retain) NSMutableArray *PointsRB;
@property(nonatomic, retain) NSMutableArray *PointsArray;
@property(nonatomic, retain) NSString *gtfName;
@property(nonatomic, retain) NSString *gtfYear;
@property(nonatomic,retain) NSMutableString *iTest;
@property(nonatomic, retain) CSMapRouteLayerView *routeView;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *myActivity;

@property(nonatomic) NSInteger whichSheet;
@property(nonatomic,assign) BOOL isCurrentTyphoon;
@property(nonatomic) BOOL notFromSearch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFromKey:(BOOL)key;
- (void)createNousbuttont;
- (IBAction)nousgo;
- (IBAction)goHistory:(id)sender;
- (IBAction)zoomOutMap:(id)sender;
- (IBAction)goList:(id)sender;
- (IBAction)mapRefresh:(id)sender;
+ (id)sharedController;
- (void)getTFPath:(TFPathInfo *)tfp;
- (void)getNewTF:(TFList *)tf;
- (void)getTFYB:(TFYBList *)ybtf;
-(void)initTyphoons:(NSString *)mYear withName:(NSString *)tfName;
- (void)drawTyphoon:(NSString *)mYear withName:(NSString *)tfName;
-(void)DrawNewlyTyphoon:(NSArray *)TFLists isCurrent:(BOOL)current;
-(void)showThingsOnMap;
-(void)backgroundFetchUpData;

-(void *) createMapPoint:(MKMapView *) mapView coordinateX:(double)coorX coordinateY:(double)coorY Type:(NSString *)type Title:(NSString *)title Subtitle:(NSString *)subtitle;
-(void) addAllPoints:(NSMutableArray *)tfPoints;
-(void) addAllYBPoints:(NSMutableArray *)ZG withXG:(NSMutableArray *)XG withTW:(NSMutableArray *)TW withRB:(NSMutableArray *)RB;

@end
