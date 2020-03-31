//
//  ChooseCountryUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/10.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChooseCountryUtil.h"
#import "ContinentModel.h"
#import "GlobalConstants.h"

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
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryList" ofType:@"json"]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    [dic[@"country"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         CountryModel *countryM = [CountryModel getObjectWithKeyValues:obj];
         [countryArr addObject:countryM];
       
    }];
    return countryArr;
}

+ (NSMutableArray *)getAllCountryCode {
    __block NSMutableArray *countryArr = [NSMutableArray array];
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryCodeList" ofType:@"json"]];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         CountryModel *countryM = [CountryModel getObjectWithKeyValues:obj];
         [countryArr addObject:countryM];
       
    }];
    return countryArr;
}

+ (NSString *)removeCodeContain:(NSString *)originNum {
    __block NSString *resultNum = originNum;
    NSArray *allCountry = [ChooseCountryUtil getAllCountryCode];
    [allCountry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CountryModel *countryM = obj;
        if ([originNum containsString:countryM.dial_code]) {
            NSMutableString *muStr = [NSMutableString stringWithString:originNum];
            resultNum = [muStr stringByReplacingOccurrencesOfString:countryM.dial_code withString:@""];
            *stop = YES;
        }
    }];
    
    return resultNum;
}

@end
