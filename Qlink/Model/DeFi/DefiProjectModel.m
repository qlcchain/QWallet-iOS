//
//  DefiProjectModel.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/8.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DefiProjectModel.h"
#import "GlobalConstants.h"

@implementation DefiProject_ValModel

@end

@implementation DefiProject_KeyModel


@end

@implementation DefiProjectModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id", @"Description":@"description"};
}

- (void)setJsonValue:(NSString *)jsonValue {
    _jsonValue = jsonValue;
    
    NSDictionary *jsonDic = [jsonValue mj_JSONObject];
    NSDictionary *tvlDic = jsonDic[@"tvl"];
    if (tvlDic != nil) {
        NSMutableArray *tempArr = [NSMutableArray array];
        [tvlDic.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *keyStr = obj;
            NSDictionary *valDic = tvlDic[keyStr];
            DefiProject_KeyModel *keyModel = [DefiProject_KeyModel new];
            keyModel.keyStr = keyStr;
            keyModel.valModel = [DefiProject_ValModel mj_objectWithKeyValues:valDic];
            [tempArr addObject:keyModel];
        }];
        _tvlArr = tempArr;
    }
}

- (NSString *)getRatingStr {
    NSString *ratingStr = @"10";
     if ([_rating isEqualToString:@"10"]) {
         ratingStr = @"A++";
     } else if ([_rating isEqualToString:@"9"]) {
         ratingStr = @"A+";
     } else if ([_rating isEqualToString:@"8"]) {
         ratingStr = @"A";
     } else if ([_rating isEqualToString:@"7"]) {
         ratingStr = @"B++";
     } else if ([_rating isEqualToString:@"6"]) {
         ratingStr = @"B+";
     } else if ([_rating isEqualToString:@"5"]) {
         ratingStr = @"B";
     } else if ([_rating isEqualToString:@"4"]) {
        ratingStr = @"C";
    } else if ([_rating isEqualToString:@"3"]) {
          ratingStr = @"D";
    } else if ([_rating isEqualToString:@"0"]) {
        ratingStr = kLang(@"defi_unrated");
    }
    return ratingStr;
}

@end
