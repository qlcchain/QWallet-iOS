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


static NSString *OTCOrder_Entrust_Buy_Key = @"OTCOrder_Entrust_Buy_Key";
static NSString *OTCOrder_Entrust_Sell_Key = @"OTCOrder_Entrust_Sell_Key";
static NSString *OTCOrder_Buysell_Sell_Key = @"OTCOrder_Buysell_Sell_Key";
static NSString *OTCOrder_Buysell_Buy_Confirm_Key = @"OTCOrder_Buysell_Buy_Confirm_Key";

typedef NS_ENUM(NSInteger, OTCORderTodoType) {
    OTCORderTodoType_Entrust_Buy = 1,
    OTCORderTodoType_Entrust_Sell = 2,
    OTCORderTodoType_Deal_Buy = 3,
    OTCORderTodoType_Deal_Sell = 4
};

@interface OTCOrder_Entrust_Buy_ParamsModel : BBaseModel

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *unitPrice;
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSString *minAmount;
@property (nonatomic, strong) NSString *maxAmount;
@property (nonatomic, strong) NSString *pairsId;
@property (nonatomic, strong) NSString *qgasAddress;
@property (nonatomic, strong) NSString *fromAddress;
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *timestamp;

@end

@interface OTCOrder_Entrust_Sell_ParamsModel : BBaseModel

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *unitPrice;
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSString *minAmount;
@property (nonatomic, strong) NSString *maxAmount;
@property (nonatomic, strong) NSString *pairsId;
@property (nonatomic, strong) NSString *usdtAddress;
@property (nonatomic, strong) NSString *fromAddress;
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *timestamp;

@end

@interface OTCOrder_Buysell_Sell_ParamsModel : BBaseModel

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *entrustOrderId;
@property (nonatomic, strong) NSString *usdtAmount;
@property (nonatomic, strong) NSString *qgasAmount;
@property (nonatomic, strong) NSString *usdtToAddress;
@property (nonatomic, strong) NSString *fromAddress;
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *timestamp;

@end

@interface OTCOrder_Buysell_Buy_Confirm_ParamsModel : BBaseModel

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *tradeOrderId;
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *timestamp;

@end



@interface OTCOrderTodo : NSObject

+ (instancetype)shareInstance;


#pragma mark - 委托单--买家
- (void)cleanPayOrder_Entrust_Buy;
- (void)checkLocalPayOrder_Entrust_Buy;
- (void)savePayOrder_Entrust_Buy:(OTCOrder_Entrust_Buy_ParamsModel *)model;
- (void)handlerPayOrder_Entrust_Buy_Success:(OTCOrder_Entrust_Buy_ParamsModel *)model;
- (void)requestEntrust_order_buy:(OTCOrder_Entrust_Buy_ParamsModel *)model;


#pragma mark - 委托单--卖家
- (void)cleanPayOrder_Entrust_Sell;
- (void)checkLocalPayOrder_Entrust_Sell;
- (void)savePayOrder_Entrust_Sell:(OTCOrder_Entrust_Sell_ParamsModel *)model;
- (void)handlerPayOrder_Entrust_Sell_Success:(OTCOrder_Entrust_Sell_ParamsModel *)model;
- (void)requestEntrust_order_sell:(OTCOrder_Entrust_Sell_ParamsModel *)model;


#pragma mark - 买卖单--卖家
- (void)cleanPayOrder_Buysell_Sell;
- (void)checkLocalPayOrder_Buysell_Sell;
- (void)savePayOrder_Buysell_Sell:(OTCOrder_Buysell_Sell_ParamsModel *)model;
- (void)handlerPayOrder_Buysell_Sell_Success:(OTCOrder_Buysell_Sell_ParamsModel *)model;
- (void)requestTrade_sell_order:(OTCOrder_Buysell_Sell_ParamsModel *)model;


#pragma mark - 买卖单--买家确认
- (void)checkLocalPayOrder_Buysell_Buy_Confirm;
- (void)savePayOrder_Buysell_Buy_Confirm:(OTCOrder_Buysell_Buy_Confirm_ParamsModel *)model;
- (void)handlerPayOrder_Buysell_Buy_Confirm_Success:(OTCOrder_Buysell_Buy_Confirm_ParamsModel *)model;
- (void)cleanPayOrder_Buysell_Buy_Confirm;

@end

NS_ASSUME_NONNULL_END
