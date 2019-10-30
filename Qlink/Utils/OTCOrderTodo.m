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

@implementation OTCOrderParamsModel

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

- (void)checkLocalPayOrder {
    kWeakSelf(self);
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrderLocal_Key];
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float timeOffset = 1;
        OTCOrderParamsModel *model = obj;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((idx+1)*timeOffset * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestTopup_order:model];
        });
    }];
}

- (void)savePayOrder:(OTCOrderParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrderLocal_Key];
    NSMutableArray *muArr = [NSMutableArray array];
    if (localArr) {
        [muArr addObjectsFromArray:localArr];
    }
    [muArr addObject:model];
    [[TMCache sharedCache] setObject:muArr forKey:OTCOrderLocal_Key];
}

- (void)cleanPayOrder {
    [[TMCache sharedCache] removeObjectForKey:OTCOrderLocal_Key];
}

- (void)handlerPayOrderSuccess:(OTCOrderParamsModel *)model {
    NSArray *localArr = [[TMCache sharedCache] objectForKey:OTCOrderLocal_Key];
    __block NSInteger removeIdx = -1;
    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTCOrderParamsModel *tempM = obj;
        if ([tempM.txid isEqualToString:model.txid]) {
            removeIdx = idx;
            *stop = YES;
        }
    }];
    if (removeIdx != -1) {
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:localArr];
        [muArr removeObjectAtIndex:removeIdx];
        [[TMCache sharedCache] setObject:muArr forKey:OTCOrderLocal_Key];
    }
}

- (void)requestTopup_order:(OTCOrderParamsModel *)model {
    kWeakSelf(self);
    NSDictionary *params = [model mj_keyValues];
    [RequestService requestWithUrl10:topup_order_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself handlerPayOrderSuccess:model];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
