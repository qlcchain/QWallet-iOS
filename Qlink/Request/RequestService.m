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
#import "UserModel.h"

#import "GlobalConstants.h"

@interface RequestService ()

@property (nonatomic, strong) NSString *prefix_Url;
@property (nonatomic, strong) NSString *prefix_UrlOfRelease;
@property (nonatomic, strong) NSString *prefix_UrlOfDebug;

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
    _prefix_Url = [ConfigUtil getServerDomain];
    return _prefix_Url;
}

- (NSString *)prefix_UrlOfRelease {
    _prefix_Url = [ConfigUtil getReleaseServerDomain];
    return _prefix_Url;
}

- (NSString *)prefix_UrlOfDebug {
    _prefix_Url = [ConfigUtil getDebugServerDomain];
    return _prefix_Url;
}

+ (NSString *)getPrefixUrl {
    return [RequestService getInstance].prefix_Url;
}

+ (NSString *)getPrefixUrlOfRelease {
    return [RequestService getInstance].prefix_UrlOfRelease;
}

+ (NSString *)getPrefixUrlOfDebug {
    return [RequestService getInstance].prefix_UrlOfDebug;
}

+ (void)cancelAllOperations {
    [AFHTTPClientV2 cancelAllOperations];
}

+ (NSURLSessionDataTask *)requestWithUrl2:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod isSign:(BOOL)isSign successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    NSURLSessionDataTask *dataTask = [RequestService requestWithUrl3:url params:params httpMethod:httpMethod isSign:isSign timestamp:nil successBlock:successReqBlock failedBlock:failedReqBlock];
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithUrl4:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod isSign:(BOOL)isSign timestamp:(nullable NSString *)timestamp addBase:(BOOL)addBase successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    NSURLSessionDataTask *dataTask = [RequestService requestWithUrl9:url params:params httpMethod:httpMethod isSign:isSign timestamp:timestamp addBase:addBase serverType:RequestServerTypeNormal successBlock:successReqBlock failedBlock:failedReqBlock];
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithUrl9:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod isSign:(BOOL)isSign timestamp:(nullable NSString *)timestamp addBase:(BOOL)addBase serverType:(NSInteger)serverType successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    
    NSString *prefix = [RequestService getInstance].prefix_Url;
    if (serverType == RequestServerTypeNormal) {
        prefix = [RequestService getInstance].prefix_Url;
    } else if (serverType == RequestServerTypeDebug) {
        prefix = [RequestService getInstance].prefix_UrlOfDebug;
    } else if (serverType == RequestServerTypeRelease) {
        prefix = [RequestService getInstance].prefix_UrlOfRelease;
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",prefix,url];
    if (!addBase) {
        requestUrl = url;
    }
    
    NSMutableDictionary *tempParams = [NSMutableDictionary dictionaryWithDictionary:@{@"system":[RequestService getSystemInfo]}];
    [tempParams addEntriesFromDictionary:params];
    id inputParams = tempParams;
    //    id inputParams = params;
    
    if (isSign) {
        NSString *recordStr = @"";
        if (inputParams) {
            recordStr = ((NSDictionary *)inputParams).mj_JSONString;
            recordStr = [recordStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]; // 替换转义字符
            //            recordStr = [JSONUtil jsonStrFromDicWithTrim:params];
        }
        NSString *tempTimestamp = timestamp;
        if (!tempTimestamp) {
//            tempTimestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
            tempTimestamp = [RequestService getRequestTimestamp];
        }
        NSMutableDictionary *jsonParam = [NSMutableDictionary dictionaryWithDictionary: @{@"appid":[ConfigUtil getChannel],@"timestamp":tempTimestamp,@"params":recordStr}];
        // 升序、拼接、加密
        NSString *signStr = [DigestUtils getSignature:jsonParam];
        [jsonParam setObject:signStr forKey:@"sign"];
        if (inputParams) {
            [jsonParam setObject:inputParams forKey:@"params"];
        }
        
        NSString *jsonStr = ((NSDictionary *)jsonParam).mj_JSONString;
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]; // 替换转义字符
        //        NSString *jsonStr = [JSONUtil jsonStrFromDicWithTrim:jsonParam];
        if ([K_Print_JsonStr boolValue]) {
            DDLogDebug(@"jsonStr = %@",jsonStr);
        }
        NSString *encodeStr = [jsonStr urlEncodeUsingEncoding:NSUTF8StringEncoding];
        //    DDLogDebug(@"encodeStr = %@",encodeStr);
        inputParams = encodeStr;
    }
    
    NSURLSessionDataTask *dataTask = [AFHTTPClientV2 requestWithBaseURLStr:requestUrl params:inputParams httpMethod:httpMethod successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (successReqBlock) {
            successReqBlock(dataTask, responseObject);
        }
        
        NSInteger code = [responseObject[Server_Code] integerValue];
        switch (code) {
            case 20001: // Account not found
            {
                
            }
                break;
            case 20002: // Token invalid
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [kAppD logout];
                });
            }
                break;
            case 20003: // Decryption failed
            {
                
            }
                break;
            case 20004: // Incorrent password
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [kAppD logout];
                });
            }
                break;
            case 20005: // Token parsing error
            {
                
            }
                break;
                
            default:
                break;
        }
    } failedBlock:failedReqBlock];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithUrl3:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod isSign:(BOOL)isSign timestamp:(nullable NSString *)timestamp successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    return [RequestService requestWithUrl4:url params:params httpMethod:httpMethod isSign:isSign timestamp:timestamp addBase:YES successBlock:successReqBlock failedBlock:failedReqBlock];
}

