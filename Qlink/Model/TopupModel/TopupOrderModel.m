//
//  TopupOrderModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupOrderModel.h"
#import "GlobalConstants.h"

@implementation TopupOrderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSString *)getStatusString {
    NSString *str = @"";
    if ([_status isEqualToString:Topup_Order_Status_New]) {
        str = kLang(@"waiting_for_qgas_to_arrive");
    } else if ([_status isEqualToString:Topup_Order_Status_QGAS_PAID]) {
        str = kLang(@"no_phone_bill_paid");
    } else if ([_status isEqualToString:Topup_Order_Status_RECHARGE]) {
        str = kLang(@"waiting_for_the_bill");
    } else if ([_status isEqualToString:Topup_Order_Status_SUCCESS]) {
        str = kLang(@"phone_charge_successfully_charged");
    } else if ([_status isEqualToString:Topup_Order_Status_FAIL]) {
        str = kLang(@"phone_charge_failed");
    } else if ([_status isEqualToString:Topup_Order_Status_ERROR]) {
        str = kLang(@"qgas_parsing_failed");
    } else if ([_status isEqualToString:Topup_Order_Status_QGAS_RETURNED]) {
        str = kLang(@"phone_charge_recharge_failed_qgas_has_been_returned");
    }
    return str;
}

- (UIColor *)getStatusColor {
    UIColor *color = UIColorFromRGB(0x01B5AB);
    if ([_status isEqualToString:Topup_Order_Status_New]) {
        color = UIColorFromRGB(0x108EE9);
    } else if ([_status isEqualToString:Topup_Order_Status_QGAS_PAID]) {
        color = UIColorFromRGB(0xFF3669);
    } else if ([_status isEqualToString:Topup_Order_Status_RECHARGE]) {
        color = UIColorFromRGB(0x108EE9);
    } else if ([_status isEqualToString:Topup_Order_Status_SUCCESS]) {
        color = UIColorFromRGB(0x01B5AB);
    } else if ([_status isEqualToString:Topup_Order_Status_FAIL]) {
        color = UIColorFromRGB(0xFF3669);
    } else if ([_status isEqualToString:Topup_Order_Status_ERROR]) {
        color = UIColorFromRGB(0xFF3669);
    } else if ([_status isEqualToString:Topup_Order_Status_QGAS_RETURNED]) {
        color = UIColorFromRGB(0xFF3669);
    }
    return color;
}

@end
