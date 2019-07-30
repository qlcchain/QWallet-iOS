//
//  FinanceOrderListModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/12.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FinanceOrderListModel.h"

@implementation FinanceOrderModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID": @"id"
             };
}

@end

@implementation FinanceOrderListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"orderList" : @"FinanceOrderModel"};
}

@end
