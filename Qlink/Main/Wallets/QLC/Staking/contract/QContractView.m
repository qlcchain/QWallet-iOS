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
- (void)benefit_createMultiSig:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
    
    NSArray *argu1 = @[neo_publicKey,PublicKeyB];
    DDLogDebug(@"staking.createMultiSig argu1 = %@",argu1);
    kWeakSelf(self);
    [_dwebview callHandler:@"staking.createMultiSig" arguments:argu1 completionHandler:^(NSDictionary * _Nullable value) {
        DDLogDebug(@"createMultiSig: %@",value);
        
        NSString *toAddress = value[@"_address"];
        
        [weakself benefit_contractLock:neo_publicKey neo_wifKey:neo_wifKey fromAddress:fromAddress toAddress:toAddress qlcAddress:qlcAddress qlcAmount:qlcAmount lockTime:lockTime qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
    }];
}

- (void)benefit_contractLock:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
    NSArray *argu2 = @[neo_wifKey,fromAddress,toAddress,qlcAddress,qlcAmount,lockTime];
    DDLogDebug(@"staking.contractLock argu2 = %@",argu2);
    kWeakSelf(self);
    [_dwebview callHandler:@"staking.contractLock" arguments:argu2 completionHandler:^(NSDictionary * _Nullable value) {
        DDLogDebug(@"contractLock: %@",value);
        
        NSInteger result = [value[@"result"] integerValue];
        if (result == 1) {
            NSString *lockTxId = value[@"txid"];
            [weakself nep5_prePareBenefitPledge:qlcAddress qlcAmount:qlcAmount multiSigAddress:toAddress neo_publicKey:neo_publicKey lockTxId:lockTxId qlc_privateKey:qlc_privateKey qlc_publicKey:qlc_publicKey resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                resultHandler(nil, NO);
            }
        }
        
    }];
}

- (void)nep5_prePareBenefitPledge:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount multiSigAddress:(NSString *)multiSigAddress neo_publicKey:(NSString *)neo_publicKey lockTxId:(NSString *)lockTxId qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
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
                resultHandler(nil, NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            resultHandler(nil, NO);
        }
        NSLog(@"error=%@",error);
    }];
    
}

- (void)benefit_getnep5transferbytxid:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
    NSString *requestId = [NSString randomOf32];
    NSDictionary *params = @{@"jsonrpc":@"2.0",@"method":@"getnep5transferbytxid",@"params":[NSString stringWithFormat:@"[\"%@\"]",lockTxId],@"id":requestId};
    NSString *urlStr = @"https://api.nel.group/api/mainnet";
//    NSString *urlStr = [NSString stringWithFormat:@"https://api.nel.group/api/mainnet?jsonrpc=2.0&method=getnep5transferbytxid&params=[\"%@\"]&id=%@",lockTxId,requestId];
    
    kWeakSelf(self);
    DDLogDebug(@"benefit_getnep5transferbytxid urlStr = %@",urlStr);
    [RequestService testRequestWithBaseURLStr8:urlStr params:params httpMethod:HttpMethodGet userInfo:nil requestManagerType: QRequestManagerTypeHTTP successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        DDLogDebug(@"benefit_getnep5transferbytxid responseObject=%@",responseObject);
        NSDictionary *responseDic = [responseObject mj_JSONObject];
        NSDictionary *resultDic = responseDic[@"result"];
        if (resultDic) {
            [weakself nep5_benefitPledge:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
        } else {
            NSDictionary *errorDic = responseDic[@"error"];
            NSString *dataStr = errorDic[@"data"];
            if ([dataStr isEqualToString:@"Data does not exist"]) {
                int64_t delayInSeconds = 3.0; // 延迟的时间
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself benefit_getnep5transferbytxid:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
                });
            } else {
                if (resultHandler) {
                    resultHandler(nil, NO);
                }
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (resultHandler) {
            resultHandler(nil, NO);
        }
        DDLogDebug(@"getnep5transferbytxid error=%@",error);
    }];
    
}

