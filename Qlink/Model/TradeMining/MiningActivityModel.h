//
//  MiningActivityModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/11/14.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MiningActivityModel : BBaseModel

@property (nonatomic, strong) NSString *Description;// = "每日交易挖矿得奖励, 每日结算";
@property (nonatomic, strong) NSString *DescriptionEn;// = "每日交易挖矿得奖励, 每日结算";
@property (nonatomic, strong) NSString *endTime;// = "2019-11-22 23:59:59";
@property (nonatomic, strong) NSString *ID;// = 5ae726f14199460086cced309f76b57y;
@property (nonatomic, strong) NSString *imgPath;// = "";
@property (nonatomic, strong) NSString *name;// = "交易挖矿";
@property (nonatomic, strong) NSString *nameEn;// = "交易挖矿";
@property (nonatomic, strong) NSString *rewardToken;// = QLC;
@property (nonatomic, strong) NSString *startTime;// = "2019-11-13 00:00:00";
@property (nonatomic, strong) NSString *totalRewardAmount;// = 100000;
@property (nonatomic, strong) NSString *tradeToken;// = QGAS;

@end

NS_ASSUME_NONNULL_END
