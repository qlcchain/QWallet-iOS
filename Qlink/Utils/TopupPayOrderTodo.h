//
//  TopupPayOrderHelper.h
//  Qlink
//
//  Created by Jelly Foo on 2019/10/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *TopupPayOrderLocal_Key = @"TopupPayOrderLocal_Key";

@interface TopupPayOrderParamsModel : BBaseModel

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *p2pId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *areaCode;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *payTokenId;

@end

@interface TopupPayOrderTodo : NSObject

+ (instancetype)shareInstance;
- (void)checkLocalPayOrder;
- (void)savePayOrder:(TopupPayOrderParamsModel *)model;
- (void)handlerPayOrderSuccess:(TopupPayOrderParamsModel *)model;
- (void)cleanPayOrder;

@end

NS_ASSUME_NONNULL_END
