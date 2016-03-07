//
//  Parser.h
//  navag
//
//  Created by DY LOU on 10-4-15.
//  Copyright 2010 Zhejiang Dayu Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Parser : NSObject {

}
- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error;
@end