- (void)nep5_benefitPledge:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSArray *params = @[lockTxId];
    DDLogDebug(@"nep5_benefitPledge params = %@",params);
    [client invokeMethod:@"nep5_benefitPledge" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"nep5_benefitPledge responseObject=%@",responseObject);
        
        if (responseObject) {
            [weakself signAndWork:responseObject qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey lockTxId:lockTxId resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                resultHandler(nil, NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            resultHandler(nil, NO);
        }
        
        NSLog(@"error=%@",error);
    }];
    
}

#pragma mark - Benefit Withdraw
- (void)nep5_benefitWithdraw:(NSString *)lockTxId beneficial:(NSString *)beneficial amount:(NSString *)amount qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSArray *params = @[@{@"beneficial":beneficial,@"amount":amount,@"pType":@"vote"},lockTxId];
    DDLogDebug(@"nep5_benefitWithdraw params = %@",params);
    [client invokeMethod:@"nep5_benefitWithdraw" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"nep5_benefitWithdraw responseObject=%@",responseObject);
        
        if (responseObject) {
            [weakself signAndWork:responseObject qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey lockTxId:lockTxId resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                resultHandler(nil, NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            resultHandler(nil, NO);
        }
        
        NSLog(@"error=%@",error);
    }];
    
}

#pragma mark - Mintage Pledge
- (void)mintage_createMultiSig:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey tokenName:(NSString *)tokenName tokenSymbol:(NSString *)tokenSymbol totalSupply:(NSString *)totalSupply decimals:(NSString *)decimals resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
    
    NSArray *argu1 = @[neo_publicKey,PublicKeyB];
    DDLogDebug(@"staking.createMultiSig argu1 = %@",argu1);
    kWeakSelf(self);
    [_dwebview callHandler:@"staking.createMultiSig" arguments:argu1 completionHandler:^(NSDictionary * _Nullable value) {
        DDLogDebug(@"createMultiSig: %@",value);
        
        NSString *toAddress = value[@"_address"];
        
        [weakself mintage_contractLock:neo_publicKey neo_wifKey:neo_wifKey fromAddress:fromAddress toAddress:toAddress qlcAddress:qlcAddress qlcAmount:qlcAmount lockTime:lockTime qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey tokenName:tokenName tokenSymbol:tokenSymbol totalSupply:totalSupply decimals:decimals resultHandler:resultHandler];
    }];
}

- (void)mintage_contractLock:(NSString *)neo_publicKey neo_wifKey:(NSString *)neo_wifKey fromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress qlcAddress:(NSString *)qlcAddress qlcAmount:(NSString *)qlcAmount lockTime:(NSString *)lockTime qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey tokenName:(NSString *)tokenName tokenSymbol:(NSString *)tokenSymbol totalSupply:(NSString *)totalSupply decimals:(NSString *)decimals resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
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
                resultHandler(nil, NO);
            }
        }
        
    }];
}

- (void)nep5_prePareMintagePledge:(NSString *)qlcAddress tokenName:(NSString *)tokenName tokenSymbol:(NSString *)tokenSymbol totalSupply:(NSString *)totalSupply decimals:(NSString *)decimals multiSigAddress:(NSString *)multiSigAddress neo_publicKey:(NSString *)neo_publicKey lockTxId:(NSString *)lockTxId qlc_privateKey:(NSString *)qlc_privateKey qlc_publicKey:(NSString *)qlc_publicKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
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
                resultHandler(nil, NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            resultHandler(nil, NO);
        }
        NSLog(@"error=%@",error);
    }];
    
}

