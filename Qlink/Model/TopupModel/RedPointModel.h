//
//  RedPointModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/11/22.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedPointModel : BBaseModel

@property (nonatomic, strong) NSString *dailyIncomePoint; // 每日收益
@property (nonatomic, strong) NSString *invitePoint; // 推荐奖励
@property (nonatomic, strong) NSString *rewardTotal; // 挂单挖矿
@property (nonatomic, strong) NSString *gzbdFocusInterrupt; // 疫情活动-关注是否中断
@property (nonatomic, strong) NSString *gzbdPoint; // 疫情活动红点

@end

NS_ASSUME_NONNULL_END
