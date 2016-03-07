//
//  GPLNetWorkRequest.h
//  QianTangRiverHD
//
//  Created by GPL on 13-6-24.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//network error infomation
#define SYSTEM_TIMEOUT_ERROR @"服务器请求超时"                   //1001
#define SYSTEM_SERVER_NORESPONSE_ERROR @"服务器主机未响应"      //1003
#define SYSTEM_SERVE_DENY_ERROR @"服务器拒绝访问"               //1004
#define SYSTEM_NETWORK_FALIURE_ERROR @"网络未开启，请检查网络设置"  //1009
#define SYSTEM_UNKOWN_ERROR @"发生未知错误"            

//network timeout seconds
#define URL_FETCH_TIMEOUT 40

typedef void (^GeneralRequestFinishHandler)(NSData*,NSError*);
typedef void (^GeneralRequestDictionaryFinishHandler)(NSDictionary*);

//This Class is used for fetch data through internet
@interface GPLNetWorkRequest : NSObject

//improve the user felling
//use asynchronous method ,fetch data by url,and return NSString and NSError Objects
+(void)requestURLPathAsy:(NSString *)path
         onCompletion:(GeneralRequestFinishHandler)finish;
//use asynchronous method ,fetch data by url and params,and return NSDictionary object
+(void)requestURLPathAsy:(NSString *)path
            andMethod:(NSString *)method
            andParams:(NSString *)params
         onCompletion:(GeneralRequestDictionaryFinishHandler)finish;


//Step by step,use these synchronous methods
//use synchronous method ,fetch data by url,and return NSString and NSError Objects
+(void)requestURLPathSy:(NSString *)path
            onCompletion:(GeneralRequestFinishHandler)finish;

//ERROR
+(void)dealWithError:(NSError *)error;
//ERROR With Delegate
+(void)dealWithError:(NSError *)error delegate:(id)delegate;

@end
