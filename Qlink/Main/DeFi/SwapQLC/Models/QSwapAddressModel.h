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

@end

NS_ASSUME_NONNULL_END
