//
//  SignView.m
//  Qlink
//
//  Created by 旷自辉 on 2020/6/12.
//  Copyright © 2020 pan. All rights reserved.
//

#import "SignView.h"
#import <Masonry/Masonry.h>

@interface SignView ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@end

@implementation SignView



#pragma mark------------人机验证 webview
- (void)loadLocalHtmlForJsWithHtmlName:(NSString *)htmlName{
    self.hName = htmlName;
    NSString *path = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:req];
}

-(void)loadHtmlWithHtmlName:(NSString*)htmlName webView:(WKWebView*)webView{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
}

- (void)getSlideData:(NSDictionary *)callData {
//{"token":nc_token,"sid":data.csessionid,"sig":data.sig}
    NSLog(@"Get:%@", callData);
    if (callData && callData.count >=3) {
        if (_signResultBlock) {
            _signResultBlock(callData);
        }
        
        if (![_hName isEqualToString:@"activieSign"]) {
            [UIView animateWithDuration:0.5 animations:^{
                
            } completion:^(BOOL finished) {
                self.hidden = YES;
            }];
        }
        
    }
    
    
}


#pragma mark - WebViewUIDelegate

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSDictionary *para = message.body;
    if( [para isKindOfClass:[NSDictionary class]] ==NO ){
        [self getSlideData:nil];
        return;
    }
//    {"token":nc_token,"sid":data.csessionid,"sig":data.sig}
//    NSString *stringData = para[@"stringData"];
    //    NSString *boolData = para[@"boolData"];
    
    __weak typeof(self ) weakSelf = self;
    if ([message.name isEqualToString:@"successCallback"]) {
        NSLog(@"Add NavigationBar");
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf getSlideData:para];
        });
    }
}

#pragma mark - getter
- (WKWebView *)webView {
    if( !_webView ){
        self.backgroundColor = [UIColor redColor];
        //进行配置控制器
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        //实例化对象
        configuration.userContentController = [WKUserContentController new];
        [configuration.userContentController addScriptMessageHandler:self name:@"successCallback"];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        
        
        CGRect frame = self.bounds;
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_webView];
        
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.top.left.bottom.right.mas_equalTo(self).offset(0);
        }];
    }
    
    return _webView;
}


@end
