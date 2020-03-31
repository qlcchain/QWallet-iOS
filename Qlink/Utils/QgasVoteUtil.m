//
//  QgasVoteUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/26.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QgasVoteUtil.h"
#import "GlobalConstants.h"
#import "ClaimConstants.h"
#import "NSDate+Category.h"

@implementation QgasVoteUtil

+ (void)requestState:(void(^)(QgasVoteState state))completeBlock {
//    kWeakSelf(self);
    NSDictionary *params = @{@"dictType":app_dict};
    [RequestService requestWithUrl10:sys_dict_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            
            NSString *topupGroupStartDateStr = responseObject[Server_Data][@"burnQgasVoteStartDate"]?:@"";
            NSString *topopGroupEndDateStr = responseObject[Server_Data][@"burnQgasVoteEndDate"]?:@"";
            NSString *currentTimestamp = responseObject[@"currentTimeMillis"]?:@"";
            NSDate *startDate = [NSDate dateFromTime:topupGroupStartDateStr];
            NSDate *endDate = [NSDate dateFromTime:topopGroupEndDateStr];
            NSDate *currentDate = [NSDate getDateWithTimestamp:currentTimestamp isMil:YES];
            QgasVoteState state = QgasVoteStateNotyet;
            if ([currentDate isEarlierThanDate:startDate]) {
                state = QgasVoteStateNotyet;
            } else if ([startDate isEarlierThanDate:currentDate]&&[currentDate isEarlierThanDate:endDate]) {
                state = QgasVoteStateOngoing;
            } else if ([endDate isEarlierThanDate:currentDate]) {
                state = QgasVoteStateDone;
            }
            if (completeBlock) {
                completeBlock(state);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
