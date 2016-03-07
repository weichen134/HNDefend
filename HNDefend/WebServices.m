//
//  WebServices.m
//  navag
//
//  Created by DY LOU on 10-4-10.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import "WebServices.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"

@implementation WebServices
NSString *_key = @"3d5900ae-111a-45be-96b3-d9e4606ca793";

+(NSURL *)getRestUrl:(NSString *)url Function:(NSString *) methodName Parameter:(NSString *) params
{		
	//keyStr
	NSString *keyStr = [NSString stringWithString:@""];
	
	//PART A--fetch up the sys time as the style in 2011-05-29 16:20:51
	NSDate *timeStr=[NSDate date];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"]; 
	NSString *partTime = [dateFormat stringFromDate:timeStr];
	keyStr=[keyStr stringByAppendingString:partTime];

	//PART B--fetch up the UDID
	//NSString *partUDID = [UIDevice currentDevice].uniqueIdentifier;
    NSString *partUDID = @"1f4583c2f917e28a5235832c7309a8f9ec237cd7";
	keyStr=[keyStr stringByAppendingString:@"&"];
	keyStr=[keyStr stringByAppendingString:partUDID];

	//PART C--compose the value as idenfitier of '|'
	if ([params length]>0) {
		keyStr=[keyStr stringByAppendingString:@"&"];
		keyStr=[keyStr stringByAppendingString:params];
	}
	NSLog(@"Before cry:%@",keyStr);
	//Encypt the keyStr
	StringEncryption *cry =[[StringEncryption alloc] init];
	NSData *keyData = [keyStr dataUsingEncoding:NSUTF8StringEncoding];

	CCOptions padding = kCCOptionPKCS7Padding;
	
	NSData *keyCryData = [cry encrypt:keyData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];

	NSString *cryStr = [keyCryData base64EncodingWithLineLength:0];
	//NSLog(@"After cry: %@",cryStr);
	//change the url as the urlcode
	NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
																				   (__bridge CFStringRef)cryStr,
																				   NULL,
																				   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				   kCFStringEncodingUTF8 ));
	//NSLog(@"%@",encodedString);
	
	//default webservice url ----use it as the total str
	NSString *myNewURL = [NSString stringWithFormat:@"%@%@?key=%@",url,methodName,encodedString];
	
	//NSLog(myNewURL);
	
	return [NSURL URLWithString:(__bridge NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)myNewURL, NULL, NULL, kCFStringEncodingUTF8) ];
}

//Previous Method
+(NSURL *)getPRestUrl:(NSString *)url Function:(NSString *) methodName Parameter:(NSDictionary *) params
{
	url=[url stringByAppendingString:methodName];
	
	BOOL firstKey=TRUE;
	for (NSString *key in params)
	{
		NSString *value=[params objectForKey:key];
		if (firstKey) url=[url stringByAppendingString:@"?"]; else url=[url stringByAppendingString:@"&"];
		url=[url stringByAppendingString:key];
		url=[url stringByAppendingString:@"="];
		url=[url stringByAppendingString:value];
		firstKey=FALSE;
	}
	//NSLog(url);
	return [NSURL URLWithString:(__bridge NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)CFBridgingRetain(url), NULL, NULL, kCFStringEncodingUTF8) ];
}

+(void)postRestUrl:(NSURL *)url
{
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"                             
							 "<UpdateIPByFunction xmlns=\"http://tempuri.org/\">\n"
							 "</UpdateIPByFunction>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>\n"
							 ];
	
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/ExecuteNonQuery" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
