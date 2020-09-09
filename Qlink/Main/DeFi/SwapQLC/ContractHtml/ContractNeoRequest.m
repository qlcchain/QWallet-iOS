//
//  ContractNeoRequest.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "ContractNeoRequest.h"
#import <WebKit/WebKit.h>
#import "dsbridge.h"
#import "JsApiTest.h"
#import "GlobalConstants.h"
#import "SystemUtil.h"
#import "NSString+Hash.h"

@interface ContractNeoRequest () <WKNavigationDelegate> {
    JsApiTest *jsApi;
    
}
@property (nonatomic, assign) NSInteger nepCheckCount;
@property (nonatomic, assign) NSInteger processCheckCount;
@property (nonatomic, strong) DWKWebView *dwebview;
//@property (nonatomic, copy) QContractStageBlock stageBlock;

@end

@implementation ContractNeoRequest

+ (ContractNeoRequest *)addContractNeoRequest {
    ContractNeoRequest *contractV = [ContractNeoRequest new];
    contractV.frame = CGRectZero;
    [contractV config];
    [kAppD.window addSubview:contractV];
    return contractV;
}

+ (void)removeContractNeoRequest:(ContractNeoRequest *)contractV {
    if (contractV) {
        [contractV removeFromSuperview];
    }
}

#pragma mark - Operation
- (void)config {
    _dwebview=[[DWKWebView alloc] initWithFrame:CGRectZero];
    [self addSubview:_dwebview];
    
    // register api object without namespace  ethSmartContract  staking
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
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"neonjs" ofType:@"html"];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    [_dwebview loadHTMLString:htmlContent baseURL:baseURL];
    
    // set javascript close listener
    [_dwebview setJavascriptCloseWindowListener:^{
        NSLog(@"window.close called");
    } ];
}
- (void) testNeoContract {
    
    NSString *hash = [SystemUtil uuidString];
       NSLog(@"原文:%@",hash);
    NSString *rHash = [hash sha256String];
    NSString *wrapperAddress = @"ARNpaFJhp6SHziRomrK4cenWw66C8VVFyv";
    NSString *prviteKey = @"bfb571c8fa917182b0965af45d0fd3464f0393bac01a2589f402d562ce61f3bb";
//    [_dwebview callHandler:@"staking.userLock"
//                 arguments:@[prviteKey,wrapperAddress,rHash,@(6),@(15)] completionHandler:^(id  _Nullable value) {
//        NSLog(@"value = %@",value);
//    }];
    [_dwebview callHandler:@"staking.testContract1"
                    arguments:@[prviteKey] completionHandler:^(id  _Nullable value) {
           NSLog(@"value = %@",value);
       }];
}

@end
