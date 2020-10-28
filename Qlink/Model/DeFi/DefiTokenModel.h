//
//  DefiTokenModel.h
//  Qlink
//
//  Created by 旷自辉 on 2020/7/8.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DefiTokenModel : BBaseModel

@property (nonatomic, strong) NSString * symbol;

@property (nonatomic, strong) NSString *marketCap;

@property (nonatomic, strong) NSString *chain;

@property (nonatomic, strong) NSString *website;

@property (nonatomic, strong) NSString *percentChange24h;

@property (nonatomic, strong) NSString *percentChange7d;

@property (nonatomic, strong) NSString *totalSupply;

@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSString *circulatingSupply;

@end

NS_ASSUME_NONNULL_END