+ (NSURLSessionDataTask *)requestWithUrl6:(NSString *)url params:(id)params timestamp:(nullable NSString *)timestamp httpMethod:(HttpMethod)httpMethod successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    
    NSURLSessionDataTask *dataTask = [RequestService requestWithUrl3:url params:params httpMethod:httpMethod isSign:YES timestamp:timestamp successBlock:successReqBlock failedBlock:failedReqBlock];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithUrl11:(NSString *)url params:(id)params timestamp:(nullable NSString *)timestamp httpMethod:(HttpMethod)httpMethod serverType:(NSInteger)serverType successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    
    NSURLSessionDataTask *dataTask = [RequestService requestWithUrl9:url params:params httpMethod:httpMethod isSign:YES timestamp:timestamp addBase:YES serverType:serverType successBlock:successReqBlock failedBlock:failedReqBlock];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithUrl5:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    
    NSURLSessionDataTask *dataTask = [RequestService requestWithUrl3:url params:params httpMethod:httpMethod isSign:YES timestamp:nil successBlock:successReqBlock failedBlock:failedReqBlock];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithUrl10:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod serverType:(NSInteger)serverType successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    
    NSURLSessionDataTask *dataTask = [RequestService requestWithUrl9:url params:params httpMethod:httpMethod isSign:YES timestamp:nil addBase:YES serverType:serverType successBlock:successReqBlock failedBlock:failedReqBlock];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)postImage7:(NSString *)url
                   parameters:(id)parameters
    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))bodyBlock
                      success:(HTTPRequestV2SuccessBlock)successReqBlock
                      failure:(HTTPRequestV2FailedBlock)failedReqBlock {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",[RequestService getInstance].prefix_Url,url];
    
    NSURLSessionDataTask *dataTask = [AFHTTPClientV2 requestWithBaseURLStr:requestUrl parameters:parameters userInfo:nil constructingBodyWithBlock:bodyBlock success:successReqBlock failure:failedReqBlock];
    
    return dataTask;
}

//+ (NSURLSessionDataTask *)requestWithJsonUrl1:(NSString *)url params:(id)params httpMethod:(HttpMethod)httpMethod successBlock:(HTTPRequestV2SuccessBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock
//{
//    NSURLSessionDataTask *dataTask = [AFHTTPClientV2 requestWithBaseURLStr:url params:params httpMethod:httpMethod successBlock:successReqBlock failedBlock:failedReqBlock];
//    return dataTask;
//}

+ (NSString *)getSystemInfo {
    NSMutableString *info = [NSMutableString string];
//    NSString *deviceName = [[UIDevice currentDevice] name];  //获取设备名称 例如：梓辰的手机
//    NSString *systemName = [[UIDevice currentDevice] systemName]; //获取系统名称 例如：iPhone OS
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion]; //获取系统版本 例如：9.2
//    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; //获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6
    NSString *deviceModel = [[UIDevice currentDevice] model]; //获取设备的型号 例如：iPhone
    [info appendString:deviceModel];
    [info appendString:@":"];
    [info appendString:systemVersion];
    [info appendString:@" "];
    [info appendFormat:@"version:%@",APP_Build];
    
    return info;
}

+ (NSURLSessionDataTask *)normalRequestWithBaseURLStr8:(NSString *)URLString
                                             params:(id)params
                                         httpMethod:(HttpMethod)httpMethod
                                            userInfo:(NSDictionary*)userInfo requestManagerType:(QRequestManagerType)requestManagerType
                                       successBlock:(HTTPRequestV2SuccessBlock)successReqBlock
                                        failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    NSURLSessionDataTask *dataTask = [AFHTTPClientV2 testRequestWithBaseURLStr:URLString params:params httpMethod:httpMethod userInfo:userInfo requestManagerType:requestManagerType successBlock:successReqBlock failedBlock:failedReqBlock];
    return dataTask;
}

+ (NSString *)getRequestTimestamp {
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getMillisecondTimestampFromDate:[NSDate date]])];
    return timestamp;
}

@end
