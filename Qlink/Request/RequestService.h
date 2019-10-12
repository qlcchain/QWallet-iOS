//
//  RequestService.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/26.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClientV2.h"

static NSInteger const RequestServerTypeNormal = 1;//正常服务器接口(正式或测试)
static NSInteger const RequestServerTypeDebug = 2;//测试服务器接口
static NSInteger const RequestServerTypeRelease = 3;//正式服务器接口

@interface RequestService : NSObject

+ (NSString *_Nullable)getPrefixUrl;
+ (NSString *_Nullable)getPrefixUrlOfRelease;
+ (NSString *_Nullable)getPrefixUrlOfDebug;
+ (void)cancelAllOperations;
+ (NSString *)getRequestTimestamp;


/// 有params、httpMethod、isSign
/// @param url url description
/// @param params params description
/// @param httpMethod httpMethod description
/// @param isSign isSign description
/// @param successReqBlock successReqBlock description
/// @param failedReqBlock failedReqBlock description
+ (NSURLSessionDataTask *)requestWithUrl2:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod isSign:(BOOL)isSign successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

/// 有params、httpMethod
/// @param url url description
/// @param params params description
/// @param httpMethod httpMethod description
/// @param successReqBlock successReqBlock description
/// @param failedReqBlock failedReqBlock description
+ (NSURLSessionDataTask *)requestWithUrl5:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;


/// 有params、httpMethod、serverType
/// @param url url description
/// @param params params description
/// @param httpMethod httpMethod description
/// @param serverType serverType description
/// @param successReqBlock successReqBlock description
/// @param failedReqBlock failedReqBlock description
+ (NSURLSessionDataTask *)requestWithUrl10:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod serverType:(NSInteger)serverType successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;


/// 有params、timestamp、httpMethod
/// @param url url description
/// @param params params description
/// @param timestamp timestamp description
/// @param httpMethod httpMethod description
/// @param successReqBlock successReqBlock description
/// @param failedReqBlock failedReqBlock description
+ (NSURLSessionDataTask *)requestWithUrl6:(NSString *)url params:(id)params timestamp:(nullable NSString *)timestamp httpMethod:(HttpMethod)httpMethod successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;


/// 有params、timestamp、httpMethod、serverType
/// @param url url description
/// @param params params description
/// @param timestamp timestamp description
/// @param httpMethod httpMethod description
/// @param serverType serverType description
/// @param successReqBlock successReqBlock description
/// @param failedReqBlock failedReqBlock description
+ (NSURLSessionDataTask *)requestWithUrl11:(NSString *)url params:(id)params timestamp:(nullable NSString *)timestamp httpMethod:(HttpMethod)httpMethod serverType:(NSInteger)serverType successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

/// 请求不带签名
/// @param URLString URLString description
/// @param params params description
/// @param httpMethod httpMethod description
/// @param userInfo userInfo description
/// @param requestManagerType requestManagerType description
/// @param successReqBlock successReqBlock description
/// @param failedReqBlock failedReqBlock description
+ (NSURLSessionDataTask *)normalRequestWithBaseURLStr8:(NSString *)URLString
                                             params:(id)params
                                         httpMethod:(HttpMethod)httpMethod
                                           userInfo:(NSDictionary*)userInfo requestManagerType:(QRequestManagerType)requestManagerType
                                       successBlock:(HTTPRequestV2SuccessBlock)successReqBlock
                                        failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

+ (NSURLSessionDataTask *)postImage7:(NSString *)url
                          parameters:(id)parameters
           constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))bodyBlock
                             success:(HTTPRequestV2SuccessBlock)successReqBlock
                             failure:(HTTPRequestV2FailedBlock)failedReqBlock;

@end
