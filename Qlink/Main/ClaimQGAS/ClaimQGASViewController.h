//
//  BuySellDetailViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ClaimQGASType) {
    ClaimQGASTypeDailyEarnings = 0,
    ClaimQGASTypeReferralRewards,
};

@interface ClaimQGASViewController : QBaseViewController

@property (nonatomic, strong) NSString *inputCanClaimAmount;
@property (nonatomic) ClaimQGASType claimQGASType;

@end

NS_ASSUME_NONNULL_END
