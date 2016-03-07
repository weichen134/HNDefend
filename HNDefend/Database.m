//
//  Database.m
//  navag
//
//  Created by DY LOU on 10-5-6.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "Database.h"
#import "BookInfo.h"
#import "LocationInfo.h"

@implementation Database

-(NSString *)getDBPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"bookdb.sqlite"];
	return writableDBPath;
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSError *error;
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath=[self getDBPath];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bookdb.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

-(void)distinctBooks{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="delete from book";
	NSString *path=[self getDBPath];
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	
	int success = sqlite3_step(stmt);
	if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
    }
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
}

#pragma mark Weather City

-(NSString *)getCodeOfCity:(NSNumber *)key{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select code from city where cid=?";
	NSString *path=[self getDBPath];
	NSString *code;
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	sqlite3_bind_int(stmt, 1, [key intValue]);
	
	if (sqlite3_step(stmt) == SQLITE_ROW) {
		code=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
	}else{
		code=nil;
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	return code;
}

-(NSArray *)getPrimaryKeysOfCity{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select cid from city";
	NSString *path=[self getDBPath];
	NSMutableArray *pks=[NSMutableArray array];
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		int primaryKey = sqlite3_column_int(stmt, 0);
		[pks addObject:[NSNumber numberWithInt:primaryKey]];
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	return pks;
}

-(NSString *)getNameOfCity:(NSNumber *)key{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select name from city where cid=?";
	NSString *path=[self getDBPath];
	NSString *name;
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	sqlite3_bind_int(stmt,1,[key intValue]);
	
	if (sqlite3_step(stmt) == SQLITE_ROW) {
		name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
	}else{
		name=nil;
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	return name;
}

-(NSMutableArray *)getCodeIDOfCityByName:(NSString *)key{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select code, cid from city where name=?";
	NSString *path=[self getDBPath];
	NSString *code;
	NSString *ctid;
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}

	sqlite3_bind_text(stmt,1,[key UTF8String],strlen([key UTF8String]), nil);
	
	if (sqlite3_step(stmt) == SQLITE_ROW) {
		code = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
		ctid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
	}else{
		code=@"0";
		ctid=nil;
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	
	NSMutableArray *codeid=[[NSMutableArray alloc] init];
	[codeid addObject:code];
	if(ctid){[codeid addObject:ctid];}
	
	return codeid;
}

#pragma mark Location

-(NSArray *)getAllProvince{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select pac, pacname from area where pac like '%%0000'";
	NSString *path=[self getDBPath];
	NSMutableArray *pks=[NSMutableArray array];
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		LocationInfo *item = [LocationInfo locationinfo];
		item.pac = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
		item.pacname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
		[pks addObject:item];
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	return pks;
}

-(NSArray *)getAllCity{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select pac, pacname from area where pac like '%%%%00' and pac not like '%%0000'";
	NSString *path=[self getDBPath];
	NSMutableArray *pks=[NSMutableArray array];
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		LocationInfo *item = [LocationInfo locationinfo];
		item.pac = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
		item.pacname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
		[pks addObject:item];
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	return pks;
}

-(NSArray *)getAllTown{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select pac, pacname from area where pac not like '%%%%00' and pac not like '%%0000'";
	NSString *path=[self getDBPath];
	NSMutableArray *pks=[NSMutableArray array];
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		LocationInfo *item = [LocationInfo locationinfo];
		item.pac = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
		item.pacname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
		[pks addObject:item];
		
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	return pks;
}

-(NSArray *)getCityByProvice:(NSString *)key{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select pac, pacname from area where pac like ? and pac not like '%%0000'";
	NSString *path=[self getDBPath];
	NSMutableArray *pks=[NSMutableArray array];
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	
	sqlite3_bind_text(stmt,1,[key UTF8String],strlen([key UTF8String]), nil);
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		LocationInfo *item = [LocationInfo locationinfo];
		item.pac = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
		item.pacname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
		[pks addObject:item];
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	return pks;
}

-(NSArray *)getTownByCity:(NSString *)key{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select pac, pacname from area where pac like ? and pac not like '%%%%00'";
	NSString *path=[self getDBPath];
	NSMutableArray *pks=[NSMutableArray array];
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	
	sqlite3_bind_text(stmt,1,[key UTF8String],strlen([key UTF8String]), nil);
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		LocationInfo *item = [LocationInfo locationinfo];
		item.pac = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
		item.pacname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
		[pks addObject:item];
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	return pks;
}

-(NSString *)getCityByCode:(NSString *)key{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select pacname from area where pac=?";
	NSString *path=[self getDBPath];
	NSString *name;
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	sqlite3_bind_text(stmt,1,[key UTF8String],strlen([key UTF8String]), nil);
	
	if (sqlite3_step(stmt) == SQLITE_ROW) {
		name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
	}else{
		name=nil;
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	return name;
}

-(LocationInfo *)getCityInfoByCode:(NSString *)key{
	sqlite3 *db;
	sqlite3_stmt *stmt;
	const char *sql="select pac,pacname from area where pac=?";
	NSString *path=[self getDBPath];
	LocationInfo *item = [LocationInfo locationinfo];
	
	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
		NSAssert(0, @"Error: failed to open database");
	}
	
	if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
	}
	sqlite3_bind_text(stmt,1,[key UTF8String],strlen([key UTF8String]), nil);
	
	if (sqlite3_step(stmt) == SQLITE_ROW) {
		item.pac = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
		item.pacname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
	}
	
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	return item;
	
}

@end
