//
//  GroupBuyUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/20.
//  Copyright © 2020 pan. All rights reserved.
//

#import "GroupBuyUtil.h"
#import "GlobalConstants.h"
#import "ClaimConstants.h"
#import "NSDate+Category.h"

@implementation GroupBuyUtil

+ (void)requestIsInGroupBuyActiviyTime:(void(^)(BOOL isInGroupBuyActiviyTime))completeBlock {
//    kWeakSelf(self);
    NSDictionary *params = @{@"dictType":app_dict};
    [RequestService requestWithUrl10:sys_dict_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            BOOL isInGroupBuyActiviyTime = NO;
            NSString *topupGroupStartDateStr = responseObject[Server_Data][@"topupGroupStartDate"]?:@"";
            NSString *topopGroupEndDateStr = responseObject[Server_Data][@"topopGroupEndDate"]?:@"";
            NSString *currentTimestamp = responseObject[@"currentTimeMillis"]?:@"";
            NSDate *startDate = [NSDate dateFromTime_c:topupGroupStartDateStr];
            NSDate *endDate = [NSDate dateFromTime_c:topopGroupEndDateStr];
            NSDate *currentDate = [NSDate getDateWithTimestamp:currentTimestamp isMil:YES];
            isInGroupBuyActiviyTime = [startDate isEarlierThanDate:currentDate]&&[currentDate isEarlierThanDate:endDate];
            if (completeBlock) {
                completeBlock(isInGroupBuyActiviyTime);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
