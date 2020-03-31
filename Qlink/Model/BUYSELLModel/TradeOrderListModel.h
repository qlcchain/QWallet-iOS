//
//  TradeOrderListModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/17.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeOrderListModel : BBaseModel

@property (nonatomic, strong) NSString *buyerId;// = 7060628a65e4450690976bf56c127787;
@property (nonatomic, strong) NSString *createDate;// = "2019-07-16 18:47:09";
@property (nonatomic, strong) NSString *entrustOrderId;// = f71e12acd7ef4765ae1399213719f982;
@property (nonatomic, strong) NSString *head;// = "/data/dapp/head/cd67f44e4b8a428e8660356e9463e693.jpg";
@property (nonatomic, strong) NSString *ID;// = fa1db0d9493240b78c9305236ee864f7;
@property (nonatomic, strong) NSString *nickname;// = hzp;
@property (nonatomic, strong) NSNumber *qgasAmount;// = 100;
@property (nonatomic, strong) NSString *sellerId;// = 61be9c09c0784827af303005f983c705;
@property (nonatomic, strong) NSString *status;// = OVERTIME;
@property (nonatomic, strong) NSString *unitPrice;// = "0.001";
@property (nonatomic, strong) NSString *usdtAmount;// = "0.1";
@property (nonatomic, strong) NSString *appealStatus;
@property (nonatomic, strong) NSString *payToken;// = QLC;
@property (nonatomic, strong) NSString *payTokenChain;// = "NEO_CHAIN";
@property (nonatomic, strong) NSString *tradeToken;// = QGAS;
@property (nonatomic, strong) NSString *tradeTokenChain;// = "QLC_CHAIN";

@property (nonatomic, strong) NSString *showNickName;

@end

NS_ASSUME_NONNULL_END
