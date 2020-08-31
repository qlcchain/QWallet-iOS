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
    [_dwebview callHandler:@"staking.testContract1" arguments:@[@"7010a57c867546ea27b38b23c99eaabf39b952e55c05c9da85c390c68b8e2737"] completionHandler:^(id  _Nullable value) {
        NSLog(@"value = %@",value);
    }];
}

@end
