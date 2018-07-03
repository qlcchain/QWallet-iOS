//
//  WebViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>


#define TELEGRAM_URL @"https://t.me/winqdapp"
#define FB_URL       @"https://www.facebook.com/dAppWINQ"

@interface WebViewController ()<WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *myWebView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//设置加载进度条
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation WebViewController
- (IBAction)clickBack:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}

- (instancetype)initWithType:(NSInteger)urlType
{
    if (self = [super init]) {
        self.type = urlType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myWebView.navigationDelegate = self;
    NSString *urlString = TELEGRAM_URL;
    _lblTitle.text = @"TELEGRAM";
    if (self.type == 20) {
        _lblTitle.text = @"FACEBOOK";
        urlString = FB_URL;
    }
    
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

    [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
 
    
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
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    // NSStringLocalizable(@"request_error")
    [AppD.window showHint:error.domain];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [AppD.window showHint:NSStringLocalizable(@"request_error")];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