- (void)mintage_getnep5transferbytxid:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
    NSString *requestId = [NSString randomOf32];
    NSDictionary *params = @{@"jsonrpc":@"2.0",@"method":@"getnep5transferbytxid",@"params":[NSString stringWithFormat:@"[\"%@\"]",lockTxId],@"id":requestId};
    NSString *urlStr = @"https://api.nel.group/api/mainnet";
    //    NSString *urlStr = [NSString stringWithFormat:@"https://api.nel.group/api/mainnet?jsonrpc=2.0&method=getnep5transferbytxid&params=[\"%@\"]&id=%@",lockTxId,requestId];
    
    kWeakSelf(self);
    DDLogDebug(@"mintage_getnep5transferbytxid urlStr = %@",urlStr);
    [RequestService testRequestWithBaseURLStr8:urlStr params:params httpMethod:HttpMethodGet userInfo:nil requestManagerType: QRequestManagerTypeHTTP successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        DDLogDebug(@"mintage_getnep5transferbytxid responseObject=%@",responseObject);
        NSDictionary *responseDic = [responseObject mj_JSONObject];
        NSDictionary *resultDic = responseDic[@"result"];
        if (resultDic) {
            [weakself nep5_benefitPledge:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
        } else {
            NSDictionary *errorDic = responseDic[@"error"];
            NSString *dataStr = errorDic[@"data"];
            if ([dataStr isEqualToString:@"Data does not exist"]) {
                int64_t delayInSeconds = 3.0; // 延迟的时间
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself mintage_getnep5transferbytxid:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:resultHandler];
                });
            } else {
                if (resultHandler) {
                    resultHandler(nil, NO);
                }
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (resultHandler) {
            resultHandler(nil, NO);
        }
        DDLogDebug(@"getnep5transferbytxid error=%@",error);
    }];
    
}

- (void)nep5_mintagePledge:(NSString *)lockTxId qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSArray *params = @[lockTxId];
    DDLogDebug(@"nep5_mintagePledge params = %@",params);
    [client invokeMethod:@"nep5_mintagePledge" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"nep5_mintagePledge responseObject=%@",responseObject);
        
        if (responseObject) {
            [weakself signAndWork:responseObject qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey lockTxId:lockTxId resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                resultHandler(nil, NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            resultHandler(nil, NO);
        }
        
        NSLog(@"error=%@",error);
    }];
    
}

#pragma mark - Mintag Withdraw
- (void)nep5_mintageWithdraw:(NSString *)lockTxId tokenId:(NSString *)tokenId resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
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
                resultHandler(responseObject, YES);
            }
        } else {
            if (resultHandler) {
                resultHandler(nil, NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            resultHandler(nil, NO);
        }
        
        NSLog(@"error=%@",error);
    }];
    
}





#pragma mark - SignAndWork
- (void)signAndWork:(NSDictionary *)dic qlc_publicKey:(NSString *)qlc_publicKey qlc_privateKey:(NSString *)qlc_privateKey lockTxId:(NSString *)lockTxId resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
    kWeakSelf(self);
    [QLCWalletManage signAndWork:dic publicKey:qlc_publicKey privateKey:qlc_privateKey resultHandler:^(NSDictionary * _Nullable responseDic) {
        if (responseDic) {
            [weakself ledger_process:lockTxId blockDic:responseDic resultHandler:resultHandler];
        } else {
            if (resultHandler) {
                resultHandler(nil, NO);
            }
        }
    }];
}

#pragma mark - Process
- (void)ledger_process:(NSString *)lockTxId blockDic:(NSDictionary *)blockDic resultHandler:(void (^)(NSString *result, BOOL success))resultHandler {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    NSArray *params = @[blockDic,lockTxId];
    DDLogDebug(@"ledger_process params = %@",params);
    [client invokeMethod:@"ledger_process" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"ledger_process responseObject=%@",responseObject);
        
//        NSString *result = responseObject[@"result"];
        if (resultHandler) {
            resultHandler(responseObject, YES);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (resultHandler) {
            resultHandler(nil, NO);
        }
        NSLog(@"error=%@",error);
    }];
    
}

@end
