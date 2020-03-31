//
//  TopupPayOrderHelper.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "OTCOrderTodo.h"
#import <TMCache/TMCache.h>
#import "GlobalConstants.h"
#import "TxidBackUtil.h"

@implementation OTCOrder_Entrust_Buy_ParamsModel

@end

@implementation OTCOrder_Entrust_Sell_ParamsModel

@end

@implementation OTCOrder_Buysell_Sell_Txid_ParamsModel

@end

@implementation OTCOrder_Buysell_Buy_Confirm_ParamsModel

@end

@implementation OTCOrderTodo

+ (instancetype)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static OTCOrderTodo *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc]init];
    });
    return sharedObj;
}


#pragma mark - 委托单--买家
- (void)cleanPayOrder_Entrust_Buy {
    [[TMCache sharedCache] removeObjectForKey:OTCOrder_Entrust_Buy_Key];
}

- (void)checkLocalPayOrder_Entrust_Buy {
    kWeakSelf(self);
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Entrust_Buy_Key];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float timeOffset = 1;
        OTCOrder_Entrust_Buy_ParamsModel *model = obj;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((idx+1)*timeOffset * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestEntrust_order_buy:model];
        });
    }];
}

- (void)savePayOrder_Entrust_Buy:(OTCOrder_Entrust_Buy_ParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Entrust_Buy_Key];
    // 去重
    __block BOOL isExist = NO;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTCOrder_Entrust_Buy_ParamsModel *temp = obj;
        if ([temp.txid isEqualToString:model.txid]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (!isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        if (localArr) {
            [muArr addObjectsFromArray:localArr];
        }
        [muArr addObject:model];
        [[TMCache sharedCache] setObject:muArr forKey:OTCOrder_Entrust_Buy_Key];
    }
}

- (void)handlerPayOrder_Entrust_Buy_Success:(OTCOrder_Entrust_Buy_ParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Entrust_Buy_Key];
    __block NSInteger removeIdx = -1;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTCOrder_Entrust_Buy_ParamsModel *tempM = obj;
        if ([tempM.txid isEqualToString:model.txid]) {
            removeIdx = idx;
            *stop = YES;
        }
    }];
    if (removeIdx != -1) {
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:localArr];
        [muArr removeObjectAtIndex:removeIdx];
        [[TMCache sharedCache] setObject:muArr forKey:OTCOrder_Entrust_Buy_Key];
    }
}

- (void)requestEntrust_order_buy:(OTCOrder_Entrust_Buy_ParamsModel *)model {
    kWeakSelf(self);
    NSDictionary *params = [model mj_keyValues];
    NSString *timestamp = model.timestamp;
    [RequestService requestWithUrl6:entrust_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself handlerPayOrder_Entrust_Buy_Success:model];
        } else {
            // 上传txid备份
            TxidBackModel *txidBackM = [TxidBackModel new];
            txidBackM.txid = params[@"txid"];
            txidBackM.type = Txid_Backup_Type_ENTRUST_ORDER;
            txidBackM.platform = Platform_iOS;
            txidBackM.chain = @"";
            txidBackM.tokenName = @"";
            txidBackM.amount = @"";
            [TxidBackUtil requestSys_txid_backup:txidBackM completeBlock:^(BOOL success, NSString *msg) {
                if (success) {
                    [weakself handlerPayOrder_Entrust_Buy_Success:model];
                }
            }];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}


#pragma mark - 委托单--卖家
- (void)cleanPayOrder_Entrust_Sell {
    [[TMCache sharedCache] removeObjectForKey:OTCOrder_Entrust_Sell_Key];
}

- (void)checkLocalPayOrder_Entrust_Sell {
    kWeakSelf(self);
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Entrust_Sell_Key];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float timeOffset = 1;
        OTCOrder_Entrust_Sell_ParamsModel *model = obj;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((idx+1)*timeOffset * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestEntrust_order_sell:model];
        });
    }];
}

