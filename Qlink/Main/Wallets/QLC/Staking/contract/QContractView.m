//
//  QContractView.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/4.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QContractView.h"
#import "dsbridge.h"
#import "JsApiTest.h"
#import <WebKit/WebKit.h>
#import "WalletCommonModel.h"
#import "NEOWalletInfo.h"
#import <QLCFramework/QLCFramework.h>
#import "GlobalConstants.h"
#import "AFJSONRPCClient.h"
#import "ConfigUtil.h"
#import <QLCFramework/QLCFramework.h>
#import "NSString+RandomStr.h"
#import "QLogHelper.h"

static NSString * const PublicKeyB = @"02c6e68c61480003ed163f72b41cbb50ded29d79e513fd299d2cb844318b1b8ad5";

@interface QContractView () <WKNavigationDelegate> {
    JsApiTest *jsApi;
}

@property (nonatomic, strong) DWKWebView *dwebview;

@end

@implementation QContractView

//+ (instancetype)shareInstance {
//    static id shareObject = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        shareObject = [[self alloc] init];
//        [shareObject config];
//    });
//    return shareObject;
//}

+ (QContractView *)addQContractView {
    QContractView *contractV = [QContractView new];
    contractV.frame = CGRectZero;
    [contractV config];
    [kAppD.window addSubview:contractV];
    return contractV;
}

+ (void)removeQContractView:(QContractView *)contractV {
    if (contractV) {
        [contractV removeFromSuperview];
    }
}

#pragma mark - Operation
- (void)config {
    _dwebview=[[DWKWebView alloc] initWithFrame:CGRectZero];
    [self addSubview:_dwebview];
    
    // register api object without namespace
    [_dwebview addJavascriptObject:[[JsApiTest alloc] init] namespace:@"staking"];
    
#ifdef DEBUG
    [_dwebview setDebugMode:true];
#else
    [_dwebview setDebugMode:false];
#endif
    
    [_dwebview customJavascriptDialogLabelTitles:@{@"alertTitle":@"Notification",@"alertBtn":@"OK"}];
    
    _dwebview.navigationDelegate=self;
    
    // load test.html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    //    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"contract" ofType:@"html"];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    [_dwebview loadHTMLString:htmlContent baseURL:baseURL];
    
    // set javascript close listener
    [_dwebview setJavascriptCloseWindowListener:^{
        NSLog(@"window.close called");
    } ];
}


