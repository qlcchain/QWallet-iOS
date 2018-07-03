//
//  HeartbeatUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/27.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "HeartbeatUtil.h"
#import "TransferUtil.h"

@implementation HeartbeatUtil

+ (instancetype)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static HeartbeatUtil *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc]init];
    });
    return sharedObj;
}

+ (void) sendHeartbeatRequest
{
    int status = 1;
    if (![ToxManage getP2PConnectionStatus]) {
        status = 0;
    }
    
    NSDictionary *parmer = @{@"p2pId":[ToxManage getOwnP2PId],
                             @"status":[NSNumber numberWithInt:status],
                             @"vpnName":[TransferUtil currentVPNName],
                             @"wifiName":@""
                             };
    [RequestService requestWithUrl:heartbeatV3_Url params:parmer httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        DDLogDebug(@"heartbeatt send failed");
    }];
}

- (void) sendTimedHeartbeat {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC); // 开始时间
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),60.0*NSEC_PER_SEC, 0); //每60秒执行
    dispatch_source_set_event_handler(_timer, ^{
        [HeartbeatUtil sendHeartbeatRequest];
    });
    dispatch_resume(_timer);
}

- (void)freeTime {
    dispatch_source_cancel(_timer);
    _timer = nil;
}

@end