- (void)savePayOrder_Entrust_Sell:(OTCOrder_Entrust_Sell_ParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Entrust_Sell_Key];
    // 去重
    __block BOOL isExist = NO;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTCOrder_Entrust_Sell_ParamsModel *temp = obj;
        if ([temp.txid isEqualToString:model.txid]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (!isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        if (localArr) {
            [muArr addObjectsFromArray:localArr];
        }
        [muArr addObject:model];
        [[TMCache sharedCache] setObject:muArr forKey:OTCOrder_Entrust_Sell_Key];
    }
}

- (void)handlerPayOrder_Entrust_Sell_Success:(OTCOrder_Entrust_Sell_ParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Entrust_Sell_Key];
    __block NSInteger removeIdx = -1;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTCOrder_Entrust_Sell_ParamsModel *tempM = obj;
        if ([tempM.txid isEqualToString:model.txid]) {
            removeIdx = idx;
            *stop = YES;
        }
    }];
    if (removeIdx != -1) {
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:localArr];
        [muArr removeObjectAtIndex:removeIdx];
        [[TMCache sharedCache] setObject:muArr forKey:OTCOrder_Entrust_Sell_Key];
    }
}

- (void)requestEntrust_order_sell:(OTCOrder_Entrust_Sell_ParamsModel *)model {
    kWeakSelf(self);
    NSDictionary *params = [model mj_keyValues];
    NSString *timestamp = model.timestamp;
    [RequestService requestWithUrl6:entrust_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself handlerPayOrder_Entrust_Sell_Success:model];
        } else {
            // 上传txid备份
            TxidBackModel *txidBackM = [TxidBackModel new];
            txidBackM.txid = params[@"txid"];
            txidBackM.type = Txid_Backup_Type_ENTRUST_ORDER;
            txidBackM.platform = Platform_iOS;
            txidBackM.chain = @"";
            txidBackM.tokenName = @"";
            txidBackM.amount = @"";
            [TxidBackUtil requestSys_txid_backup:txidBackM completeBlock:^(BOOL success, NSString *msg) {
                if (success) {
                    [weakself handlerPayOrder_Entrust_Sell_Success:model];
                }
            }];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}



#pragma mark - 买卖单--卖家
- (void)cleanPayOrder_Buysell_Sell {
    [[TMCache sharedCache] removeObjectForKey:OTCOrder_Buysell_Sell_Key];
}

- (void)checkLocalPayOrder_Buysell_Sell {
    kWeakSelf(self);
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Buysell_Sell_Key];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float timeOffset = 1;
        OTCOrder_Buysell_Sell_Txid_ParamsModel *model = obj;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((idx+1)*timeOffset * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestTrade_sell_order_txid:model];
        });
    }];
}

- (void)savePayOrder_Buysell_Sell:(OTCOrder_Buysell_Sell_Txid_ParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Buysell_Sell_Key];
    // 去重
    __block BOOL isExist = NO;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTCOrder_Buysell_Sell_Txid_ParamsModel *temp = obj;
        if ([temp.txid isEqualToString:model.txid]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (!isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        if (localArr) {
            [muArr addObjectsFromArray:localArr];
        }
        [muArr addObject:model];
        [[TMCache sharedCache] setObject:muArr forKey:OTCOrder_Buysell_Sell_Key];
    }
}

- (void)handlerPayOrder_Buysell_Sell_Success:(OTCOrder_Buysell_Sell_Txid_ParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Buysell_Sell_Key];
    __block NSInteger removeIdx = -1;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTCOrder_Buysell_Sell_Txid_ParamsModel *tempM = obj;
        if ([tempM.txid isEqualToString:model.txid]) {
            removeIdx = idx;
            *stop = YES;
        }
    }];
    if (removeIdx != -1) {
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:localArr];
        [muArr removeObjectAtIndex:removeIdx];
        [[TMCache sharedCache] setObject:muArr forKey:OTCOrder_Buysell_Sell_Key];
    }
}

