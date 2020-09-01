//
//  ContractETHRequest.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "ContractETHRequest.h"
#import <WebKit/WebKit.h>
#import "dsbridge.h"
#import "JsApiTest.h"
#import "GlobalConstants.h"
#import "SystemUtil.h"
#import "NSString+Hash.h"
#import "QSwapHashModel.h"
#import "NSDate+Category.h"
#import "QSwapAddressModel.h"

@interface ContractETHRequest () <WKNavigationDelegate> {
    JsApiTest *jsApi;
}
@property (nonatomic, assign) NSInteger nepCheckCount;
@property (nonatomic, assign) NSInteger processCheckCount;
@property (nonatomic, strong) DWKWebView *dwebview;
//@property (nonatomic, copy) QContractStageBlock stageBlock;

@end

@implementation ContractETHRequest

+ (ContractETHRequest *)addContractETHRequest {
    
    static ContractETHRequest *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
        shareObject.frame = CGRectZero;
        [shareObject config];
        [kAppD.window addSubview:shareObject];
    });
    return shareObject;
}

+ (void)removeContractETHRequest:(ContractETHRequest *)contractV {
    if (contractV) {
        [contractV removeFromSuperview];
    }
}

#pragma mark - Operation
- (void)config {
    _dwebview=[[DWKWebView alloc] initWithFrame:CGRectZero];
    [self addSubview:_dwebview];
    
    // register api object without namespace  ethSmartContract  staking
    [_dwebview addJavascriptObject:[[JsApiTest alloc] init] namespace:@"ethSmartContract"];
    
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
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"eth" ofType:@"html"];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    [_dwebview loadHTMLString:htmlContent baseURL:baseURL];
    
    // set javascript close listener
    [_dwebview setJavascriptCloseWindowListener:^{
        NSLog(@"window.close called");
    } ];
}
- (void) isSueUnlockWithPrivate:(NSString *) privateKey address:(NSString *) address rHash:(NSString *) rHash oHash:(NSString *) oHash gasPrice:(NSString *) gasPrice CompletionHandler:(void (^)(id responseObject)) success
{
     NSString *urlStr = [ConfigUtil get_eth_node_normal];
    //    [kAppD.window makeToastInView:kAppD.window text:NSStringLocalizable(@"loading")];
        [_dwebview callHandler:@"ethSmartContract.IssueUnlock" arguments:@[[QSwapAddressModel getShareObject].ethContract?:@"",urlStr,privateKey,address,gasPrice,rHash,oHash] completionHandler:^(id  _Nullable value) {
            NSLog(@"responseObjecgt = %@",value);
            
           // [kAppD.window hideToast];
            
            NSInteger reCode = [value[0] integerValue];
            
            if (reCode < 0) {
                success(nil);
                [kAppD.window makeToastDisappearWithText:@"Failed!"];
            } else {
                success(value[1]);
                [kAppD.window makeToastDisappearWithText:@"successfully!"];
            }
        }];
}
- (void) destoryFetchWithPrivate:(NSString *) privateKey address:(NSString *) address rhash:(NSString *) rhash {
    
    NSString *urlStr = [ConfigUtil get_eth_node_normal];
    [kAppD.window makeToastInView:kAppD.window text:NSStringLocalizable(@"loading")];
    [_dwebview callHandler:@"ethSmartContract.destoryFetch" arguments:@[[QSwapAddressModel getShareObject].ethContract?:@"",urlStr,privateKey,address,rhash] completionHandler:^(id  _Nullable value) {
           NSLog(@"value = %@",value);
            
            [kAppD.window hideToast];
            
            if ([value isEqualToString:@"-1"]) {
                
                [kAppD.window makeToastDisappearWithText:@"Failed!"];
                
            } else {
                
                [kAppD.window makeToastDisappearWithText:@"successfully!"];
            }
            
       }];
}

- (void) getGasPriceCompletionHandler:(void (^)(id responseObject)) success
{
    [_dwebview callHandler:@"ethSmartContract.getGasPrice" arguments:@[] completionHandler:^(id  _Nullable value) {
        NSLog(@"responseObjecgt = %@",value);
          
        success(value);
           
       }];
}

