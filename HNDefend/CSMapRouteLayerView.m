//
//  CSMapRouteLayerView.m
//  mapLines
//
//  Created by Craig on 4/12/09.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "CSMapRouteLayerView.h"
#import "NewTyphoonController.h"

@implementation CSMapRouteLayerView
@synthesize mapView   = _mapView;
@synthesize typhoonsPoints = _typhoonsPoints;
@synthesize points, pointsZG, pointsXG, pointsTW, pointsRB;
@synthesize lineColor = _lineColor; 

-(id) initWithRoute:(NSMutableArray *)PointsArray mapView:(MKMapView*)mapView lineColor:(UIColor *) mlineColor{
	self = [super initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
	[self setBackgroundColor:[UIColor clearColor]];
	
	[self setMapView:mapView];
	[self setTyphoonsPoints:PointsArray];
	[self setUserInteractionEnabled:NO];
	
	if(nil == mlineColor)
		self.lineColor = [UIColor blackColor];
	else
		[self setLineColor:mlineColor];
	
	// determine the extents of the trip points that were passed in, and zoom in to that area. 
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	
	TyphoonsPoints * typhoonPoints = [self.typhoonsPoints objectAtIndex:0];
	self.points = typhoonPoints.routePoints;
	for(int idx = 0; idx < self.points.count; idx++)
	{
		DrawPoint *tf = [self.points objectAtIndex:idx];
		if([tf.WD doubleValue] > maxLat)
			maxLat = [tf.WD doubleValue];
		if([tf.WD doubleValue] < minLat)
			minLat = [tf.WD doubleValue];
		if([tf.JD doubleValue] > maxLon)
			maxLon = [tf.JD doubleValue];
		if([tf.JD doubleValue] < minLon)
			minLon = [tf.JD doubleValue];
	}
	
	MKCoordinateRegion region;
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat;
	region.span.longitudeDelta = maxLon - minLon;
	
	if( maxLon - minLon < 15)
		region.span.longitudeDelta  =  15;
	
	[self.mapView setRegion:region];
	[self.mapView setDelegate:self];
	[self.mapView addSubview:self];
	
	return self;
}

-(void) drawLine:(CGContextRef)context withPoints:(NSArray *)Points withLineColor:(UIColor *)mlineColor withLineWidth:(double)mLineWidth withDash:(BOOL)isDash{
	CGContextSetStrokeColorWithColor(context, mlineColor.CGColor);
	CGContextSetLineWidth(context, mLineWidth);
	
	if(isDash)
	{
		const float pattern[2] = {2, 3};
		CGContextSetLineDash(context, 0.0, pattern, 1);
	}
	else
	{
		const float pattern[2] = {0, 0};
		CGContextSetLineDash(context, 0.0, pattern, 0);
	}
	
	for(int idx = 0; idx < Points.count; idx++)
	{
		DrawPoint *tf = [Points objectAtIndex:idx];
		CLLocationCoordinate2D location;
		location.latitude = [tf.WD doubleValue];
		location.longitude = [tf.JD doubleValue];
		CGPoint point = [_mapView convertCoordinate:location toPointToView:self];
		
		if(idx == 0)
		{
			// move to the first point
			CGContextMoveToPoint(context, point.x, point.y);
		}
		else
		{
			CGContextAddLineToPoint(context, point.x, point.y);
		}
	}
	
	CGContextStrokePath(context);
	
	[self drawImages:Points];
}

-(void)drawImages:(NSArray *)Points{
	
	for(int idx = 0; idx < Points.count; idx++)
	{
		DrawPoint *tf = [Points objectAtIndex:idx];
		CLLocationCoordinate2D location;
		location.latitude = [tf.WD doubleValue];
		location.longitude = [tf.JD doubleValue];
		CGPoint point = [_mapView convertCoordinate:location toPointToView:self];

		point.x -= 2;
		point.y -= 2;
		[self drawImage:tf.TT withPoint:point];
	}
}

-(void)drawImage:(NSString *)type withPoint:(CGPoint)point{
	
	NSString *concealTheSpace = [type stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *symbol=[NSString stringWithString:@"utf.gif"];
	if([concealTheSpace compare:@"热带低气压"] == NSOrderedSame){
		symbol=@"td.gif";
	}else if([concealTheSpace compare:@"热带风暴"] == NSOrderedSame){
		symbol=@"min_blue.gif";
	}else if([concealTheSpace compare:@"强热带风暴"] == NSOrderedSame){
		symbol=@"ts.gif";
	}else if([concealTheSpace compare:@"台风"] == NSOrderedSame){
		symbol=@"min_yellow.gif";
	}else if([concealTheSpace compare:@"强台风"] == NSOrderedSame){
		symbol=@"sts.gif";
	}else if([concealTheSpace compare:@"超强台风"] == NSOrderedSame){
		symbol=@"tf.gif";
	}else if([concealTheSpace compare:@"当前点"] == NSOrderedSame){
		symbol=@"red1.gif";
	}else{
		symbol=@"utf.gif";
	}
	UIImage *image = [UIImage imageNamed:symbol];
	[image drawAtPoint:point];
}

-(void)drawRound:(CGContextRef)context withBeginP:(CGPoint)bP withEndP:(CGPoint)eP{
	float punkR = bP.x-eP.x;
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.2);
	CGContextBeginPath(context);
	CGContextAddArc(context, bP.x,bP.y, punkR, 0, 2*M_PI, 1);
	CGContextFillPath(context);
}


- (void)drawRect:(CGRect)rect{
	// only draw our lines if we're not int he moddie of a transition and we 
	// acutally have some points to draw. 
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.3);
	
	//for(int i=[self.typhoonsPoints count]-1; i>=0; i--){
	for(int i=0; i<[self.typhoonsPoints count]; i++){
		
		TyphoonsPoints * typhoonPoints = [self.typhoonsPoints objectAtIndex:i];
		self.points = typhoonPoints.routePoints;
		self.pointsZG = typhoonPoints.zgybPoints;
		self.pointsXG = typhoonPoints.xgybPoints;
		self.pointsTW = typhoonPoints.twybPoints;
		self.pointsRB = typhoonPoints.rbybPoints;
		
		if(!self.hidden && nil != self.points && self.points.count > 0)
		{
			[self drawLine:context withPoints:self.points withLineColor:self.lineColor withLineWidth:2.0 withDash:NO];
			[self drawLine:context withPoints:self.pointsZG withLineColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] withLineWidth:1.5 withDash:YES];
			[self drawLine:context withPoints:self.pointsXG withLineColor:[UIColor colorWithRed:1.0 green:0.3 blue:1.0 alpha:1.0] withLineWidth:1.5 withDash:YES];
			[self drawLine:context withPoints:self.pointsTW withLineColor:[UIColor colorWithRed:0.3 green:0.5 blue:0.1 alpha:1.0] withLineWidth:1.5 withDash:YES];
			[self drawLine:context withPoints:self.pointsRB withLineColor:[UIColor colorWithRed:0.0 green:0.3 blue:0.0 alpha:1.0] withLineWidth:1.5 withDash:YES];
			
			DrawPoint *tf = [self.points objectAtIndex:([self.points count]-1)];
			CLLocationCoordinate2D location;
			location.latitude = [tf.WD doubleValue];
			location.longitude = [tf.JD doubleValue];
			CGPoint point = [_mapView convertCoordinate:location toPointToView:self];
			CLLocationCoordinate2D location7;
			location7.latitude = location.latitude;
			location7.longitude = location.longitude + [tf.R7 floatValue]/(111.323*cos(location.latitude*M_PI/180));
			CGPoint point7 = [_mapView convertCoordinate:location7 toPointToView:self];
			[self drawRound:context withBeginP:point withEndP:point7];
			
			CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.2);
			CLLocationCoordinate2D location10;
			location10.latitude = location.latitude;
			location10.longitude = location.longitude + [tf.R10 floatValue]/(111.323*cos(location.latitude*M_PI/180));
			CGPoint point10 = [_mapView convertCoordinate:location10 toPointToView:self];
			[self drawRound:context withBeginP:point withEndP:point10];
			
			point.x -= 4;
			point.y -= 4;
			[self drawImage:@"当前点" withPoint:point];
		}
	}
}


#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition. 
	self.hidden = YES;
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	// re-enable and re-poosition the route display. 
	self.hidden = NO;
	[self setNeedsDisplay];
}
@end
