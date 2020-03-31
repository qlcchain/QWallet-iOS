//
//  HttpRedirect302Helper.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import "HttpRedirect302Helper.h"

static NSString *http_pre = @"https://shop.huagaotx.cn/wap/redirect.html?target=";

@interface HttpRedirect302Helper () <NSURLSessionDelegate,NSURLSessionTaskDelegate>

@end

@implementation HttpRedirect302Helper

+ (instancetype)getShareObject {
    static dispatch_once_t pred = 0;
    __strong static HttpRedirect302Helper *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc] init];
    });
    return sharedObj;
}

- (void)startRedirect:(NSURL *)url completeBlock:(void(^)(NSString *urlStr))completeBlock {
    url = [NSURL URLWithString:@"https://shop.huagaotx.cn/mobile.php?act=member_payment&op=pay_new&key=null&pay_sn=490624740021485872&password=&rcb_pay=0&pd_pay=0&payment_code=wxpay_jsapi&trace_id=mm_1000001_998902_sdkfalsdhfoaieofslkdfjlasjd"];
    NSMutableURLRequest *quest = [NSMutableURLRequest requestWithURL:url];
    quest.HTTPMethod = @"GET";
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:quest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        
        NSLog(@"%ld",urlResponse.statusCode);
        NSLog(@"%@",urlResponse.allHeaderFields);
        
        NSDictionary *dic = urlResponse.allHeaderFields;
        NSString *locationStr = dic[@"Location"];
        NSLog(@"location1 = %@",locationStr);
        
        if (completeBlock) {
            NSString *result = [http_pre stringByAppendingString:locationStr];
            completeBlock(result);
        }
    }];
    
    [task resume];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler{

    completionHandler(nil);

}


@end
