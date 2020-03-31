//
//  QgasVoteUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/26.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BuybackBurnUtil.h"
#import "GlobalConstants.h"

@implementation BuybackBurnUtil

+ (void)requestBuybackBurn_list:(void(^)(NSArray<BuybackBurnModel *> *arr))listB {
    NSDictionary *params = @{};
    [RequestService requestWithUrl10:burn_qgas_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *modelArr = [BuybackBurnModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            if (listB) {
                listB(modelArr?:@[]);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

+ (void)requestBuybackBurn_list_v2:(void(^)(NSArray<BuybackBurnModel *> *arr))listB {
    NSDictionary *params = @{};
    [RequestService requestWithUrl10:burn_qgas_list_v2_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *modelArr = [BuybackBurnModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            if (listB) {
                listB(modelArr?:@[]);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
