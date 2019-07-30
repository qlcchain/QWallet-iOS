//
//  FinanceHistoryModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FinanceHistoryModel.h"

@implementation FinanceHistoryModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID": @"id"
             };
}

@end
