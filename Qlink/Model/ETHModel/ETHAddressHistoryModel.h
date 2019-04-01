//
//  ETHAddressHistoryModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/8.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"
#import "ETHAddressInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Operation : BBaseModel

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *transactionHash;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) TokenInfo * tokenInfo;
@property (nonatomic, strong) NSNumber *timestamp;

- (NSString *)getTokenNum;

@end

@interface ETHAddressHistoryModel : BBaseModel

@property (nonatomic, strong) NSArray * operations;

@end

NS_ASSUME_NONNULL_END
