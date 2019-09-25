//
//  TopupWebViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupWebViewController.h"
#import <WebKit/WebKit.h>
//#import "dsbridge.h"

@interface TopupWebViewController () <WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
//@property (nonatomic, strong) DWKWebView *dwebview;
@property (nonatomic, strong) WKWebView *dwebview;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation TopupWebViewController

- (void)dealloc {
    [_dwebview removeObserver:self
                    forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
//    _dwebview=[[DWKWebView alloc] initWithFrame:CGRectZero];
    _dwebview=[[WKWebView alloc] initWithFrame:CGRectZero];
    [_contentView addSubview:_dwebview];
    kWeakSelf(self);
    [_dwebview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.contentView).offset(0);
    }];
    
    // register api object without namespace
//    [_dwebview addJavascriptObject:[[JsApiTest alloc] init] namespace:@"staking"];
//
//#ifdef DEBUG
//    [_dwebview setDebugMode:true];
//#else
//    [_dwebview setDebugMode:false];
//#endif
//
//    [_dwebview customJavascriptDialogLabelTitles:@{@"alertTitle":@"Notification",@"alertBtn":@"OK"}];
    
    _dwebview.navigationDelegate=self;
    
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:path];
//    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"contract" ofType:@"html"];
//    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
//                                                       encoding:NSUTF8StringEncoding
//                                                          error:nil];
//    [_dwebview loadHTMLString:htmlContent baseURL:baseURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://shop.huagaotx.cn/wap/charge_v3.html?sid=8a51FmcnWGH-j2F-g9Ry2KT4FyZ_Rr5xcKdt7i96&trace_id=mm_1000001_998902&package=0"]];
    [_dwebview loadRequest:urlRequest];
    
    // set javascript close listener
//    [_dwebview setJavascriptCloseWindowListener:^{
//        NSLog(@"window.close called");
//    } ];
    
    [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255
                                                     green:240.0/255
                                                      blue:240.0/255
                                                     alpha:1.0]];
    _progressView.progressTintColor = [UIColor greenColor];
    // 添加进度观察者
    [_dwebview addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                    options:0
                    context:nil];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    if ([_dwebview canGoBack]) {
        [_dwebview goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    DDLogDebug(@"didStartProvisionalNavigation");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DDLogDebug(@"didFailProvisionalNavigation");
    [self.progressView setProgress:0.0f animated:NO];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    DDLogDebug(@"didCommitNavigation");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    DDLogDebug(@"didFinishNavigation");
//    [self getCookie];
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    DDLogDebug(@"didFailNavigation");
    [self.progressView setProgress:0.0f animated:NO];
}
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    DDLogDebug(@"didReceiveServerRedirectForProvisionalNavigation");
}
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    DDLogDebug(@"decidePolicyForNavigationAction");
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    //自己定义的协议头
//    NSString *htmlHeadString = @"github://";
//    if([urlStr hasPrefix:htmlHeadString]){
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通过截取URL调用OC" message:@"你想前往我的Github主页?" preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }])];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSURL * url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"github://callName_?" withString:@""]];
//            [[UIApplication sharedApplication] openURL:url];
//        }])];
//        [self presentViewController:alertController animated:YES completion:nil];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
//    }
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    DDLogDebug(@"decidePolicyForNavigationResponse");
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//    DDLogDebug(@"didReceiveAuthenticationChallenge");
//    //用户身份信息
//    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
//    //为 challenge 的发送方提供 credential
//    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
//    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
//}

//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    DDLogDebug(@"webViewWebContentProcessDidTerminate");
}


#pragma mark - KVO
//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _dwebview) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = _dwebview.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:_dwebview.estimatedProgress
                              animated:animated];
        
        if (_dwebview.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f animated:NO];
                             }];
        }
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}


@end