- (void)requestTrade_sell_order_txid:(OTCOrder_Buysell_Sell_Txid_ParamsModel *)model {
    kWeakSelf(self);
    NSDictionary *params = [model mj_keyValues];
    NSString *timestamp = model.timestamp;
    [RequestService requestWithUrl6:trade_sell_order_txid_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself handlerPayOrder_Buysell_Sell_Success:model];
        } else {
            // 上传txid备份
            TxidBackModel *txidBackM = [TxidBackModel new];
            txidBackM.txid = params[@"txid"];
            txidBackM.type = Txid_Backup_Type_TRADE_ORDER;
            txidBackM.platform = Platform_iOS;
            txidBackM.chain = @"";
            txidBackM.tokenName = @"";
            txidBackM.amount = @"";
            [TxidBackUtil requestSys_txid_backup:txidBackM completeBlock:^(BOOL success, NSString *msg) {
                if (success) {
                    [weakself handlerPayOrder_Buysell_Sell_Success:model];
                }
            }];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - 买卖单--买家确认
- (void)cleanPayOrder_Buysell_Buy_Confirm {
    [[TMCache sharedCache] removeObjectForKey:OTCOrder_Buysell_Buy_Confirm_Key];
}

- (void)checkLocalPayOrder_Buysell_Buy_Confirm {
    kWeakSelf(self);
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Buysell_Buy_Confirm_Key];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float timeOffset = 1;
        OTCOrder_Buysell_Buy_Confirm_ParamsModel *model = obj;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((idx+1)*timeOffset * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestTrade_buyer_confirm:model];
        });
    }];
}

- (void)savePayOrder_Buysell_Buy_Confirm:(OTCOrder_Buysell_Buy_Confirm_ParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Buysell_Buy_Confirm_Key];
    // 去重
    __block BOOL isExist = NO;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTCOrder_Buysell_Buy_Confirm_ParamsModel *temp = obj;
        if ([temp.txid isEqualToString:model.txid]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (!isExist) {
        NSMutableArray *muArr = [NSMutableArray array];
        if (localArr) {
            [muArr addObjectsFromArray:localArr];
        }
        [muArr addObject:model];
        [[TMCache sharedCache] setObject:muArr forKey:OTCOrder_Buysell_Buy_Confirm_Key];
    }
}

- (void)handlerPayOrder_Buysell_Buy_Confirm_Success:(OTCOrder_Buysell_Buy_Confirm_ParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrder_Buysell_Buy_Confirm_Key];
    __block NSInteger removeIdx = -1;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTCOrder_Buysell_Buy_Confirm_ParamsModel *tempM = obj;
        if ([tempM.txid isEqualToString:model.txid]) {
            removeIdx = idx;
            *stop = YES;
        }
    }];
    if (removeIdx != -1) {
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:localArr];
        [muArr removeObjectAtIndex:removeIdx];
        [[TMCache sharedCache] setObject:muArr forKey:OTCOrder_Buysell_Buy_Confirm_Key];
    }
}

- (void)requestTrade_buyer_confirm:(OTCOrder_Buysell_Buy_Confirm_ParamsModel *)model {
    kWeakSelf(self);
    NSDictionary *params = [model mj_keyValues];
    NSString *timestamp = model.timestamp;
    [RequestService requestWithUrl6:trade_buyer_confirm_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself handlerPayOrder_Buysell_Buy_Confirm_Success:model];
        } else {
            // 上传txid备份
            TxidBackModel *txidBackM = [TxidBackModel new];
            txidBackM.txid = params[@"txid"];
            txidBackM.type = Txid_Backup_Type_TRADE_ORDER;
            txidBackM.platform = Platform_iOS;
            txidBackM.chain = @"";
            txidBackM.tokenName = @"";
            txidBackM.amount = @"";
            [TxidBackUtil requestSys_txid_backup:txidBackM completeBlock:^(BOOL success, NSString *msg) {
                if (success) {
                    [weakself handlerPayOrder_Buysell_Buy_Confirm_Success:model];
                }
            }];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
