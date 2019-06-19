//
//  QLCTokensModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/6/4.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLCTokenInfoModel : BBaseModel

@property (nonatomic, strong) NSString *tokenId;//": "45dd217cd9ff89f7b64ceda4886cc68dde9dfa47a8a422d165e2ce6f9a834fad",
@property (nonatomic, strong) NSString *tokenName;//": "QLC",
@property (nonatomic, strong) NSString *tokenSymbol;//": "QLC",
@property (nonatomic, strong) NSNumber *totalSupply;//": 60000000000000000,
@property (nonatomic, strong) NSNumber *decimals;//": 8,
@property (nonatomic, strong) NSString *owner;//": "qlc_1t1uynkmrs597z4ns6ymppwt65baksgdjy1dnw483ubzm97oayyo38ertg44",
@property (nonatomic, strong) NSNumber *pledgeAmount;//": 0,
@property (nonatomic, strong) NSNumber *withdrawTime;//": 0

@end

NS_ASSUME_NONNULL_END
