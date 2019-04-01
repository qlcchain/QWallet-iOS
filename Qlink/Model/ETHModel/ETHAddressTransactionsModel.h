//
//  ETHAddressTransactionsModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/15.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETHAddressTransactionsModel : BBaseModel

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *Hash;
@property (nonatomic, strong) NSString *input;
@property (nonatomic, strong) NSNumber *success;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSNumber *timestamp;

- (NSString *)getTokenNum;
- (NSString *)getSymbol;

@end

NS_ASSUME_NONNULL_END
