//
//  ChooseCountryUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/10.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    VPNList,
    VPNRegister,
} ChooseCountryEntry;

@interface ChooseCountryUtil : NSObject

@property (nonatomic) ChooseCountryEntry entry;

+ (instancetype)shareInstance;
+ (NSString *)getContinentOfCountry:(NSString *)inputCountry;
+ (NSString *) getConutryNameWithCode:(NSString *) code;
@end
