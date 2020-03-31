//
//  TopupPayOrderHelper.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupPayOrderTodo.h"
#import <TMCache/TMCache.h>
#import "GlobalConstants.h"
#import "TxidBackUtil.h"

@implementation TopupPayOrderParamsModel

@end

@implementation TopupPayOrderTodo

+ (instancetype)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static TopupPayOrderTodo *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc]init];
    });
    return sharedObj;
}

- (void)checkLocalPayOrder {
    kWeakSelf(self);
    NSArray *localArr = [[TMCache sharedCache] objectForKey:TopupPayOrderLocal_Key];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float timeOffset = 1;
        TopupPayOrderParamsModel *model = obj;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((idx+1)*timeOffset * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestTopup_order:model];
        });
    }];
}

- (void)savePayOrder:(TopupPayOrderParamsModel *)model {    
    NSArray *localArr = [[TMCache sharedCache] objectForKey:TopupPayOrderLocal_Key];
    // 去重
    __block BOOL isExist = NO;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TopupPayOrderParamsModel *temp = obj;
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
        [[TMCache sharedCache] setObject:muArr forKey:TopupPayOrderLocal_Key];
    }
}

- (void)cleanPayOrder {
    [[TMCache sharedCache] removeObjectForKey:TopupPayOrderLocal_Key];
}

- (void)handlerPayOrderSuccess:(TopupPayOrderParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:TopupPayOrderLocal_Key];
    __block NSInteger removeIdx = -1;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TopupPayOrderParamsModel *tempM = obj;
        if ([tempM.txid isEqualToString:model.txid]) {
            removeIdx = idx;
            *stop = YES;
        }
    }];
    if (removeIdx != -1) {
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:localArr];
        [muArr removeObjectAtIndex:removeIdx];
        [[TMCache sharedCache] setObject:muArr forKey:TopupPayOrderLocal_Key];
    }
}

- (void)requestTopup_order:(TopupPayOrderParamsModel *)model {
    kWeakSelf(self);
    NSDictionary *params = [model mj_keyValues];
//    NSDictionary *params = @{@"account":account,@"p2pId":p2pId,@"productId":productId,@"areaCode":areaCode,@"phoneNumber":phoneNumber,@"amount":amount,@"txid":_payTxid?:@"",@"payTokenId":payTokenId};
//    [[TopupPayOrderHelper shareInstance] savePayOrder:params];
    [RequestService requestWithUrl10:topup_order_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself handlerPayOrderSuccess:model];
        } else {
            // 上传txid备份
            TxidBackModel *txidBackM = [TxidBackModel new];
            txidBackM.txid = params[@"txid"];
            txidBackM.type = Txid_Backup_Type_TOPUP;
            txidBackM.platform = Platform_iOS;
            txidBackM.chain = @"";
            txidBackM.tokenName = @"";
            txidBackM.amount = @"";
            [TxidBackUtil requestSys_txid_backup:txidBackM completeBlock:^(BOOL success, NSString *msg) {
                if (success) {
                    [weakself handlerPayOrderSuccess:model];
                } else {
                    if (msg && [msg containsString:@"txid repeat"]) {
                        [weakself handlerPayOrderSuccess:model];
                    }
                }
            }];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
