//
//  Database.h
//  navag
//
//  Created by DY LOU on 10-5-6.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class BookInfo;
@class LocationInfo;
@interface Database : NSObject {

}
-(NSString *)getDBPath;
- (void)createEditableCopyOfDatabaseIfNeeded;
-(void)distinctBooks;

-(NSString *)getNameOfCity:(NSNumber *)key;
-(NSArray *)getPrimaryKeysOfCity;
-(NSString *)getCodeOfCity:(NSNumber *)key;
-(NSMutableArray *)getCodeIDOfCityByName:(NSString *)key;

-(NSArray *)getAllProvince;
-(NSArray *)getAllCity;
-(NSArray *)getAllTown;
-(NSArray *)getCityByProvice:(NSString *)key;
-(NSArray *)getTownByCity:(NSString *)key;
-(NSString *)getCityByCode:(NSString *)key;
-(LocationInfo *)getCityInfoByCode:(NSString *)key;

@end
