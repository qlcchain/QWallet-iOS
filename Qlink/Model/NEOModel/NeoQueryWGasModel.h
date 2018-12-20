//
//  NeoQueryWGasModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/15.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NeoQueryWGasModel : BBaseModel

@property (nonatomic, strong) NSNumber *winqGas;

- (NSString *)getNum;

@end

NS_ASSUME_NONNULL_END
