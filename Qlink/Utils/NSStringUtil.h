//
//  NSStringUtil.h
//  Qlink
//
//  Created by 旷自辉 on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringUtil : NSObject
// 当nsstring 为 nil 时  置为@""
+ (NSString *)getNotNullValue:(NSString *)str;
@end
