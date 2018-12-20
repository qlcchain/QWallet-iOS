//
//  NEOAddressHistoryModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/13.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NEOAddressHistoryModel.h"
#import "NSString+RemoveZero.h"

@implementation NEOAddressHistoryModel

- (NSString *)getTokenNum {
    NSString *num = [[NSString stringWithFormat:@"%@",self.amount] removeFloatAllZero];
    return num;
}

@end
