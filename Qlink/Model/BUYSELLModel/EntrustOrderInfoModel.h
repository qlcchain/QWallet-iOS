//
//  EntrustOrderInfoModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EntrustOrderInfoModel : BBaseModel

@property (nonatomic, strong) NSNumber *completeAmount;// = 0;
@property (nonatomic, strong) NSString *head;// = "/data/dapp/head/cd67f44e4b8a428e8660356e9463e693.jpg";
@property (nonatomic, strong) NSString *ID;// = f71e12acd7ef4765ae1399213719f982;
@property (nonatomic, strong) NSNumber *lockingAmount;// = 0;
@property (nonatomic, strong) NSNumber *maxAmount;// = 1000;
@property (nonatomic, strong) NSNumber *minAmount;// = 100;
@property (nonatomic, strong) NSString *nickname;// = 18670819116;
@property (nonatomic, strong) NSString *orderTime;// = "2019-07-15 16:33:32";
@property (nonatomic, strong) NSNumber *otcTimes;// = 0;
@property (nonatomic, strong) NSString *qgasAddress;// 买卖币接收地址[委托买入]
@property (nonatomic, strong) NSString *payToken;// = QLC;
@property (nonatomic, strong) NSString *payTokenChain;// = "NEO_CHAIN";
@property (nonatomic, strong) NSString *status;// = NORMAL;
@property (nonatomic, strong) NSNumber *totalAmount;// = 1000;
@property (nonatomic, strong) NSString *type;// = BUY;
@property (nonatomic, strong) NSString *unitPrice;// = "0.001";
@property (nonatomic, strong) NSString *usdtAddress;// 支付币接收地址[委托卖出]
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *pairsId; // 交易对ID
@property (nonatomic, strong) NSString *tradeToken;// = QGAS;
@property (nonatomic, strong) NSString *tradeTokenChain;// = "QLC_CHAIN";

@end

NS_ASSUME_NONNULL_END
