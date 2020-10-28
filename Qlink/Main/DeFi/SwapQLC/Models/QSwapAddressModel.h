//
//  QSwapAddressModel.h
//  Qlink
//
//  Created by 旷自辉 on 2020/8/31.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSwapAddressModel : BBaseModel

+ (QSwapAddressModel *)getShareObject;

/// eth 地址
@property (nonatomic, strong) NSString *ethAddress;

/// eth 合约地址
@property (nonatomic, strong) NSString *ethContract;

/// neo 地址
@property (nonatomic, strong) NSString *neoAddress;

/// neo 合约地址
@property (nonatomic, strong) NSString *neoContract;
/// eth 地址余额
@property (nonatomic, strong) NSString *ethBalance;
/// neo 地址余额
@property (nonatomic, strong) NSString *neoBalance;
// erc-20 -> nep 赎回限制 yes 为不能赎
@property (nonatomic, assign) BOOL withdrawLimit;
// neo -> erc20 最小抵压数量
@property (nonatomic, strong) NSString *minDepositAmount;
// erc20 -> nep 最小抵压数量
@property (nonatomic, strong) NSString *minWithdrawAmount;

@end

NS_ASSUME_NONNULL_END