- (void) getBalanceOfhWithAddress:(NSString *) address completionHandler:(void (^)(id responseObject)) success {
    // balanceOf
    NSString *urlStr = [ConfigUtil get_eth_node_normal];
    [_dwebview callHandler:@"ethSmartContract.balanceOf" arguments:@[[QSwapAddressModel getShareObject].ethContract?:@"",urlStr,address] completionHandler:^(id  _Nullable value) {
        NSLog(@"responseObjecgt = %@",value);
        NSInteger reCode = [value[0] integerValue];
        if (reCode < 0) {
            success(nil);
        } else {
            success(value[1]);
        }
    }];
}
- (void) destoryFetchWithPrivate:(NSString *) privateKey address:(NSString *) address rhash:(NSString *) rhash gasPrice:(NSString *) gasPrice completionHandler:(void (^)(id responseObject)) success {
   
    NSString *urlStr = [ConfigUtil get_eth_node_normal];
//    [kAppD.window makeToastInView:kAppD.window text:NSStringLocalizable(@"loading")];
    [_dwebview callHandler:@"ethSmartContract.destoryFetch" arguments:@[[QSwapAddressModel getShareObject].ethContract,gasPrice,urlStr,privateKey,address,rhash] completionHandler:^(id  _Nullable value) {
        NSLog(@"responseObjecgt = %@",value);
        
       // [kAppD.window hideToast];
        
        NSInteger reCode = [value[0] integerValue];
        
        if (reCode < 0) {
            success(nil);
            [kAppD.window makeToastDisappearWithText:@"Failed!"];
        } else {
            success(value[1]);
            [kAppD.window makeToastDisappearWithText:@"successfully!"];
            // 删除本地hash记录
        }
    }];
}
- (void) destoryLockhWithPrivate:(NSString *) privateKey address:(NSString *) address toAddress:(NSString *) toAddress wrapperAddress:(NSString *) wrapperAddress amount:(NSInteger) amount gasPrice:(NSString *) gasPrice completionHandler:(void (^)(id responseObject)) success {
    
    // ETH -> NEP Lock
    NSString *urlStr = [ConfigUtil get_eth_node_normal];
    NSString *hash = [SystemUtil uuidString];
    NSLog(@"原文:%@",hash);
    NSString *rHash = [@"0x" stringByAppendingString:[hash sha256String]];
    NSLog(@"原文hash:%@",rHash);
    
    
    [_dwebview callHandler:@"ethSmartContract.destoryLock" arguments:@[[QSwapAddressModel getShareObject].ethContract?:@"",gasPrice,urlStr,privateKey,address,rHash,@(amount),wrapperAddress] completionHandler:^(id  _Nullable value) {
        
        NSLog(@"responseObjecgt = %@",value);
        
        NSInteger reCode = [value[0] integerValue];
        
        if (reCode < 0) {
            success(nil);
            [kAppD.window makeToastDisappearWithText:@"Failed to lock"];
            
        } else {
            
            success(value[1]);
            [kAppD.window makeToastDisappearWithText:@"Lock successfully!"];
            // 锁定成功 初始化对象
            QSwapHashModel *hashM = [[QSwapHashModel alloc] init];
            hashM.fromAddress = address;
            hashM.type = 2;
            hashM.amount = amount;
            hashM.rHash = rHash;
            hashM.rOrigin = hash;
            hashM.txHash = value[1];
            hashM.privateKey = privateKey;
            hashM.toAddress = toAddress;
            hashM.wrapperAddress = wrapperAddress;
            hashM.lockTime = [NSDate getTimestampFromDate:[NSDate date]];
            // 写入本地
            [QSwapHashModel addSwapHashWithSwapHashModel:hashM];
        }
        
    }];
    
    
//        NSString *privateKey = @"6048ad0d8cd9a99b8c94ae7347091cb1230f34a92ce30f2aa78c7ed59a62c3cd";
//       NSString *address = @"0xE0632e90d6eB6649CfD82f6d625769cCf9E7762f";
//       NSString *rhash = @"0x310ed827cff3bf5e32e6267341412ae33dc69bb723c2338b7f2014a02e1b77b2";
    
    
//    [_dwebview callHandler:@"ethSmartContract.lockedBalanceOf" arguments:@[address] completionHandler:^(id  _Nullable value) {
//        NSLog(@"value = %@",value);
//    }];
    
    
    // 转帐
    /*
    NSString *privateKey = @"67652fa52357b65255ac38d0ef8997b5608527a7c1d911ecefb8bc184d74e92e";
    NSString *address = @"0x0A8EFAacbeC7763855b9A39845DDbd03b03775C1";
    [_dwebview callHandler:@"ethSmartContract.transfer" arguments:@[privateKey,address,@"0xE0632e90d6eB6649CfD82f6d625769cCf9E7762f",@(1000)] completionHandler:^(id  _Nullable value) {
        NSLog(@"value = %@",value);
    }];
    */
}
- (void) tarnsrefTo {
     NSString *urlStr = [ConfigUtil get_eth_node_normal];
     NSString *privateKey = @"67652fa52357b65255ac38d0ef8997b5608527a7c1d911ecefb8bc184d74e92e";
       NSString *address = @"0x0A8EFAacbeC7763855b9A39845DDbd03b03775C1";
       [_dwebview callHandler:@"ethSmartContract.transfer" arguments:@[[QSwapAddressModel getShareObject].ethContract?:@"",urlStr,privateKey,address,@"0xE0632e90d6eB6649CfD82f6d625769cCf9E7762f",@(1000)] completionHandler:^(id  _Nullable value) {
           NSLog(@"value = %@",value);
       }];
}
@end
