//
//  JsonUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/26.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONUtil : NSObject

+ (NSString *)jsonStrFromDicWithTrim:(NSDictionary *)dict;
// 字典转json字符串方法
+ (NSString *)jsonStrFromDic:(NSDictionary *)dict;
// JSON字符串转化为字典
+ (NSDictionary *)dicFromJsonStr:(NSString *)jsonStr;

@end
