//
//  MiningRewardIndexModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/11/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MiningRewardIndexModel : BBaseModel

@property (nonatomic, strong) NSString *awardedTotal;// = 0;
@property (nonatomic, strong) NSString *noAwardTotal;// = "0.00078896";
@property (nonatomic, strong) NSArray *rewardRankings;//
@property (nonatomic, strong) NSString *totalFinish;// = 1;
@property (nonatomic, strong) NSString *totalRewardAmount;// = 100000;

@end

NS_ASSUME_NONNULL_END
