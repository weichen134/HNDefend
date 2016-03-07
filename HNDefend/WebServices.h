//
//  WebServices.h
//  navag
//
//  Created by DY LOU on 10-4-10.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface WebServices : NSObject {

}
+(NSURL *)getRestUrl:(NSString *)url Function:(NSString *) methodName Parameter:(NSString *) params;
//Previous
+(NSURL *)getPRestUrl:(NSString *)url Function:(NSString *) methodName Parameter:(NSDictionary *) params;

+(void)postRestUrl:(NSURL *)url;
@end
