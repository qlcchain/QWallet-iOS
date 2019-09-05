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

+ (NSURLSessionDataTask *)requestWithJsonUrl1:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

+ (NSURLSessionDataTask *)requestWithUrl2:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod isSign:(BOOL)isSign successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

+ (NSURLSessionDataTask *)requestWithUrl3:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod isSign:(BOOL)isSign timestamp:(nullable NSString *)timestamp successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

+ (NSURLSessionDataTask *)requestWithUrl4:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod isSign:(BOOL)isSign timestamp:(nullable NSString *)timestamp addBase:(BOOL)addBase successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

+ (NSURLSessionDataTask *)requestWithUrl5:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

+ (NSURLSessionDataTask *)requestWithUrl10:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod serverType:(NSInteger)serverType successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

+ (NSURLSessionDataTask *)requestWithUrl6:(NSString *)url params:(id)params timestamp:(nullable NSString *)timestamp httpMethod:(HttpMethod)httpMethod successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

+ (NSURLSessionDataTask *)postImage7:(NSString *)url
                   parameters:(id)parameters
    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))bodyBlock
                      success:(HTTPRequestV2SuccessBlock)successReqBlock
                      failure:(HTTPRequestV2FailedBlock)failedReqBlock;


+ (NSURLSessionDataTask *)testRequestWithBaseURLStr8:(NSString *)URLString
                                             params:(id)params
                                         httpMethod:(HttpMethod)httpMethod
                                           userInfo:(NSDictionary*)userInfo
                                       successBlock:(HTTPRequestV2SuccessBlock)successReqBlock
                                        failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;

@end
