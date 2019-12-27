//
//  TopupOrderModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const Topup_Order_Status_New = @"NEW"; // QGAS未到账
static NSString *const Topup_Order_Status_QGAS_PAID = @"QGAS_PAID"; // 已支付QGAS，未支付法币
static NSString *const Topup_Order_Status_Pay_TOKEN_PAID = @"PAY_TOKEN_PAID"; // 已支付支付币(代币支付产品才有此状态)
static NSString *const Topup_Order_Status_RECHARGE = @"RECHARGE"; // 充值中（支付成功）
static NSString *const Topup_Order_Status_SUCCESS = @"SUCCESS"; // 充值成功（话费到账）
static NSString *const Topup_Order_Status_FAIL = @"FAIL"; // 充值失败（充值失败订单已退款取消）
static NSString *const Topup_Order_Status_DEDUCTION_TXID_ERROR = @"DEDUCTION_TXID_ERROR"; // 抵扣币解析失败
static NSString *const Topup_Order_Status_PAY_TXID_ERROR = @"PAY_TXID_ERROR"; // 支付币解析失败
static NSString *const Topup_Order_Status_CANCEL = @"CANCEL"; // 取消
static NSString *const Topup_Order_Status_ERROR = @"ERROR"; // QGAS解析失败
static NSString *const Topup_Order_Status_QGAS_RETURNED = @"QGAS_RETURNED"; // 已退回QGAS（充值失败）
static NSString *const Topup_Order_Status_PAY_TOKEN_RETURNED = @"PAY_TOKEN_RETURNED"; // 已退回支付币（代币支付产品才有此状态，先退QGAS，再退支付币）

@interface TopupOrderModel : BBaseModel

@property (nonatomic, strong) NSString *productIspEn; //" : "移动",
@property (nonatomic, strong) NSNumber *originalPrice; //" : 100,
@property (nonatomic, strong) NSNumber *discountPrice; //" : 95.00,
@property (nonatomic, strong) NSString *productCountryEn; //" : "中国",
@property (nonatomic, strong) NSString *productIsp; //" : "移动",
@property (nonatomic, strong) NSString *userId; //" : "949caa0a0d8b4f2c81dd1750e8e867de",
@property (nonatomic, strong) NSString *productName; //" : "广东移动",
@property (nonatomic, strong) NSString *number; //" : "20190925154534792577",
@property (nonatomic, strong) NSString *productProvinceEn; //" : "广东",
@property (nonatomic, strong) NSString *areaCode; //" : "+86",
@property (nonatomic, strong) NSString *phoneNumber; //" : "15919241111",
@property (nonatomic, strong) NSString *orderTime; //" : "2019-09-25 15:45:34",
@property (nonatomic, strong) NSString *productNameEn; //" : "广东移动",
@property (nonatomic, strong) NSString *productCountry; //" : "中国",
@property (nonatomic, strong) NSString *ID; //" : "0815c1b7b7f64111903b8ae58c600cd0",
@property (nonatomic, strong) NSString *productProvince; //" : "广东",
@property (nonatomic, strong) NSString *status; //" : "NEW"
@property (nonatomic, strong) NSNumber *qgasAmount;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *chain;
@property (nonatomic, strong) NSNumber *deductionPrice;
@property (nonatomic, strong) NSString *Hash;
@property (nonatomic, strong) NSNumber *payPrice;
@property (nonatomic, strong) NSString *payTokenInTxid;
@property (nonatomic, strong) NSNumber *payTokenAmount;
@property (nonatomic, strong) NSString *payWay;
@property (nonatomic, strong) NSString *payFiat;
@property (nonatomic, strong) NSString *payTokenHash;
@property (nonatomic, strong) NSString *payTokenSymbol;
@property (nonatomic, strong) NSString *payTokenChain;
@property (nonatomic, strong) NSString *localFiat;

@property (nonatomic, strong) NSString *expiredtime;
@property (nonatomic, strong) NSString *serialno;
@property (nonatomic, strong) NSString *passwd;
@property (nonatomic, strong) NSString *pin;

- (NSString *)getStatusString;
- (UIColor *)getStatusColor;
+ (BOOL)checkPayTokenChainServerAddressIsEmpty:(TopupOrderModel *)model;
+ (NSString *)getPayTokenChainServerAddress:(TopupOrderModel *)model;

@end

NS_ASSUME_NONNULL_END
