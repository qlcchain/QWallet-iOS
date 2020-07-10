//
//  EntrustOrderListModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EntrustOrderListModel : BBaseModel

@property (nonatomic, strong) NSString *head;// = "/data/dapp/head/cd67f44e4b8a428e8660356e9463e693.jpg";
@property (nonatomic, strong) NSString *ID; // = f71e12acd7ef4765ae1399213719f982;
@property (nonatomic, strong) NSNumber *maxAmount; // = 1000;
@property (nonatomic, strong) NSNumber *minAmount;// = 100;
@property (nonatomic, strong) NSString *nickname;// = 18670819116;
@property (nonatomic, strong) NSNumber *otcTimes;// = 0;
@property (nonatomic, strong) NSString *status;// = NORMAL;
//@property (nonatomic, strong) NSNumber *totalAmount;// = 1000;
@property (nonatomic) double totalAmount;
@property (nonatomic, strong) NSString *totalAmount_str;
@property (nonatomic, strong) NSString *type;// = BUY;
//@property (nonatomic, strong) NSString *unitPrice;// = "0.001";
@property (nonatomic) double unitPrice;
@property (nonatomic, strong) NSString *unitPrice_str;
@property (nonatomic, strong) NSString *orderTime;
//@property (nonatomic, strong) NSNumber *lockingAmount;
@property (nonatomic) double lockingAmount;
@property (nonatomic, strong) NSString *lockingAmount_str;
//@property (nonatomic, strong) NSNumber *completeAmount;
@property (nonatomic) double completeAmount;
@property (nonatomic, strong) NSString *completeAmount_str;
@property (nonatomic, strong) NSString *payToken;
@property (nonatomic, strong) NSString *payTokenChain;
@property (nonatomic, strong) NSString *tradeToken;
@property (nonatomic, strong) NSString *tradeTokenChain;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *isBurnQgasOrder;

@property (nonatomic, strong) NSString *showNickName;
@property (nonatomic, strong) NSString *payTokenLogo;
@property (nonatomic, strong) NSString *tradeTokenLogo;

@end

NS_ASSUME_NONNULL_END
