//
//  TopupOrderModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupOrderModel.h"
#import "GlobalConstants.h"
#import <QLCFramework/QLCFramework.h>
#import "NeoTransferUtil.h"
#import "ETHWalletManage.h"
#import "NSString+RemoveZero.h"

@implementation TopupOrderProductModel

@end

@implementation TopupOrderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id", @"Hash":@"hash"};
}

- (NSString *)getStatusString:(TopupPayType)payType {
    NSString *str = @"";
    if ([_status isEqualToString:Topup_Order_Status_New]) {
        if (payType == TopupPayTypeNormal) {
            str = [NSString stringWithFormat:kLang(@"waiting_for_to_arrive"),_symbol];
        } else if (payType == TopupPayTypeGroupBuy) {
            str = [NSString stringWithFormat:kLang(@"waiting_for_to_arrive"),_deductionToken];
        }
    } else if ([_status isEqualToString:Topup_Order_Status_QGAS_PAID]) {
        if ([_payWay isEqualToString:@"FIAT"]) {
            str = kLang(@"no_phone_bill_paid");
        } else if ([_payWay isEqualToString:@"TOKEN"]) {
            if (_payTokenInTxid == nil || [_payTokenInTxid isEmptyString]) {
                str = kLang(@"no_phone_bill_paid");
            } else {
                str = kLang(@"please_wait_for_confirmation");
            }
        }
    } else if ([_status isEqualToString:Topup_Order_Status_RECHARGE]) {
        str = kLang(@"waiting_for_the_bill");
    } else if ([_status isEqualToString:Topup_Order_Status_SUCCESS]) {
        str = kLang(@"phone_charge_successfully_charged");
    } else if ([_status isEqualToString:Topup_Order_Status_FAIL]) {
        str = kLang(@"phone_charge_failed");
    } else if ([_status isEqualToString:Topup_Order_Status_ERROR]) {
        str = kLang(@"qgas_parsing_failed");
    } else if ([_status isEqualToString:Topup_Order_Status_QGAS_RETURNED]) {
        str = [NSString stringWithFormat:kLang(@"phone_charge_recharge_failed_has_been_returned"),_symbol];
    } else if ([_status isEqualToString:Topup_Order_Status_Pay_TOKEN_PAID]) {
        str = kLang(@"pay_token_paid");
    } else if ([_status isEqualToString:Topup_Order_Status_DEDUCTION_TXID_ERROR]) {
        str = kLang(@"deduction_txid_error");
    } else if ([_status isEqualToString:Topup_Order_Status_PAY_TXID_ERROR]) {
        str = kLang(@"pay_txid_error");
    } else if ([_status isEqualToString:Topup_Order_Status_PAY_TOKEN_RETURNED]) {
        str = kLang(@"pay_token_returned");
    } else if ([_status isEqualToString:Topup_Order_Status_CANCEL]) {
        str = kLang(@"cancelled");
    } else if ([_status isEqualToString:Topup_Order_Status_DEDUCTION_TOKEN_PAID]) {
//        if ([_payWay isEqualToString:@"FIAT"]) {
//            str = kLang(@"no_phone_bill_paid");
//        } else if ([_payWay isEqualToString:@"TOKEN"]) {
            if (_payTokenInTxid == nil || [_payTokenInTxid isEmptyString]) {
                str = kLang(@"no_phone_bill_paid");
            } else {
                str = kLang(@"please_wait_for_confirmation");
            }
//        }
    } else if ([_status isEqualToString:Topup_Order_Status_TIME_OUT]) {
        str = kLang(@"time_out");
    } else if ([_status isEqualToString:Topup_Order_Status_TIME_OUT_DOWN]) {
        str = kLang(@"time_out_down");
    } else if ([_status isEqualToString:Topup_Order_Status_ORDERED]) {
        str = kLang(@"ordered");
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
    } else if ([_status isEqualToString:Topup_Order_Status_Pay_TOKEN_PAID]) {
       color = UIColorFromRGB(0xFF3669);
   } else if ([_status isEqualToString:Topup_Order_Status_DEDUCTION_TXID_ERROR]) {
       color = UIColorFromRGB(0xFF3669);
   } else if ([_status isEqualToString:Topup_Order_Status_PAY_TXID_ERROR]) {
       color = UIColorFromRGB(0xFF3669);
   } else if ([_status isEqualToString:Topup_Order_Status_PAY_TOKEN_RETURNED]) {
       color = UIColorFromRGB(0xFF3669);
   } else if ([_status isEqualToString:Topup_Order_Status_CANCEL]) {
      color = UIColorFromRGB(0xFF3669);
  } else if ([_status isEqualToString:Topup_Order_Status_DEDUCTION_TOKEN_PAID]) {
     color = UIColorFromRGB(0xFF3669);
 } else if ([_status isEqualToString:Topup_Order_Status_TIME_OUT]) {
       color = UIColorFromRGB(0xFF3669);
   } else if ([_status isEqualToString:Topup_Order_Status_TIME_OUT_DOWN]) {
       color = UIColorFromRGB(0xFF3669);
   } else if ([_status isEqualToString:Topup_Order_Status_ORDERED]) {
      color = UIColorFromRGB(0xFF3669);
  }
    return color;
}

+ (BOOL)checkPayTokenChainServerAddressIsEmpty:(TopupOrderModel *)model {
    BOOL addressEmpty = NO;
    if ([model.payTokenChain isEqualToString:QLC_Chain]) {
        NSString *address = [QLCWalletManage shareInstance].qlcMainAddress;
        addressEmpty = [address isEmptyString]?YES:NO;
    } else if ([model.payTokenChain isEqualToString:NEO_Chain]) {
        NSString *address = [NeoTransferUtil getShareObject].neoMainAddress;
        addressEmpty = [address isEmptyString]?YES:NO;
    } else if ([model.payTokenChain isEqualToString:ETH_Chain]) {
        NSString *address = [ETHWalletManage shareInstance].ethMainAddress;
        addressEmpty = [address isEmptyString]?YES:NO;
    }
    
    return addressEmpty;
}

+ (NSString *)getPayTokenChainServerAddress:(TopupOrderModel *)model {
    NSString *address = @"";
    if ([model.payTokenChain isEqualToString:QLC_Chain]) {
        address = [QLCWalletManage shareInstance].qlcMainAddress;
    } else if ([model.payTokenChain isEqualToString:NEO_Chain]) {
        address = [NeoTransferUtil getShareObject].neoMainAddress;
    } else if ([model.payTokenChain isEqualToString:ETH_Chain]) {
        address = [ETHWalletManage shareInstance].ethMainAddress;
    }
    
    return address;
}

- (NSString *)deductionTokenAmount_str {
    return [NSString doubleToString:_deductionTokenAmount];
}

- (NSString *)payTokenAmount_str {
    return [NSString doubleToString:_payTokenAmount];
}

- (NSString *)qgasAmount_str {
    return [NSString doubleToString:_qgasAmount];
}

@end
