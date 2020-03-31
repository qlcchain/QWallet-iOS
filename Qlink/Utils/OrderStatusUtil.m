//
//  OrderStatusUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/24.
//  Copyright © 2019 pan. All rights reserved.
//

#import "OrderStatusUtil.h"
#import "GlobalConstants.h"

@implementation OrderStatusUtil

+ (NSString *)getStatusStr:(NSString *)_status {
    NSString *statusStr = @"";
    if ([_status isEqualToString:ORDER_STATUS_TRADE_TOKEN_PENDING]) { // 已转交易币 等待转成功
        statusStr = kLang(@"pending");
    } else if ([_status isEqualToString:ORDER_STATUS_OVERTIME]) {
        statusStr = kLang(@"closed");
    } else if ([_status isEqualToString:ORDER_STATUS_NORMAL]) {
        statusStr = kLang(@"active");
    } else if ([_status isEqualToString:ORDER_STATUS_QGAS_TO_PLATFORM]) {
        statusStr = kLang(@"waiting_for_buyer_payment");
    } else if ([_status isEqualToString:ORDER_STATUS_TXID_ERROR]) {
        statusStr = kLang(@"waiting_for_buyer_payment");
    } else if ([_status isEqualToString:ORDER_STATUS_USDT_PAID]) {
        statusStr = kLang(@"waiting_for_seller_confirmation");
    } else if ([_status isEqualToString:ORDER_STATUS_USDT_PENDING]) {
        statusStr = kLang(@"waiting_for_public_Chain_confirmation");
    } else if ([_status isEqualToString:ORDER_STATUS_NEW]) {
        statusStr = kLang(@"active");
    } else if ([_status isEqualToString:ORDER_STATUS_QGAS_PAID]) {
        statusStr = kLang(@"successful_deal");
    } else if ([_status isEqualToString:ORDER_STATUS_CANCEL]) {
        statusStr = kLang(@"revoked");
    }
    
    return statusStr;
}

+ (UIColor *)getStatusColor:(NSString *)_status {
    UIColor *color = nil;
    if ([_status isEqualToString:ORDER_STATUS_TRADE_TOKEN_PENDING]) { // 已转交易币 等待转成功
        color = MAIN_BLUE_COLOR;
    } else if ([_status isEqualToString:ORDER_STATUS_OVERTIME]) {
        color = UIColorFromRGB(0x21BEB5);
    } else if ([_status isEqualToString:ORDER_STATUS_NORMAL]) {
        color = MAIN_BLUE_COLOR;
    } else if ([_status isEqualToString:ORDER_STATUS_QGAS_TO_PLATFORM]) {
        color = MAIN_BLUE_COLOR;
    } else if ([_status isEqualToString:ORDER_STATUS_TXID_ERROR]) {
        color = MAIN_BLUE_COLOR;
   } else if ([_status isEqualToString:ORDER_STATUS_USDT_PAID] || [_status isEqualToString:ORDER_STATUS_USDT_PENDING]) {
        color = MAIN_BLUE_COLOR;
    } else if ([_status isEqualToString:ORDER_STATUS_NEW]) {
        color = MAIN_BLUE_COLOR;
    } else if ([_status isEqualToString:ORDER_STATUS_QGAS_PAID]) {
        color = UIColorFromRGB(0x01B5AB);
    } else if ([_status isEqualToString:ORDER_STATUS_CANCEL]) {
        color = UIColorFromRGB(0x909090);
    }
    
    return color;
}

@end
