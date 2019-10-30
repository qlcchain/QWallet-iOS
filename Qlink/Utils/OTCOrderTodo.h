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

static NSString *OTCOrderLocal_Key = @"OTCOrderLocal_Key";

typedef NS_ENUM(NSInteger, OTCORderTodoType) {
    OTCORderTodoType_Entrust_Buy = 1,
    OTCORderTodoType_Entrust_Sell = 2,
    OTCORderTodoType_Deal_Buy = 3,
    OTCORderTodoType_Deal_Sell = 4
};

@interface OTCOrderParamsModel : BBaseModel

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *p2pId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *areaCode;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *payTokenId;

@end

@interface OTCOrderTodo : NSObject

+ (instancetype)shareInstance;
- (void)checkLocalPayOrder;
- (void)savePayOrder:(OTCOrderParamsModel *)model;
- (void)handlerPayOrderSuccess:(OTCOrderParamsModel *)model;
- (void)cleanPayOrder;

@end

NS_ASSUME_NONNULL_END
