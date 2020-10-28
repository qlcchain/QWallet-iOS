//
//  QSwipWrapperRequestUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QSwipWrapperRequestUtil.h"
#import "GlobalConstants.h"
#import "AFJSONRPCClient.h"
#import "NSString+RandomStr.h"
#import "QLogHelper.h"
#import "QSwapAddressModel.h"


@implementation QSwipWrapperRequestUtil

/// 检查 wraper 是否在线
/// @param resultHandler 成功回调
+ (void) checkWrapperOnlineWithFetchEthAddress:(NSString *) ethAddress resultHandler:(QWrapperResultBlock)resultHandler {
 
    NSString *urlStr = [[ConfigUtil get_qlc_hub_node_normal] stringByAppendingString:@"/info/ping"];
    NSDictionary *params = @{@"value":ethAddress?:@""};
    DDLogDebug(@"qlcch_wrapperOnline params = %@",params);
    [AFHTTPClientV2 requestWrapperWithBaseURLStr:urlStr params:params httpMethod:HttpMethodGet successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (responseObject && [responseObject[@"code"] intValue] == 0) {
            [QSwapAddressModel getShareObject].ethAddress = responseObject[@"ethAddress"];
            [QSwapAddressModel getShareObject].ethContract = responseObject[@"ethContract"];
            [QSwapAddressModel getShareObject].neoAddress = responseObject[@"neoAddress"];
            [QSwapAddressModel getShareObject].neoContract = responseObject[@"neoContract"];
            [QSwapAddressModel getShareObject].ethBalance = responseObject[@"ethBalance"];
            [QSwapAddressModel getShareObject].neoBalance = responseObject[@"neoBalance"];
            [QSwapAddressModel getShareObject].withdrawLimit = [responseObject[@"withdrawLimit"] boolValue];
            [QSwapAddressModel getShareObject].minDepositAmount = responseObject[@"minDepositAmount"];
            [QSwapAddressModel getShareObject].minWithdrawAmount = responseObject[@"minWithdrawAmount"];
            resultHandler(nil,YES,@"");
        } else {
            if (resultHandler) {
                NSString *showDes = @"qlcch_wrapperOnline error, try later. (error reported)";
                resultHandler(nil, NO, showDes);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (resultHandler) {
            NSString *showDes = @"qlcch_wrapperOnline error, try later. (error reported)";
            resultHandler(nil, NO, showDes);

            NSString *des = [@"qlcch_wrapperOnline error" stringByAppendingFormat:@"   ***method:%@    ***error:%@",@"qlcch_wrapperOnline",error.description];
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }

        NSLog(@"error=%@",error);
    }];

}

+ (void) ercLockWithdrawAPILockWithRhash:(NSString *) rHash resultHandler:(QWrapperResultBlock)resultHandler
{
    NSString *urlStr = [[ConfigUtil get_qlc_hub_node_normal] stringByAppendingString:@"/withdraw/lock"];
    NSDictionary *params = @{@"value":[rHash substringFromIndex:2]};
    DDLogDebug(@"WithdrawAPI_Lock params = %@",params);
    [AFHTTPClientV2 requestWrapperWithBaseURLStr:urlStr params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (responseObject) {
            resultHandler(responseObject,YES,@"");
        } else {
            if (resultHandler) {
                NSString *showDes = @"WithdrawAPI_Lock error, try later. (error reported)";
                resultHandler(nil, NO, showDes);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (resultHandler) {
            NSString *showDes = @"WithdrawAPI_Lock error, try later. (error reported)";
            resultHandler(nil, NO, showDes);
        }

        NSLog(@"error=%@",error);
    }];
}

/// 检查 事件状态
/// /// rHash 不要加0x
/// @param resultHandler 成功回调
+ (void) checkEventStatWithRhash:(NSString *) rHash resultHandler:(QWrapperResultBlock)resultHandler {
    
   NSString *urlStr = [[ConfigUtil get_qlc_hub_node_normal] stringByAppendingString:@"/info/lockerInfo"];
    NSDictionary *params = @{@"value":[rHash substringFromIndex:2]};
    DDLogDebug(@"depositApiLock params = %@",params);
    [AFHTTPClientV2 requestWrapperWithBaseURLStr:urlStr params:params httpMethod:HttpMethodGet successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (responseObject) {
            resultHandler(responseObject,YES,@"");
        } else {
            if (resultHandler) {
                NSString *showDes = @"depositApiLock error, try later. (error reported)";
                resultHandler(nil, NO, showDes);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (resultHandler) {
            NSString *showDes = @"depositApiLock error, try later. (error reported)";
            resultHandler(nil, NO, showDes);
        }

        NSLog(@"error=%@",error);
    }];
}
// hash不需要加 0x
+ (void) depositApiLockWithNepTxHash:(NSString *)nepTxhash amount:(NSString *) amount rHash:(NSString *) rHash wrapperEthAddress:(NSString *) wrapperEthAddress resultHandler:(QWrapperResultBlock)resultHandler {
    
    NSString *urlStr = [[ConfigUtil get_qlc_hub_node_normal] stringByAppendingString:@"/deposit/lock"];
    NSDictionary *params = @{@"nep5TxHash":nepTxhash,@"amount":amount,@"rHash":rHash,@"addr":wrapperEthAddress
    };
    DDLogDebug(@"depositApiLock params = %@",params);
    [AFHTTPClientV2 requestWrapperWithBaseURLStr:urlStr params:params httpMethod:HttpMethodGet successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (responseObject) {
            resultHandler(responseObject,YES,@"");
        } else {
            if (resultHandler) {
                NSString *showDes = @"depositApiLock error, try later. (error reported)";
                resultHandler(nil, NO, showDes);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (resultHandler) {
            NSString *showDes = @"depositApiLock error, try later. (error reported)";
            resultHandler(nil, NO, showDes);
        }

        NSLog(@"error=%@",error);
    }];
}
// hash不需要加 0x
+ (void) withdrawApiUnLockWithNepTxHash:(NSString *)nepTxhash rHash:(NSString *) rHash rOright:(NSString *) rOright resultHandler:(QWrapperResultBlock)resultHandler {
    
    NSString *urlStr = [[ConfigUtil get_qlc_hub_node_normal] stringByAppendingString:@"/withdraw/unlock"];
    NSDictionary *params = @{@"nep5TxHash":nepTxhash,@"rHash":rHash,@"rOrigin":rOright
    };
    DDLogDebug(@"depositApiLock params = %@",params);
    [AFHTTPClientV2 requestWrapperWithBaseURLStr:urlStr params:params httpMethod:HttpMethodGet successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (responseObject) {
            resultHandler(responseObject,YES,@"");
        } else {
            if (resultHandler) {
                NSString *showDes = @"depositApiLock error, try later. (error reported)";
                resultHandler(nil, NO, showDes);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (resultHandler) {
            NSString *showDes = @"depositApiLock error, try later. (error reported)";
            resultHandler(nil, NO, showDes);
        }

        NSLog(@"error=%@",error);
    }];
}
// unlock 到 nepo
+ (void) unLockToNep5WithRhash:(NSString *) rOrigin userNep5Addr:(NSString *) nep5Address resultHandler:(QWrapperResultBlock)resultHandler {
    NSString *urlStr = [[ConfigUtil get_qlc_hub_node_normal] stringByAppendingString:@"/withdraw/claim"];
    NSDictionary *params = @{@"rOrigin":rOrigin,@"userNep5Addr":nep5Address?:@""
       };
       DDLogDebug(@"unLockToNep5 params = %@",params);
       [AFHTTPClientV2 requestWrapperWithBaseURLStr:urlStr params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
           if (responseObject) {
               resultHandler(responseObject[@"value"]?:@"",YES,@"");
           } else {
               if (resultHandler) {
                   resultHandler(nil, NO,kLang(@"failed"));
               }
           }
       } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
           if (resultHandler) {
               resultHandler(nil, NO, error.description);
           }

           NSLog(@"error=%@",error);
       }];
}

/*
/// 检查 wraper 是否在线
/// @param resultHandler 成功回调
+ (void) checkWrapperOnlineResultHandler:(QWrapperResultBlock)resultHandler {
 
    NSString *urlStr = [[ConfigUtil get_wraper_node_normal] stringByAppendingString:@"/Wrapper/online"];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:urlStr]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    NSDictionary *params = @{};
    DDLogDebug(@"qlcch_wrapperOnline params = %@",params);

    [client invokeWrapperMethod:@"qlcch_wrapperOnline" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"qlcch_wrapperOnline responseObject=%@",responseObject);

        if (responseObject) {
            resultHandler(responseObject,YES,@"");
        } else {
            if (resultHandler) {
                NSString *showDes = @"qlcch_wrapperOnline error, try later. (error reported)";
                resultHandler(nil, NO, showDes);

                NSString *des = [@"qlcch_wrapperOnline error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"qlcch_wrapperOnline",[responseObject mj_JSONString]];
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];

            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *showDes = @"qlcch_wrapperOnline error, try later. (error reported)";
            resultHandler(nil, NO, showDes);

            NSString *des = [@"qlcch_wrapperOnline error" stringByAppendingFormat:@"   ***method:%@    ***error:%@",@"qlcch_wrapperOnline",error.description];
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }

        NSLog(@"error=%@",error);
    }];
    
}
*/
/*
/// 检查 事件状态
/// @param eventType 事件类型
/// @param eventHash 事件hash
/// @param resultHandler 成功回调
+ (void) checkEventStatWithEeventType:(NSString *) eventType eventHash:(NSString *) eventHash resultHandler:(QWrapperResultBlock)resultHandler {
    
    NSString *urlStr = [[ConfigUtil get_wraper_node_normal] stringByAppendingString:@"/Wrapper/eventstatcheck"];
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:urlStr]];
    // Invocation with Parameters and Request ID
    NSDictionary *params = @{@"type":eventType,@"hash":eventHash};
    DDLogDebug(@"qlcch_eventStatCheck params = %@",params);

    [client invokeWrapperMethod:@"qlcch_eventStatCheck" withParameters:params requestId:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"qlcch_eventStatCheck responseObject=%@",responseObject);
        
        if (responseObject && [responseObject[@"errno"] integerValue] == 0) {
            resultHandler(responseObject,YES,@"");
        } else {
            if (resultHandler) {
                NSString *showDes = @"qlcch_eventStatCheck error, try later. (error reported)";
                resultHandler(nil, NO, showDes);
                
                NSString *des = [@"qlcch_eventStatCheck error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"qlcch_eventStatCheck",[responseObject mj_JSONString]];
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *showDes = @"qlcch_eventStatCheck error, try later. (error reported)";
            resultHandler(nil, NO, showDes);
            
            NSString *des = [@"qlcch_eventStatCheck error" stringByAppendingFormat:@"   ***method:%@    ***error:%@",@"qlcch_eventStatCheck",error.description];
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        
        NSLog(@"error=%@",error);
    }];
}
*/
/// nep5 锁定
/// @param type 类型
/// @param hash hash
/// @param amount 数量
/// @param resultHandler 回调
+ (void) nep5LockNoticeWithType:(NSString *) type hash:(NSString *) hash amount:(NSString *) amount resultHandler:(QWrapperResultBlock)resultHandler {
    
    NSString *urlStr = [[ConfigUtil get_wraper_node_normal] stringByAppendingString:@"/Wrapper/nep5locknotice"];
       AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:urlStr]];
    // Invocation with Parameters and Request ID
    NSDictionary *params = @{@"type":type,@"hash":hash,@"amount":amount};
    DDLogDebug(@"qlcch_nep5LockNotice params = %@",params);

    [client invokeMethod:@"qlcch_nep5LockNotice" withParameters:params requestId:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"qlcch_nep5LockNotice responseObject=%@",responseObject);
        
        if (responseObject) {
            resultHandler(responseObject,YES,@"");
        } else {
            if (resultHandler) {
                NSString *showDes = @"qlcch_nep5LockNotice error, try later. (error reported)";
                resultHandler(nil, NO, showDes);
                
                NSString *des = [@"qlcch_nep5LockNotice error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"qlcch_nep5LockNotice",[responseObject mj_JSONString]];
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *showDes = @"qlcch_nep5LockNotice error, try later. (error reported)";
            resultHandler(nil, NO, showDes);
            
            NSString *des = [@"qlcch_nep5LockNotice error" stringByAppendingFormat:@"   ***method:%@    ***error:%@",@"qlcch_nep5LockNotice",error.description];
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        
        NSLog(@"error=%@",error);
    }];
}
@end
