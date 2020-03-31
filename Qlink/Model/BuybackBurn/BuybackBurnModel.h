//
//  BuybackBurnModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/2/28.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuybackBurnModel : BBaseModel

@property (nonatomic, strong) NSString *Description;// = "为节点招募提供动力，为QGas找到短期价值。";
@property (nonatomic, strong) NSString *DescriptionEn;// = "为节点招募提供动力，为QGas找到短期价值。";
@property (nonatomic, strong) NSString *endTime;// = "2020-03-07 23:59:59";
@property (nonatomic, strong) NSString *ID;// = 845b6779a7c84fa889c865bbfda897b9;
@property (nonatomic, strong) NSString *imgPath;// = "";
@property (nonatomic, strong) NSString *maxAmount;// = 1000;
@property (nonatomic, strong) NSString *minAmount;// = 1;
@property (nonatomic, strong) NSString *name;// = "QGas Buyback abd Burn Program";
@property (nonatomic, strong) NSString *nameEn;// = "QGas Buyback abd Burn Program";
@property (nonatomic, strong) NSString *payToken;// = QLC;
@property (nonatomic, strong) NSString *payTokenChain;// = "NEO_CHAIN";
@property (nonatomic, strong) NSString *qgasAmountTotal;// = 200000;
@property (nonatomic, strong) NSString *qgasReceiveAddress;// = "qlc_3fn7dsybngcf3ieoynyqox1xo8rx8haxh97tuq6f96erne7h844z7jt3x3h1";
@property (nonatomic, strong) NSString *sellQgasCap;// = 2;
@property (nonatomic, strong) NSString *startTime;// = "2020-02-27 00:00:00";
@property (nonatomic, strong) NSString *status;// = UP;
@property (nonatomic, strong) NSString *tradeToken;// = QGAS;
@property (nonatomic, strong) NSString *tradeTokenChain;// = "QLC_CHAIN";
//@property (nonatomic, strong) NSString *unitPrice;// = 2;
@property (nonatomic) double unitPrice;
@property (nonatomic, strong) NSString *unitPrice_str;

@end

NS_ASSUME_NONNULL_END
