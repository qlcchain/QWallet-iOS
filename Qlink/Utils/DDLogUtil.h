//
//  DDLogUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/16.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDLogUtil : NSObject

+ (void)getDDLog;
+ (void)getDDLogStr:(void (^)(NSString *text))block;

@end
