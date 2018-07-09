//
//  ChooseCountryUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/10.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChooseCountryUtil.h"
#import "ContinentModel.h"

@implementation ChooseCountryUtil

+ (instancetype)shareInstance {
    static id shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

+ (NSString *)getContinentOfCountry:(NSString *)inputCountry {
    __block NSString *continent = nil;
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ContinentAndCountryBean" ofType:@"json"]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    [dic[@"continent"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContinentModel *continentM = [ContinentModel getObjectWithKeyValues:obj];
        [continentM.country enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CountryModel *countryM = obj;
            if ([countryM.name isEqualToString:inputCountry]) {
                continent = continentM.continent;
                *stop = YES;
            }
        }];
        if (continent.length > 0) {
            *stop = YES;
        }
    }];
    return continent?:ASIA_CONTINENT;
}

+ (NSString *) getConutryNameWithCode:(NSString *) code
{
    __block NSString *countryName = nil;
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ContinentAndCountryBean" ofType:@"json"]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    [dic[@"continent"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContinentModel *continentM = [ContinentModel getObjectWithKeyValues:obj];
        [continentM.country enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CountryModel *countryM = obj;
            if ([countryM.countryCode isEqualToString:code]) {
                countryName = countryM.name;
                *stop = YES;
            }
        }];
        if (countryName.length > 0) {
            *stop = YES;
        }
    }];
    return countryName?:@"China";
}

+ (NSMutableArray *) getAllCountry
{
    __block NSMutableArray *countryArr = [NSMutableArray array];
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ContinentAndCountryBean" ofType:@"json"]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    [dic[@"continent"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContinentModel *continentM = [ContinentModel getObjectWithKeyValues:obj];
        [continentM.country enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CountryModel *countryM = obj;
            [countryArr addObject:countryM];
        }];
       
    }];
    // 对国家进行字母排序
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    [countryArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CountryModel *model1 = obj1;
        CountryModel *model2 = obj2;
        NSRange range = NSMakeRange(0,model1.name.length);
        return [model1.name compare:model2.name options:comparisonOptions range:range];
    }];
    return countryArr;
}

@end
