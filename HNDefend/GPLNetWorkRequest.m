//
//  GPLNetWorkRequest.m
//  QianTangRiverHD
//
//  Created by GPL on 13-6-24.
//  Copyright (c) 2013年 Zhejiang Dayu Infomation Technology Inc. All rights reserved.
//

#import "GPLNetWorkRequest.h"

@implementation GPLNetWorkRequest

+(void)requestURLPathAsy:(NSString *)path onCompletion:(GeneralRequestFinishHandler)finish;
{
    //Background Queue
    NSOperationQueue *backgroundQuene = [[NSOperationQueue alloc] init];
    //URL Request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path]
                                                  cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                              timeoutInterval:URL_FETCH_TIMEOUT];
    //Send Request
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQuene
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (finish) {
                                   finish(data,error);
                               }
                           }];
}

+(void)requestURLPathAsy:(NSString *)path
            andMethod:(NSString *)method
            andParams:(NSString *)params
         onCompletion:(GeneralRequestDictionaryFinishHandler)finish
{
    NSString *fullPath = [path stringByAppendingFormat:@"/%@?key=%@",method,params];
    [GPLNetWorkRequest requestURLPathAsy:fullPath
                         onCompletion:^(NSData *result, NSError *error) {
                             if (error || result == nil) {
                                 if (finish) finish(nil);
                             } else {
                                 NSDictionary *dic = nil;
                                 if (finish) finish(dic);
                             }
                         }];
}

+(void)requestURLPathSy:(NSString *)path
           onCompletion:(GeneralRequestFinishHandler)finish;
{
    //URL Request
    NSString *utf8Path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:utf8Path]
                                                  cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                              timeoutInterval:URL_FETCH_TIMEOUT];
    [request setValue:@"op099er56757" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    //Send Request
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    if(nil == error)
    {
        if (nil != response) {
            NSDictionary *headers = [(NSHTTPURLResponse*)response allHeaderFields];
            NSString *content_type = [headers objectForKey:@"Content-Type"];
            NSLog(@"Content-Type:%@",content_type);
            int statusCode = [(NSHTTPURLResponse*)response statusCode];
            NSLog(@"Http status Code:%i",statusCode);
            if ((statusCode > 199) && (statusCode < 299) && (data !=nil)) {
                NSLog(@"Data Length:%d",data.length);
            }
        }
    }
    //no matter how,excute this
    finish(data,error);
}

+(void)dealWithError:(NSError *)error
{
    NSString *alertInfo = SYSTEM_UNKOWN_ERROR;
    if (error.code == -1001) {
        alertInfo = SYSTEM_TIMEOUT_ERROR;
        NSLog(SYSTEM_TIMEOUT_ERROR);
    } else if (error.code == -1003) {
        alertInfo =  SYSTEM_SERVER_NORESPONSE_ERROR;
        NSLog(SYSTEM_SERVER_NORESPONSE_ERROR);
    } else if (error.code == -1004) {
        alertInfo = SYSTEM_SERVE_DENY_ERROR;
        NSLog(SYSTEM_SERVE_DENY_ERROR);
    } else if (error.code == -1009) {
        alertInfo = SYSTEM_NETWORK_FALIURE_ERROR;
        NSLog(SYSTEM_NETWORK_FALIURE_ERROR);
    } else {
        NSLog(SYSTEM_UNKOWN_ERROR);
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertInfo
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

+(void)dealWithError:(NSError *)error delegate:(id)delegate
{
    NSString *alertInfo = SYSTEM_UNKOWN_ERROR;
    if (error.code == -1001) {
        alertInfo = SYSTEM_TIMEOUT_ERROR;
        NSLog(SYSTEM_TIMEOUT_ERROR);
    } else if (error.code == -1003) {
        alertInfo =  SYSTEM_SERVER_NORESPONSE_ERROR;
        NSLog(SYSTEM_SERVER_NORESPONSE_ERROR);
    } else if (error.code == -1004) {
        alertInfo = SYSTEM_SERVE_DENY_ERROR;
        NSLog(SYSTEM_SERVE_DENY_ERROR);
    } else if (error.code == -1009) {
        alertInfo = SYSTEM_NETWORK_FALIURE_ERROR;
        NSLog(SYSTEM_NETWORK_FALIURE_ERROR);
    } else {
        NSLog(SYSTEM_UNKOWN_ERROR);
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertInfo
                                                        message:nil
                                                       delegate:delegate
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"重试",nil];
    [alertView show];
}

@end
