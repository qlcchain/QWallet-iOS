//
//  DigestUtils.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/27.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "DigestUtils.h"
#import "MD5Util.h"
#import "NSString+HexStr.h"

@implementation DigestUtils

+ (NSString *)getSignature:(NSDictionary *)dicP {
    NSString *sortStr = [DigestUtils sortedAndSplicingWithDic:dicP];
    NSString *resultStr = [DigestUtils encode:sortStr];
    
    return resultStr;
}

/**
 对字典(Key-Value)排序 区分大小写
 @param dicP 要排序的字典
 */
+ (NSString *)sortedAndSplicingWithDic:(NSDictionary *)dicP {
    //将所有的key放进数组
    NSArray *allKeyArray = [dicP allKeys];
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        // 排序结果
        //NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
        //NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         //注意:compare方法是区分大小写的,即按照ASCII排序
        //排序操作
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
//    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
    
    //通过排列的key值获取value
    NSMutableString *resultStr = [NSMutableString string];
    NSInteger keyCount = afterSortKeyArray.count;
    [afterSortKeyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *keyStr = obj;
        NSString *valueStr = dicP[keyStr]?:@"";
        NSString *tempStr = [[keyStr stringByAppendingString:@"="] stringByAppendingString:valueStr];
        [resultStr appendString:tempStr];
        if (idx < keyCount - 1) {
            [resultStr appendString:@"&"];
        }
    }];
//    NSLog(@"resultStr = %@",resultStr);
    return resultStr;
}

+ (NSString *)encode:(NSString *)strP {
    NSString *mifi = [ConfigUtil getMIFI];
    NSString *splicingStr = [strP stringByAppendingString:mifi];
//    NSLog(@"splicingStr = %@",splicingStr);
    NSString *md5Str = [MD5Util md5:splicingStr];
//    NSLog(@"md5Str = %@",md5Str);
//    NSString *hexStr = [NSString hexStringFromString:md5Str];
//    NSLog(@"hexStr = %@",hexStr);
    NSString *resultStr = [md5Str lowercaseString];
//    NSLog(@"resultStr = %@",resultStr);
    
    return resultStr;
}

@end
