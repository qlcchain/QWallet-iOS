//
//  EOSSymbolModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/4.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EOSSymbolModel : BBaseModel

@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSNumber * balance;

- (NSString *)getTokenNum;
- (NSString *)getPrice:(NSArray *)tokenPriceArr;

@end

NS_ASSUME_NONNULL_END
