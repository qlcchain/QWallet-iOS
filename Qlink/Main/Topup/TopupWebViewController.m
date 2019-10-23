//
//  WebViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "TopupWebViewController.h"
#import <WebKit/WebKit.h>

@interface TopupWebViewController ()<WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *myWebView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//设置加载进度条
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic) BOOL checkmwebLoad;

@end

@implementation TopupWebViewController

- (IBAction)clickBack:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _checkmwebLoad = NO;
    _myWebView.navigationDelegate = self;
    
    [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255
                                                     green:240.0/255
                                                      blue:240.0/255
                                                     alpha:1.0]];
    _progressView.progressTintColor = [UIColor greenColor];
    // 添加进度观察者
    [_myWebView addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                    options:0
                    context:nil];
    
//    //allWebsiteDataTypes清除所有缓存
//    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
//    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
//    }];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_inputUrl?:@""] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [_myWebView loadRequest:request];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让进度条显示
    self.progressView.hidden = NO;
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
  
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailProvisionalNavigation %@",error);
    // NSStringLocalizable(@"request_error")
//    [kAppD.window showHint:error.domain];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [kAppD.window makeToastDisappearWithText:NSStringLocalizable(@"request_error")];
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request        = navigationAction.request;
        NSString     *scheme         = [request.URL scheme];
        // decode for all URL to avoid url contains some special character so that it wasn't load.
        NSString     *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
        NSLog(@"Current URL is %@",absoluteString);
        
        static NSString *endPayRedirectURL = nil;
        
        // Wechat Pay, Note : modify redirect_url to resolve we couldn't return our app from wechat client.
        if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] && ![absoluteString hasSuffix:[NSString stringWithFormat:@"redirect_url=%@://",Weixin_Pay_Url_Scheme]]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            // 1. If the url contain "redirect_url" : We need to remember it to use our scheme replace it.
            // 2. If the url not contain "redirect_url" , We should add it so that we will could jump to our app.
            //  Note : 2. if the redirect_url is not last string, you should use correct strategy, because the redirect_url's value may contain some "&" special character so that my cut method may be incorrect.
            NSString *redirectUrl = nil;
            if ([absoluteString containsString:@"redirect_url="]) {
                NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url"];
                endPayRedirectURL =  [absoluteString substringFromIndex:redirectRange.location+redirectRange.length+1];
                redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=%@://",Weixin_Pay_Url_Scheme]];
            }else {
                redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"&redirect_url=%@://",Weixin_Pay_Url_Scheme]];
            }
            
            NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
            newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
            newRequest.URL = [NSURL URLWithString:redirectUrl];
            [webView loadRequest:newRequest];
            return;
        }
        
        // Judge is whether to jump to other app.
        if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"] && ![scheme isEqualToString:@"file"]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            if ([scheme isEqualToString:@"weixin"]) {
                // The var endPayRedirectURL was our saved origin url's redirect address. We need to load it when we return from wechat client.
                if (endPayRedirectURL) {
                    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:endPayRedirectURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
                }
            }else if ([scheme isEqualToString:[NSString stringWithFormat:@"%@",Weixin_Pay_Url_Scheme]]) {
                
            }
            
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:request.URL];
            if (canOpen) {
                [[UIApplication sharedApplication] openURL:request.URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:nil];
                [self backToRoot];
            }
            return;
        }
        
        decisionHandler(WKNavigationActionPolicyAllow);
}

//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _myWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = _myWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:_myWebView.estimatedProgress
                              animated:animated];
        
        if (_myWebView.estimatedProgress >= 1.0f) {
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

-(void)dealloc{
    [_myWebView removeObserver:self
                        forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
