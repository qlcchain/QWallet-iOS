//
//  WalletTransferUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "WalletTransferUtil.h"
#import "RequestService.h"
#import "NeoTransferUtil.h"
#import <QLCFramework/QLCFramework.h>
//#import <QLCFramework/QLCFramework.h>
#import "GlobalConstants.h"
#import "ETHWalletManage.h"


dispatch_source_t _mainAddressTimer;

@implementation WalletTransferUtil

+ (instancetype)getShareObject {
    static dispatch_once_t pred = 0;
    __strong static WalletTransferUtil *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc]init];
    });
    return sharedObj;
}

#pragma mark - 获取主网钱包地址
- (void)startFetchServerMainAddress {
    CGFloat walltime = 30;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _mainAddressTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_mainAddressTimer,dispatch_walltime(NULL, 0),walltime*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_mainAddressTimer, ^{
        NSString *neoMainAddress = [NeoTransferUtil getShareObject].neoMainAddress;
        if (!neoMainAddress || neoMainAddress.length <= 0) {
            [WalletTransferUtil requestServerMainAddress];
        }
    });
    dispatch_resume(_mainAddressTimer);
}

+ (void)requestServerMainAddress {
    // 获取主网交换地址
    [RequestService requestWithUrl10:mainAddressV2_Url params:@{} httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [NeoTransferUtil getShareObject].neoMainAddress = responseObject[Server_Data][@"NEO"][@"address"];
            NSLog(@"NEO主地址:%@",[NeoTransferUtil getShareObject].neoMainAddress);
            [QLCWalletManage shareInstance].qlcMainAddress = responseObject[Server_Data][@"QLCCHIAN"][@"address"];
            NSLog(@"QLC主地址:%@",[QLCWalletManage shareInstance].qlcMainAddress);
            [ETHWalletManage shareInstance].ethMainAddress = responseObject[Server_Data][@"ETH"][@"address"];
            NSLog(@"ETH主地址:%@",[ETHWalletManage shareInstance].ethMainAddress);
           
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [WalletTransferUtil requestServerMainAddress];
    }];
}

@end
