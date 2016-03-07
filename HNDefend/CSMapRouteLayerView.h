//
//  CSMapRouteLayerView.h
//  mapLines
//
//  Created by Craig on 4/12/09.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CSMapRouteLayerView : UIView <MKMapViewDelegate>
{
	MKMapView* _mapView;
	NSArray* _typhoonsPoints;
	NSArray* points;
	NSArray* pointsZG;
	NSArray* pointsXG;
	NSArray* pointsTW;
	NSArray* pointsRB;
	UIColor* _lineColor;
}
@property (nonatomic, retain) NSArray* typhoonsPoints;
@property (nonatomic, retain) NSArray* points;
@property (nonatomic, retain) NSArray* pointsZG;
@property (nonatomic, retain) NSArray* pointsXG;
@property (nonatomic, retain) NSArray* pointsTW;
@property (nonatomic, retain) NSArray* pointsRB;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) UIColor* lineColor; 

-(id) initWithRoute:(NSArray *)PointsArray mapView:(MKMapView*)mapView lineColor:(UIColor *) mlineColor;
-(void) drawLine:(CGContextRef)context withPoints:(NSArray *)Points withLineColor:(UIColor *)mlineColor withLineWidth:(double)mLineWidth withDash:(BOOL)isDash;
-(void)drawRound:(CGContextRef)context withBeginP:(CGPoint)bP withEndP:(CGPoint)eP;
-(void)drawImage:(NSString *)type withPoint:(CGPoint)point;
-(void)drawImages:(NSArray *)Points;


@end
