//
//  RequestService.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/26.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "RequestService.h"
#import "DigestUtils.h"
#import "NSString+UrlEncode.h"
#import "NSDate+Category.h"
#import "AFHTTPClientV2.h"

@interface RequestService ()

@property (nonatomic, strong) NSString *prefix_Url;

@end

@implementation RequestService

+ (instancetype)getInstance {
    static dispatch_once_t pred = 0;
    __strong static id shareObject = nil;
    dispatch_once(&pred, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

- (NSString *)prefix_Url {
//    if (!_prefix_Url) {
        _prefix_Url = [ConfigUtil getServerDomain];
//    }
    return _prefix_Url;
}

+ (NSString *)getPrefixUrl {
    return [RequestService getInstance].prefix_Url;
}

+ (void)cancelAllOperations {
    [AFHTTPClientV2 cancelAllOperations];
}

+ (NSURLSessionDataTask *)requestWithUrl:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod isSign:(BOOL)isSign successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",[RequestService getInstance].prefix_Url,url];

    id inputParams = params;
    if (isSign) {
        NSString *recordStr = @"";
        if (params) {
            recordStr = ((NSDictionary *)params).mj_JSONString;
//            recordStr = [JSONUtil jsonStrFromDicWithTrim:params];
        }
        NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
        NSMutableDictionary *jsonParam = [NSMutableDictionary dictionaryWithDictionary: @{@"appid":[ConfigUtil getChannel],@"timestamp":timestamp,@"params":recordStr}];
        // 升序、拼接、加密
        NSString *signStr = [DigestUtils getSignature:jsonParam];
        [jsonParam setObject:signStr forKey:@"sign"];
        if (params) {
            [jsonParam setObject:params forKey:@"params"];
        }
        
        NSString *jsonStr = ((NSDictionary *)jsonParam).mj_JSONString;
//        NSString *jsonStr = [JSONUtil jsonStrFromDicWithTrim:jsonParam];
        if ([K_Print_JsonStr boolValue]) {
            DDLogDebug(@"jsonStr = %@",jsonStr);
        }
        NSString *encodeStr = [jsonStr urlEncodeUsingEncoding:NSUTF8StringEncoding];
        //    DDLogDebug(@"encodeStr = %@",encodeStr);
        inputParams = encodeStr;
    }
    
    NSURLSessionDataTask *dataTask = [AFHTTPClientV2 requestWithBaseURLStr:requestUrl params:inputParams httpMethod:httpMethod successBlock:successReqBlock failedBlock:failedReqBlock];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithUrl:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    
    NSURLSessionDataTask *dataTask = [RequestService requestWithUrl:url params:params httpMethod:httpMethod isSign:YES successBlock:successReqBlock failedBlock:failedReqBlock];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)postImage:(NSString *)url
                   parameters:(id)parameters
    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))bodyBlock
                      success:(HTTPRequestV2SuccessBlock)successReqBlock
                      failure:(HTTPRequestV2FailedBlock)failedReqBlock {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",[RequestService getInstance].prefix_Url,url];
    
    NSURLSessionDataTask *dataTask = [AFHTTPClientV2 requestWithBaseURLStr:requestUrl parameters:parameters userInfo:nil constructingBodyWithBlock:bodyBlock success:successReqBlock failure:failedReqBlock];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithJsonUrl:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock
{
    NSURLSessionDataTask *dataTask = [AFHTTPClientV2 requestWithBaseURLStr:url params:params httpMethod:httpMethod successBlock:successReqBlock failedBlock:failedReqBlock];
    return dataTask;
}

@end
