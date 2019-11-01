//
//  QContractView.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/4.
//  Copyright © 2019 pan. All rights reserved.
//

#import "NEOJSView.h"
#import "dsbridge.h"
#import "JsApiTest.h"
#import <WebKit/WebKit.h>
#import "WalletCommonModel.h"
#import "GlobalConstants.h"
#import "QLogHelper.h"

static NSString * const PublicKeyB = @"02c6e68c61480003ed163f72b41cbb50ded29d79e513fd299d2cb844318b1b8ad5";

@interface NEOJSView () <WKNavigationDelegate> {
    JsApiTest *jsApi;
}

@property (nonatomic, strong) DWKWebView *dwebview;

@end

@implementation NEOJSView

+ (NEOJSView *)add {
    NEOJSView *contractV = [NEOJSView new];
    contractV.frame = CGRectZero;
    [contractV config];
    [kAppD.window addSubview:contractV];
    return contractV;
}

- (void)remove {
    if (self) {
        [self removeFromSuperview];
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
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"qwallet_js" ofType:@"html"];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    [_dwebview loadHTMLString:htmlContent baseURL:baseURL];
    
    // set javascript close listener
    [_dwebview setJavascriptCloseWindowListener:^{
        NSLog(@"window.close called");
    } ];
}

#pragma mark - JS转账
- (void)neoTransferWithFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress assetHash:(NSString *)assetHash amount:(NSString *)amount numOfDecimals:(NSString *)numOfDecimals wif:(NSString *)wif resultHandler:(NEOJSResultBlock)resultHandler {
    
    NSArray *argu1 = @[fromAddress, toAddress, assetHash, amount, numOfDecimals, wif];
    DDLogDebug(@"staking.send argu1 = %@",argu1);
//    kWeakSelf(self);
    [_dwebview callHandler:@"staking.send" arguments:argu1 completionHandler:^(NSDictionary *value) {
        DDLogDebug(@"staking.send: %@",value);
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSString *result = value[@"result"];
            if ([result integerValue] == 1) {
                NSString *txid = value[@"txid"];
                if (txid) {
                    if (resultHandler) {
                        resultHandler(txid,YES,nil);
                    }
                } else {
                    if (resultHandler) {
                        resultHandler(nil,NO,@"");
                    }
                    [NEOJSView saveLog:value];
                }
            } else {
                if (resultHandler) {
                    resultHandler(nil,NO,@"");
                }
                [NEOJSView saveLog:value];
            }
        } else {
            if (resultHandler) {
                resultHandler(nil,NO,@"");
            }
            [NEOJSView saveLog:value];
        }
    }];
}

+ (void)saveLog:(NSDictionary *)dic {
    NSString *des = [@"staking.send error" stringByAppendingFormat:@"   ***method:%@   ***error:%@",@"staking.send",dic];
    NSString *className = NSStringFromClass([self class]);
    NSString *methodName = NSStringFromSelector(_cmd);
    [QLogHelper requestLog_saveWithClass:className method:methodName logStr:des];
}

@end
