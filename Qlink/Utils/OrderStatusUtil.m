//
//  OrderStatusUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/24.
//  Copyright © 2019 pan. All rights reserved.
//

#import "OrderStatusUtil.h"

@implementation OrderStatusUtil

+ (NSString *)getStatusStr:(NSString *)_status {
    NSString *statusStr = @"";
    if ([_status isEqualToString:ORDER_STATUS_OVERTIME]) {
        statusStr = @"Closed";
    } else if ([_status isEqualToString:ORDER_STATUS_NORMAL]) {
        statusStr = @"Active";
    } else if ([_status isEqualToString:ORDER_STATUS_QGAS_TO_PLATFORM]) {
        statusStr = @"Waiting for Buyer's payment";
    } else if ([_status isEqualToString:ORDER_STATUS_USDT_PAID] || [_status isEqualToString:ORDER_STATUS_USDT_PENDING]) {
        statusStr = @"Waiting for Seller's confirmation";
    } else if ([_status isEqualToString:ORDER_STATUS_NEW]) {
        statusStr = @"Active";
    } else if ([_status isEqualToString:ORDER_STATUS_QGAS_PAID]) {
        statusStr = @"Successful Deal";
    } else if ([_status isEqualToString:ORDER_STATUS_CANCEL]) {
        statusStr = @"Revoked";
    }
    
    return statusStr;
}

+ (UIColor *)getStatusColor:(NSString *)_status {
    UIColor *color = nil;
    if ([_status isEqualToString:ORDER_STATUS_OVERTIME]) {
        color = UIColorFromRGB(0x21BEB5);
    } else if ([_status isEqualToString:ORDER_STATUS_NORMAL]) {
        color = MAIN_BLUE_COLOR;
    } else if ([_status isEqualToString:ORDER_STATUS_QGAS_TO_PLATFORM]) {
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