#pragma mark - Request
#pragma mark - Benefit Pledge
- (void)benefit_createMultiSig:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(QContractResultBlock)resultHandler {
    
    NSArray *argu1 = @[neo_publicKey,PublicKeyB];
    DDLogDebug(@"staking.createMultiSig argu1 = %@",argu1);
    kWeakSelf(self);
    [_dwebview callHandler:@"staking.createMultiSig" arguments:argu1 completionHandler:^(NSDictionary * _Nullable value) {
        DDLogDebug(@"createMultiSig: %@",value);
        
        NSString *toAddress = value[@"_address"];
        
        [weakself benefit_contractLock:neo_publicKey neo_wifKey:neo_wifKey fromAddress:fromAddress toAddress:toAddress qlcAddress:qlcAddress qlcAmount:qlcAmount lockTime:lockTime qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
    }];
}

- (void)benefit_contractLock:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(QContractResultBlock)resultHandler {
    NSArray *argu2 = @[neo_wifKey,fromAddress,toAddress,qlcAddress,qlcAmount,lockTime];
    DDLogDebug(@"staking.contractLock argu2 = %@",argu2);
    kWeakSelf(self);
    NSString *callMethod = @"staking.contractLock";
    [_dwebview callHandler:callMethod arguments:argu2 completionHandler:^(NSDictionary * _Nullable value) {
        DDLogDebug(@"contractLock: %@",value);
        
        NSInteger result = [value[@"result"] integerValue];
        if (result == 1) {
            NSString *lockTxId = value[@"txid"];
            [weakself nep5_prePareBenefitPledge:qlcAddress qlcAmount:qlcAmount multiSigAddress:toAddress neo_publicKey:neo_publicKey lockTxId:lockTxId qlc_privateKey:qlc_privateKey qlc_publicKey:qlc_publicKey resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                NSString *des = [@"contractLock error" stringByAppendingFormat:@"   ***method:%@   ***fromAddress:%@   ***neo_publicKey:%@   ***error:%@",callMethod,fromAddress,neo_publicKey,value.mj_JSONString];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
        
    }];
}

- (void)nep5_prePareBenefitPledge:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount multiSigAddress:(NSString *)multiSigAddress neo_publicKey:(NSString *)neo_publicKey lockTxId:(NSString *)lockTxId qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(QContractResultBlock)resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSString *amount = [NSString stringWithFormat:@"%@",@([qlcAmount doubleValue]*QLC_UnitNum)];
    NSArray *params = @[@{@"beneficial":qlcAddress,@"amount":amount,@"pType":@"vote"},@{@"multiSigAddress":multiSigAddress,@"publicKey":neo_publicKey,@"lockTxId":lockTxId}];
    DDLogDebug(@"nep5_prePareBenefitPledge params = %@",params);
    [client invokeMethod:@"nep5_prePareBenefitPledge" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"nep5_prePareBenefitPledge responseObject=%@",responseObject);
        
        if ([responseObject integerValue] == 1) {
            [weakself benefit_getnep5transferbytxid:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
        } else {
            if (resultHandler) {
//                NSString *test = [@"ss" stringByAppendingString:@""];
                NSString *des = [@"nep5_prePareBenefitPledge error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_prePareBenefitPledge",responseObject];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *des = [@"nep5_prePareBenefitPledge error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_prePareBenefitPledge",error.description];
            resultHandler(nil, NO, des);
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        NSLog(@"error=%@",error);
    }];
    
}

- (void)benefit_getnep5transferbytxid:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(QContractResultBlock)resultHandler {
//    NSString *requestId = [NSString randomOf32];
//    NSDictionary *params = @{@"jsonrpc":@"2.0",@"method":@"getnep5transferbytxid",@"params":[[NSString stringWithFormat:@"[\"%@\"]",lockTxId] stringByReplacingOccurrencesOfString:@"\\" withString:@""],@"id":requestId};
//    NSString *urlStr = @"https://api.nel.group/api/mainnet";
    NSDictionary *params = nil;
    NSString *urlStr = [NSString stringWithFormat:@"https://api.neoscan.io/api/main_net/v1/get_transaction/%@",lockTxId];
    
    kWeakSelf(self);
    DDLogDebug(@"benefit_getnep5transferbytxid urlStr = %@",urlStr);
    [RequestService normalRequestWithBaseURLStr8:urlStr params:params httpMethod:HttpMethodGet userInfo:nil requestManagerType:QRequestManagerTypeHTTP successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        DDLogDebug(@"benefit_getnep5transferbytxid responseObject=%@",responseObject);
        NSDictionary *responseDic = [responseObject mj_JSONObject];
//        NSArray *resultDic = responseDic[@"result"];
        if (responseDic) {
            [weakself nep5_benefitPledge:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                NSString *des = [@"neo_get_transaction error" stringByAppendingFormat:@"   ***method:%@  ***error:%@",urlStr,[responseDic mj_JSONString]];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        int64_t delayInSeconds = 3.0; // 延迟的时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself benefit_getnep5transferbytxid:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
        });
    }];
    
}

- (void)nep5_benefitPledge:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(QContractResultBlock)resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSArray *params = @[lockTxId];
    DDLogDebug(@"nep5_benefitPledge params = %@",params);
    [client invokeMethod:@"nep5_benefitPledge" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"nep5_benefitPledge responseObject=%@",responseObject);
        
        if (responseObject) {
            [weakself signAndWork:responseObject qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey lockTxId:lockTxId unlockTxParams:nil resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                NSString *des = [@"nep5_benefitPledge error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_benefitPledge",[responseObject mj_JSONString]];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *des = [@"nep5_benefitPledge error" stringByAppendingFormat:@"   ***method:%@    ***error:%@",@"nep5_benefitPledge",error.description];
            resultHandler(nil, NO, des);
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        
        NSLog(@"error=%@",error);
    }];
    
}


- (void)ledger_pledgeInfoByTransactionID:(NSString *)lockTxId resultHandler:(QContractResultBlock)resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    NSString *requestId = [NSString randomOf32];
    //    kWeakSelf(self);
    NSArray *params = @[lockTxId];
    DDLogDebug(@"ledger_pledgeInfoByTransactionID params = %@",params);
    [client invokeMethod:@"ledger_pledgeInfoByTransactionID" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"ledger_pledgeInfoByTransactionID responseObject=%@",responseObject);
        
        if (responseObject) {
            if (resultHandler) {
                resultHandler(@(0), YES, nil);
            }
        } else {
            if (resultHandler) {
                NSString *des = [@"ledger_pledgeInfoByTransactionID error" stringByAppendingFormat:@"   ***method:%@    ***error:%@",@"nep5_getLockInfo",[responseObject mj_JSONString]];
                resultHandler(@(0), NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *des = [@"ledger_pledgeInfoByTransactionID error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"ledger_pledgeInfoByTransactionID",error.description];
            resultHandler(@(1), NO, des);
//            NSString *className = NSStringFromClass([self class]);
//            NSString *methodName = NSStringFromSelector(_cmd);
//            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        
        NSLog(@"error=%@",error);
    }];
    
}


#pragma mark - Benefit Withdraw
//- (void)request_benefit_neo_address:(NSString *)lockTxId resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
//    NSString *requestId = [NSString randomOf32];
//    NSDictionary *params = @{@"jsonrpc":@"2.0",@"method":@"getnep5transferbytxid",@"params":[NSString stringWithFormat:@"[\"%@\"]",lockTxId],@"id":requestId};
//    NSString *urlStr = @"https://api.nel.group/api/mainnet";
////    NSDictionary *params = nil;
////    NSString *urlStr = [NSString stringWithFormat:@"https://api.neoscan.io/api/main_net/v1/get_transaction/%@",lockTxId];
//
////    kWeakSelf(self);
//    DDLogDebug(@"benefit_getnep5transferbytxid urlStr = %@",urlStr);
//    [RequestService normalRequestWithBaseURLStr8:urlStr params:params httpMethod:HttpMethodGet userInfo:nil requestManagerType:QRequestManagerTypeHTTP successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        DDLogDebug(@"benefit_getnep5transferbytxid responseObject=%@",responseObject);
//        NSDictionary *responseDic = [responseObject mj_JSONObject];
//        NSArray *resultArr = responseDic[@"result"];
//        if (resultArr) {
//            NSDictionary *resultDic = resultArr.firstObject;
//            NSString *neo_addrss = resultDic[@"from"];
//            if (resultHandler) {
//                resultHandler(neo_addrss, YES);
//            }
//        } else {
//            if (resultHandler) {
//                resultHandler(nil, NO);
//            }
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        if (resultHandler) {
//            resultHandler(nil, NO);
//        }
//        DDLogDebug(@"getnep5transferbytxid error=%@",error);
//    }];
//
//}

- (void)nep5_getLockInfo:(NSString *)lockTxId resultHandler:(QContractResultBlock)resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    NSString *requestId = [NSString randomOf32];
    //    kWeakSelf(self);
    NSArray *params = @[lockTxId];
    DDLogDebug(@"nep5_getLockInfo params = %@",params);
    [client invokeMethod:@"nep5_getLockInfo" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"nep5_getLockInfo responseObject=%@",responseObject);
        
        if (responseObject) {
//            NSString *neo_address = responseObject[@"neoAddress"];
            if (resultHandler) {
//                resultHandler(neo_address, YES, nil);
                resultHandler(responseObject, YES, nil);
            }
        } else {
            if (resultHandler) {
                NSString *des = [@"nep5_getLockInfo error" stringByAppendingFormat:@"   ***method:%@    ***error:%@",@"nep5_getLockInfo",[responseObject mj_JSONString]];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *des = [@"nep5_getLockInfo error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_getLockInfo",error.description];
            resultHandler(nil, NO, des);
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        
        NSLog(@"error=%@",error);
    }];
    
}

- (void)nep5_benefitWithdraw:(NSString *)lockTxId beneficial:(NSString *)beneficial amount:(NSString *)amount qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey neo_publicKey:(NSString *)neo_publicKey neo_privateKey:(NSString *)neo_privateKey multisigAddress:(NSString *)multisigAddress resultHandler:(QContractResultBlock)resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSArray *params = @[@{@"beneficial":beneficial,@"amount":amount,@"pType":@"vote"},lockTxId];
    DDLogDebug(@"nep5_benefitWithdraw params = %@",params);
    [client invokeMethod:@"nep5_benefitWithdraw" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"nep5_benefitWithdraw responseObject=%@",responseObject);
        
        if (responseObject) {
            [weakself request_UnlockTxParams:responseObject lockTxId:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey neo_publicKey:neo_publicKey neo_privateKey:neo_privateKey multisigAddress:multisigAddress resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                NSString *des = [@"nep5_benefitWithdraw error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_benefitWithdraw",[responseObject mj_JSONString]];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *des = [@"nep5_benefitWithdraw error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_benefitWithdraw",error.description];
            resultHandler(nil, NO, des);
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        
        NSLog(@"error=%@",error);
    }];
    
}

#pragma mark - UnlockTxParams
- (void)request_UnlockTxParams:(NSDictionary *)signAndWorkDic lockTxId:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey neo_publicKey:(NSString *)neo_publicKey neo_privateKey:(NSString *)neo_privateKey multisigAddress:(NSString *)multisigAddress resultHandler:(QContractResultBlock)resultHandler {
    
    kWeakSelf(self);
    NSDictionary *params = @{@"multisigAddress":multisigAddress,@"txid":lockTxId};
    [RequestService requestWithUrl5:sys_contract_unlock_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        DDLogDebug(@"UnlockTxParams responseObject=%@",responseObject);
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSDictionary *result = responseObject[Server_Data][@"result"];
            NSString *unsignedRawTx = result[@"unsignedRawTx"];
            NSString *unlockTxId = result[@"unlockTxId"];
            NSArray *argu1 = @[unsignedRawTx,neo_privateKey];
            DDLogDebug(@"staking.signature argu1 = %@",argu1);
            kWeakSelf(self);
            [weakself.dwebview callHandler:@"staking.signature" arguments:argu1 completionHandler:^(NSDictionary * _Nullable value) {
                DDLogDebug(@"signature: %@",value);
                
                NSString *signature = value[@"signature"];
                NSDictionary *unlockTxParams = @{@"unsignedRawTx":unsignedRawTx, @"signature":signature, @"publicKey":neo_publicKey, @"unlockTxId":unlockTxId};
                [weakself signAndWork:signAndWorkDic qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey lockTxId:lockTxId unlockTxParams:unlockTxParams resultHandler:resultHandler];
            }];
        } else {
            if (resultHandler) {
                NSString *des = [@"signature error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",sys_contract_unlock_Url,[responseObject mj_JSONString]];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (resultHandler) {
            NSString *des = [@"signature error" stringByAppendingFormat:@"   ***method:%@    ***error:%@",sys_contract_unlock_Url,error.description];
            resultHandler(nil, NO, des);
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        DDLogDebug(@"UnlockTxParams error=%@",error);
    }];
    
//    NSDictionary *params = @{@"multisigAddress":multisigAddress,@"txid":lockTxId};
//    NSString *urlStr = @"http://192.168.0.190:8080/dapp/api/sys/contract_unlock.json";
//
//    kWeakSelf(self);
//    DDLogDebug(@"UnlockTxParams urlStr = %@  params = %@",urlStr, params);
//    [RequestService normalRequestWithBaseURLStr8:urlStr params:params httpMethod:HttpMethodPost userInfo:nil requestManagerType: QRequestManagerTypeHTTP successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//
//    }];
    
}

#pragma mark - Mintage Pledge
- (void)mintage_createMultiSig:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey tokenName:(NSString *)tokenName tokenSymbol:(NSString *)tokenSymbol totalSupply:(NSString *)totalSupply decimals:(NSString *)decimals resultHandler:(QContractResultBlock)resultHandler {
    
    NSArray *argu1 = @[neo_publicKey,PublicKeyB];
    DDLogDebug(@"staking.createMultiSig argu1 = %@",argu1);
    kWeakSelf(self);
    [_dwebview callHandler:@"staking.createMultiSig" arguments:argu1 completionHandler:^(NSDictionary * _Nullable value) {
        DDLogDebug(@"createMultiSig: %@",value);
        
        NSString *toAddress = value[@"_address"];
        
        [weakself mintage_contractLock:neo_publicKey neo_wifKey:neo_wifKey fromAddress:fromAddress toAddress:toAddress qlcAddress:qlcAddress qlcAmount:qlcAmount lockTime:lockTime qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey tokenName:tokenName tokenSymbol:tokenSymbol totalSupply:totalSupply decimals:decimals resultHandler:resultHandler];
    }];
}

- (void)mintage_contractLock:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey tokenName:(NSString *)tokenName tokenSymbol:(NSString *)tokenSymbol totalSupply:(NSString *)totalSupply decimals:(NSString *)decimals resultHandler:(QContractResultBlock)resultHandler {
    NSArray *argu2 = @[neo_wifKey,fromAddress,toAddress,qlcAddress,qlcAmount,lockTime];
    DDLogDebug(@"staking.contractLock argu2 = %@",argu2);
    kWeakSelf(self);
    [_dwebview callHandler:@"staking.contractLock" arguments:argu2 completionHandler:^(NSDictionary * _Nullable value) {
        DDLogDebug(@"contractLock: %@",value);
        
        NSInteger result = [value[@"result"] integerValue];
        if (result == 1) {
            NSString *lockTxId = value[@"txid"];

            [weakself nep5_prePareMintagePledge:qlcAddress tokenName:tokenName tokenSymbol:tokenSymbol totalSupply:totalSupply decimals:decimals multiSigAddress:toAddress neo_publicKey:neo_publicKey lockTxId:lockTxId qlc_privateKey:qlc_privateKey qlc_publicKey:qlc_publicKey resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                NSString *des = [@"contractLock error" stringByAppendingFormat:@"   ***method:%@    ***error:%@",@"staking.contractLock",[value mj_JSONString]];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
        
    }];
}

- (void)nep5_prePareMintagePledge:(NSString *)qlcAddress tokenName:(NSString *)tokenName tokenSymbol:(NSString *)tokenSymbol totalSupply:(NSString *)totalSupply decimals:(NSString *)decimals multiSigAddress:(NSString *)multiSigAddress neo_publicKey:(NSString *)neo_publicKey lockTxId:(NSString *)lockTxId qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(QContractResultBlock)resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSArray *params = @[@{@"beneficial":qlcAddress,@"tokenName":tokenName,@"tokenSymbol":tokenSymbol,@"totalSupply":totalSupply,@"decimals":decimals},@{@"multiSigAddress":multiSigAddress,@"publicKey":neo_publicKey,@"lockTxId":lockTxId}];
    DDLogDebug(@"nep5_prePareMintagePledge params = %@",params);
    [client invokeMethod:@"nep5_prePareMintagePledge" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"nep5_prePareMintagePledge responseObject=%@",responseObject);
        
        if ([responseObject integerValue] == 1) {
            [weakself mintage_getnep5transferbytxid:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                NSString *des = [@"nep5_prePareMintagePledge error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_prePareMintagePledge",[responseObject mj_JSONString]];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *des = [@"nep5_prePareMintagePledge error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_prePareMintagePledge",error.description];
            resultHandler(nil, NO, des);
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        NSLog(@"error=%@",error);
    }];
    
}

- (void)mintage_getnep5transferbytxid:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(QContractResultBlock)resultHandler {
//    NSString *requestId = [NSString randomOf32];
//    NSDictionary *params = @{@"jsonrpc":@"2.0",@"method":@"getnep5transferbytxid",@"params":[NSString stringWithFormat:@"[\"%@\"]",lockTxId],@"id":requestId};
//    NSString *urlStr = @"https://api.nel.group/api/mainnet";
    NSDictionary *params = nil;
    NSString *urlStr = [NSString stringWithFormat:@"https://api.neoscan.io/api/main_net/v1/get_transaction/%@",lockTxId];
    
    kWeakSelf(self);
    DDLogDebug(@"mintage_getnep5transferbytxid urlStr = %@",urlStr);
    [RequestService normalRequestWithBaseURLStr8:urlStr params:params httpMethod:HttpMethodGet userInfo:nil requestManagerType: QRequestManagerTypeHTTP successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        DDLogDebug(@"mintage_getnep5transferbytxid responseObject=%@",responseObject);
        NSDictionary *responseDic = [responseObject mj_JSONObject];
//        NSArray *resultDic = responseDic[@"result"];
        if (responseDic) {
            [weakself nep5_benefitPledge:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
        } else {
//            NSDictionary *errorDic = responseDic[@"error"];
//            NSString *dataStr = errorDic[@"data"];
//            if ([dataStr isEqualToString:@"Data does not exist"]) {
//                int64_t delayInSeconds = 3.0; // 延迟的时间
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [weakself mintage_getnep5transferbytxid:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
//                });
//            } else {
                if (resultHandler) {
                    NSString *des = [@"neo_get_transaction error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",urlStr,[responseObject mj_JSONString]];
                    resultHandler(nil, NO, des);
                    NSString *className = NSStringFromClass([self class]);
                    NSString *methodName = NSStringFromSelector(_cmd);
                    [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
                }
//            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        int64_t delayInSeconds = 3.0; // 延迟的时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself mintage_getnep5transferbytxid:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
        });

//        if (resultHandler) {
//            resultHandler(nil, NO);
//        }
//        DDLogDebug(@"getnep5transferbytxid error=%@",error);
    }];
    
}

- (void)nep5_mintagePledge:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(QContractResultBlock)resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSArray *params = @[lockTxId];
    DDLogDebug(@"nep5_mintagePledge params = %@",params);
    [client invokeMethod:@"nep5_mintagePledge" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"nep5_mintagePledge responseObject=%@",responseObject);
        
        if (responseObject) {
            [weakself signAndWork:responseObject qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey lockTxId:lockTxId unlockTxParams:nil resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                NSString *des = [@"nep5_mintagePledge error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_mintagePledge",[responseObject mj_JSONString]];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *des = [@"nep5_mintagePledge error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_mintagePledge",error.description];
            resultHandler(nil, NO, des);
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        
        NSLog(@"error=%@",error);
    }];
    
}

#pragma mark - Mintag Withdraw
- (void)nep5_mintageWithdraw:(NSString *)lockTxId tokenId:(NSString *)tokenId resultHandler:(QContractResultBlock)resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
//    kWeakSelf(self);
    NSArray *params = @[tokenId,lockTxId];
    DDLogDebug(@"nep5_mintageWithdraw params = %@",params);
    [client invokeMethod:@"nep5_mintageWithdraw" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"nep5_mintageWithdraw responseObject=%@",responseObject);
        
        if (responseObject) {
            if (resultHandler) {
                resultHandler(responseObject, YES, nil);
            }
        } else {
            if (resultHandler) {
                NSString *des = [@"nep5_mintageWithdraw error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_mintageWithdraw",[responseObject mj_JSONString]];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *des = [@"nep5_mintageWithdraw error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"nep5_mintageWithdraw",error.description];
            resultHandler(nil, NO, des);
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        
        NSLog(@"error=%@",error);
    }];
    
}

#pragma mark - SignAndWork
- (void)signAndWork:(NSDictionary *)dic qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey lockTxId:(NSString *)lockTxId unlockTxParams:(NSDictionary *)unlockTxParams resultHandler:(QContractResultBlock)resultHandler {
    kWeakSelf(self);
    [QLCWalletManage signAndWork:dic publicKey:qlc_publicKey privateKey:qlc_privateKey resultHandler:^(NSDictionary * _Nullable responseDic) {
        if (responseDic) {
            [weakself ledger_process:lockTxId blockDic:responseDic unlockTxParams:unlockTxParams resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                NSString *des = [@"sign_work error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"signAndWork",[responseDic mj_JSONString]];
                resultHandler(nil, NO, des);
                NSString *className = NSStringFromClass([self class]);
                NSString *methodName = NSStringFromSelector(_cmd);
                [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
            }
        }
    }];
}

#pragma mark - Process
- (void)ledger_process:(NSString *)lockTxId blockDic:(NSDictionary *)blockDic unlockTxParams:(NSDictionary *)unlockTxParams resultHandler:(QContractResultBlock)resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    NSArray *params = @[blockDic,lockTxId];
    if (unlockTxParams) {
        params = @[blockDic,lockTxId,unlockTxParams];
    }
    
    DDLogDebug(@"ledger_process params = %@",params);
    [client invokeMethod:@"ledger_process" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"ledger_process responseObject=%@",responseObject);
        
//        NSString *result = responseObject[@"result"];
        if (resultHandler) {
            resultHandler(responseObject, YES, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            NSString *des = [@"ledger_process error" stringByAppendingFormat:@"   ***method:%@    ***error:%@",@"ledger_process",error.description];
            resultHandler(nil, NO, des);
            NSString *className = NSStringFromClass([self class]);
            NSString *methodName = NSStringFromSelector(_cmd);
            [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
        }
        NSLog(@"error=%@",error);
    }];
    
}

@end
