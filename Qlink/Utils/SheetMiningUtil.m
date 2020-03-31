//
//  SheetMiningUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/14.
//  Copyright © 2019 pan. All rights reserved.
//

#import "SheetMiningUtil.h"
#import "GlobalConstants.h"

@implementation SheetMiningUtil

+ (void)requestTrade_mining_list:(void(^)(NSArray<MiningActivityModel *> *arr))listB {
    NSDictionary *params = @{};
    [RequestService requestWithUrl10:trade_mining_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *modelArr = [MiningActivityModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            if (listB) {
                listB(modelArr?:@[]);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
