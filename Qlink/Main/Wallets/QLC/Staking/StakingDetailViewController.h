//
//  StakingDetailViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class PledgeInfoByBeneficialModel;

@interface StakingDetailViewController : QBaseViewController

@property (nonatomic, strong) PledgeInfoByBeneficialModel *inputPledgeM;

@end

NS_ASSUME_NONNULL_END
