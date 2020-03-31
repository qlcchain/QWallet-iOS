//
//  TopupProductModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupProductModel.h"
#import "TopupDeductionTokenModel.h"
#import "RLArithmetic.h"
#import "NSString+RemoveZero.h"
#import "GroupBuyListModel.h"

@implementation TopupProductModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Description" : @"description", @"ID" : @"id"};
}

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"items" : @"GroupBuyListItemModel"};
}

+ (NSString *)getAmountShow:(TopupProductModel *)productM tokenM:(TopupDeductionTokenModel *)tokenM {
    NSString *fait1Str = productM.discount.mul(productM.payFiatAmount);
//    NSString *faitMoneyStr = [productM.discount.mul(productM.payFiatAmount) showfloatStr:4];
    NSString *deduction1Str = productM.payFiatAmount.mul(productM.qgasDiscount);
    NSNumber *deductionTokenPrice = @(1);
    if ([productM.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = tokenM.price;
    } else if ([productM.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = tokenM.usdPrice;
    }
    NSString *deductionAmountStr = [deduction1Str.div(deductionTokenPrice) showfloatStr:3];
    NSString *deductionSymbolStr = tokenM.symbol;
    NSString *addStr = @"+";
    NSString *topupAmountShowStr = @"";
    NSString *payTokenSymbol = @"";
    if ([productM.payWay isEqualToString:@"TOKEN"]) {
        payTokenSymbol = productM.payTokenSymbol?:@"";
        NSNumber *payTokenPrice = [productM.payFiat isEqualToString:@"CNY"]?productM.payTokenCnyPrice:[productM.payFiat isEqualToString:@"USD"]?productM.payTokenUsdPrice:@(0);
        NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",payAmountStr,payTokenSymbol,addStr,deductionAmountStr,deductionSymbolStr];
    }
    
    return topupAmountShowStr;
}

#pragma mark - 团购
+ (NSString *)getAmountShow:(TopupProductModel *)productM tokenM:(TopupDeductionTokenModel *)tokenM groupDiscount:(NSString *)groupDiscount {
    NSString *fait1Str = productM.payFiatAmount.mul(groupDiscount);
//    NSString *faitMoneyStr = [productM.discount.mul(productM.payFiatAmount) showfloatStr:4];
    NSString *deduction1Str = productM.payFiatAmount.mul(productM.qgasDiscount).mul(groupDiscount);
    NSNumber *deductionTokenPrice = @(1);
    if ([productM.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = tokenM.price;
    } else if ([productM.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = tokenM.usdPrice;
    }
    NSString *deductionAmountStr = [deduction1Str.div(deductionTokenPrice) showfloatStr:3];
    NSString *deductionSymbolStr = tokenM.symbol;
    NSString *addStr = @"+";
    NSString *topupAmountShowStr = @"";
    NSString *payTokenSymbol = @"";
    if ([productM.payWay isEqualToString:@"TOKEN"]) {
        payTokenSymbol = productM.payTokenSymbol?:@"";
        NSNumber *payTokenPrice = [productM.payFiat isEqualToString:@"CNY"]?productM.payTokenCnyPrice:[productM.payFiat isEqualToString:@"USD"]?productM.payTokenUsdPrice:@(0);
        NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
        topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",payAmountStr,payTokenSymbol,addStr,deductionAmountStr,deductionSymbolStr];
    }
    
    return topupAmountShowStr;
}

- (NSString *)orderTimes {
    NSString *result = _orderTimes;
    if ([_orderTimes integerValue] <= 100) {
        result = @"100+";
    }
    return result;
}

- (TopupProductModel *)v2ToV3 {
    TopupProductModel *modelV3 = [TopupProductModel getObjectWithKeyValues:self.mj_keyValues];
    modelV3.localFiatAmount = self.localFaitMoney;
    modelV3.payFiatAmount = self.payTokenMoney;
    return modelV3;
}

@end
