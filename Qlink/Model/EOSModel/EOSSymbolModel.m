//
//  EOSSymbolModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/4.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSSymbolModel.h"
#import "NSString+RemoveZero.h"
#import "TokenPriceModel.h"

@implementation EOSSymbolModel

- (NSString *)getTokenNum {
    NSString *num = [[NSString stringWithFormat:@"%@",self.balance] removeFloatAllZero];
    return num;
}

- (NSString *)getPrice:(NSArray *)tokenPriceArr {
    __block NSString *price = @"";
    NSString *num = [self getTokenNum];
    [tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TokenPriceModel *tempM = obj;
        if ([tempM.symbol isEqualToString:self.symbol]) {
            NSNumber *usdNum = @([num doubleValue]*[tempM.price doubleValue]);
            price = [[NSString stringWithFormat:@"%@",usdNum] removeFloatAllZero];
            *stop = YES;
        }
    }];
    return price;
}

@end
