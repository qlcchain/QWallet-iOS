//
//  SignView.h
//  Qlink
//
//  Created by 旷自辉 on 2020/6/12.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SignResultBlock)(NSDictionary *resultDic);

@interface SignView : UIView
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *hName;
@property (nonatomic, copy) SignResultBlock signResultBlock;
- (void)loadLocalHtmlForJsWithHtmlName:(NSString *) htmlName;
@end

NS_ASSUME_NONNULL_END
