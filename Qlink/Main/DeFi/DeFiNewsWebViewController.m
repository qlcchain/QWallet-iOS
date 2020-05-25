//
//  WebViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "DeFiNewsWebViewController.h"
#import <WebKit/WebKit.h>
#import "GlobalConstants.h"
#import "DefiNewsListModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DeFiNewsWebViewController ()<WKNavigationDelegate>

//@property (weak, nonatomic) IBOutlet WKWebView *myWebView;
@property (nonatomic, strong) WKWebView *myWebView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//设置加载进度条
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *webBack;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *personIcon;
@property (weak, nonatomic) IBOutlet UILabel *personNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *viewLab;

@end

@implementation DeFiNewsWebViewController

//- (IBAction)clickBack:(id)sender {
//    [self leftNavBarItemPressedWithPop:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    
    _lblTitle.text = kLang(@"defi_hot");
    _titleLab.text = nil;
    _personNameLab.text = nil;
    _timeLab.text = nil;
    _viewLab.text = [NSString stringWithFormat:@"0%@",kLang(@"defi_views")];
    
    [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255
                                                     green:240.0/255
                                                      blue:240.0/255
                                                     alpha:1.0]];
    _progressView.progressTintColor = MAIN_BLUE_COLOR;
    _progressView.hidden = YES;
    
    [self request_defi_news:_projectID];
    
}

- (void)refreshView:(DefiNewsListModel *)model {
    NSString *timeStr = model.createDate;
    if (model.createDate && model.createDate.length >= 10) {
        timeStr = [model.createDate substringToIndex:10];
    }
    _timeLab.text = timeStr;
    _personNameLab.text = model.authod;
    _titleLab.text = model.title;
    _viewLab.text = [NSString stringWithFormat:@"%@%@",model.views,kLang(@"defi_views")];
    [_personIcon sd_setImageWithURL:[NSURL URLWithString:model.imgPath] placeholderImage:[UIImage imageNamed:@"defi_news_head"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

- (void)addWebView:(NSString *)json {
#if DEBUG
    [self deleteWebCache];
#else
    
#endif
    
    
//    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);";
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;

    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc] init];
    // 设置字体大小(最小的字体大小)
    preference.minimumFontSize = 15;
    // 设置偏好设置对象
    wkWebConfig.preferences = preference;
    
    _myWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
    _myWebView.scrollView.alwaysBounceVertical = NO;
//    _myWebView.scrollView.bounces = NO;
//    _myWebView.scrollView.scrollEnabled = NO;
    _myWebView.backgroundColor = [UIColor whiteColor];
    [_webBack addSubview:_myWebView];
    kWeakSelf(self);
    [_myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.webBack).offset(0);
    }];
    
    _myWebView.navigationDelegate = self;
    // 添加进度观察者
    [_myWebView addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                    options:0
                    context:nil];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:0.0];
    [_myWebView loadHTMLString:json?:@"" baseURL:nil];
}

- (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
     NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}

//- (void)addWebView1 {
//    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"aaaa" ofType:@"html"];
//
//    NSURL *fileUrl = [NSURL fileURLWithPath:bundleStr];
//
//    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);";
////    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//
//    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//    [wkUController addUserScript:wkUScript];
//
//    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
//    wkWebConfig.userContentController = wkUController;
//
//    // 创建设置对象
//    WKPreferences *preference = [[WKPreferences alloc] init];
//    // 设置字体大小(最小的字体大小)
//    preference.minimumFontSize = 15;
//    // 设置偏好设置对象
//    wkWebConfig.preferences = preference;
//
//    _myWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
////    _myWebView.scrollView.alwaysBounceVertical = NO;
////    _myWebView.scrollView.bounces = NO;
////    _myWebView.scrollView.scrollEnabled = NO;
//    _myWebView.backgroundColor = [UIColor whiteColor];
//    [_webBack addSubview:_myWebView];
//    kWeakSelf(self);
//    [_myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.mas_equalTo(weakself.webBack).offset(0);
//    }];
//
//    _myWebView.navigationDelegate = self;
//    // 添加进度观察者
//    [_myWebView addObserver:self
//                 forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
//                    options:0
//                    context:nil];
//
//    [_myWebView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
//}

//-(WKWebView *)webView{
//    if (!_webView) {
//
//        [Toolkit setContentInsetAdjustmentBehaviorNever4ScrollView:webView.scrollView];
//        _webView = webView;
//    }
//    return _webView;
//}

#pragma mark - Request
- (void)request_defi_news:(NSString *)projectID {
    kWeakSelf(self);
    NSDictionary *params = @{@"newsId":projectID};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl5:defi_news_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            DefiNewsListModel *resultM = [DefiNewsListModel mj_objectWithKeyValues:responseObject[@"news"]];
            
            NSString *inputJson = resultM.content;
            [weakself addWebView:inputJson];
//            [weakself addWebView1];
            [weakself refreshView:resultM];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    if (_myWebView) {
        if ([_myWebView canGoBack]) {
            [_myWebView goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
