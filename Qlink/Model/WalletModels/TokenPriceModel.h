//
//  TokenPriceModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/8.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TokenPriceModel : BBaseModel

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *coin;

@end

NS_ASSUME_NONNULL_END
