//
//  GPLGlobalDistance.m
//  HNDefend
//
//  Created by GPL on 14-2-13.
//  Copyright (c) 2014年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLGlobalDistance.h"
#include <math.h>

static const double EARTH_RADIUS = 6378.137;

@implementation GPLGlobalDistance
/*
 private const double EARTH_RADIUS = 6378.137;
 private static double rad(double d)
 {
 return d * Math.PI / 180.0;
 }
*/
+(double)rad:(double)d;
{
    return d * M_PI / 180.0;
}
/*
 public static double GetDistance(double lat1, double lng1, double lat2, double lng2)
 {
 double radLat1 = rad(lat1);
 double radLat2 = rad(lat2);
 double a = radLat1 - radLat2;
 double b = rad(lng1) - rad(lng2);
 double s = 2 * Math.Asin(Math.Sqrt(Math.Pow(Math.Sin(a/2),2) +
 Math.Cos(radLat1)*Math.Cos(radLat2)*Math.Pow(Math.Sin(b/2),2)));
 s = s * EARTH_RADIUS;
 s = Math.Round(s * 10000) / 10000;
 return s;
 }
 */
+(double)getDistanceBeginLat:(NSString *)lats1
                    BeginLng:(NSString *)lngs1
                      EndLat:(NSString *)lats2
                      EndLng:(NSString *)lngs2;
{
    double lat1 = [lats1 doubleValue];
    double lng1 = [lngs1 doubleValue];
    double lat2 = [lats2 doubleValue];
    double lng2 = [lngs2 doubleValue];
    
    double radLat1 = [self rad:lat1];
    double radLat2 = [self rad:lat2];
    double a = radLat1 - radLat2;
    double b = [self rad:lng1] - [self rad:lng2];
    double s = 2 * asin(sqrt(pow(sin(a/2),2) +cos(radLat1)*cos(radLat2)*pow(sin(b/2),2)));
    s = s * EARTH_RADIUS;
    s = round(s * 10000) / 10000;
    return s;
}
@end
