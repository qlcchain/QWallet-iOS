 //
//  AFHTTPClientV2.m
//  PAFNetClient
//
//  Created by JK.PENG on 14-1-22.
//  Copyright (c) 2014年 njut. All rights reserved.
//

#import "AFHTTPClientV2.h"
#import "NSString+EmptyUtil.h"
#import "GlobalConstants.h"

@interface AFHTTPClientV2 ()

@property (nonatomic, strong) AFURLSessionManager *urlManager;
@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) AFHTTPSessionManager *jsonManager;

@end

@implementation AFHTTPClientV2

+ (instancetype)shareInstance {
    static id shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

//+ (AFURLSessionManager *)getURLManager {
//    if (![AFHTTPClientV2 shareInstance].urlManager) {
//        [AFHTTPClientV2 shareInstance].urlManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
//        [AFHTTPClientV2 shareInstance].urlManager.responseSerializer = responseSerializer;
//    }
//    return [AFHTTPClientV2 shareInstance].urlManager;
//}

+ (AFHTTPSessionManager *)getHTTPManager {
    if (![AFHTTPClientV2 shareInstance].httpManager) {
        [AFHTTPClientV2 shareInstance].httpManager = [AFHTTPSessionManager manager];
        [AFHTTPClientV2 shareInstance].httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];//[AFHTTPRequestSerializer serializer];
        [AFHTTPClientV2 shareInstance].httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];//[AFHTTPResponseSerializer serializer];
        [AFHTTPClientV2 shareInstance].httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        [[AFHTTPClientV2 shareInstance].httpManager.requestSerializer setTimeoutInterval:TimeOut_Request];
        //    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
        //    [manager.requestSerializer setQueryStringSerializationWithStyle:AFHTTPRequestQueryStringDefaultStyle];
        //    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题
        
        //    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"platform"];
        //    [manager.requestSerializer setValue: @"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [[AFHTTPClientV2 shareInstance].httpManager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        [[AFHTTPClientV2 shareInstance].httpManager.requestSerializer setValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0" forHTTPHeaderField:@"User-Agent"];
    }
    
    return [AFHTTPClientV2 shareInstance].httpManager;
}

+ (AFHTTPSessionManager *) getJSONManager {
    if (![AFHTTPClientV2 shareInstance].jsonManager) {
        [AFHTTPClientV2 shareInstance].jsonManager = [AFHTTPSessionManager manager];
        
        [AFHTTPClientV2 shareInstance].jsonManager.requestSerializer = [AFJSONRequestSerializer serializer];//[AFHTTPRequestSerializer serializer];
        [AFHTTPClientV2 shareInstance].jsonManager.responseSerializer = [AFJSONResponseSerializer serializer];//[AFHTTPResponseSerializer serializer];
    //    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        [[AFHTTPClientV2 shareInstance].jsonManager.requestSerializer setTimeoutInterval:TimeOut_Request];
//        [[AFHTTPClientV2 shareInstance].httpManager.requestSerializer setValue:@"ios"forHTTPHeaderField:@"User-Agent"];
    //    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"platform"];
//        [[AFHTTPClientV2 shareInstance].jsonManager.requestSerializer setValue: @"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [[AFHTTPClientV2 shareInstance].jsonManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [AFHTTPClientV2 shareInstance].jsonManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    
    /**** SSL Pinning ****/
//    if ([[RequestHelper getInstance].prefix_Url containsString:@"https"]) { //
//        [manager setSecurityPolicy:[self customSecurityPolicy]];
//    }
    
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//    //是否允许CA不信任的证书通过
//    [securityPolicy setAllowInvalidCertificates:YES];
//    //是否验证主机名
//    securityPolicy.validatesDomainName = NO;
//    /**** SSL Pinning ****/
//    [manager setSecurityPolicy:securityPolicy];
    }
    return [AFHTTPClientV2 shareInstance].jsonManager;
}

+ (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"Autotoll-Gps" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    if (!certData) {
        NSLog(@"SSL无数据");
        return securityPolicy;
    }
    NSSet *certSet = [[NSSet alloc] initWithObjects:certData, nil];
    // 设置证书
    [securityPolicy setPinnedCertificates:certSet];
    
    return securityPolicy;
}

+ (NSURLSessionDataTask *)requestWithBaseURLStr:(NSString *)URLString
                                   params:(id)params
                               httpMethod:(HttpMethod)httpMethod
                             successBlock:(HTTPRequestV2SuccessBlock)successReqBlock
                              failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock
{

    return [self requestWithBaseURLStr:URLString params:params httpMethod:httpMethod userInfo:nil successBlock:successReqBlock failedBlock:failedReqBlock];
}

+ (NSURLSessionDataTask *)requestXMLWithBaseURLStr:(NSString *)URLString
                                   params:(id)params
                               httpMethod:(HttpMethod)httpMethod
                                 userInfo:(NSDictionary*)userInfo
                             successBlock:(HTTPRequestV2SuccessBlock)successReqBlock
                              failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock
{
    NSURLSessionDataTask *dataTask;
//    AFHTTPClientV2 *httpV2 =  [[AFHTTPClientV2 alloc] init];
//    httpV2.userInfo = userInfo;
    
    DDLogDebug(@"url = %@ param = %@",URLString,params);
    
    if (httpMethod == HttpMethodGet) {
        
        dataTask = [[self getHTTPManager] GET:URLString  parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id result = [self printHTTPLogWithMethod:URLString Response:responseObject Error:nil];
            
            if (successReqBlock) {
                successReqBlock(dataTask, responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self printHTTPLogWithMethod:URLString Response:nil Error:error];
            
            if (failedReqBlock) {
                failedReqBlock(dataTask, error);
            }
        }];
        
    }
    
    return dataTask;
}

+ (NSURLSessionDataTask *)testRequestWithBaseURLStr:(NSString *)URLString params:(id)params httpMethod:(HttpMethod)httpMethod userInfo:(NSDictionary*)userInfo requestManagerType:(QRequestManagerType)requestManagerType successBlock:(HTTPRequestV2SuccessBlock)successReqBlock  failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock {
    NSURLSessionDataTask *dataTask;
    
    AFHTTPSessionManager *manager = nil;
    if (requestManagerType == QRequestManagerTypeHTTP) {
        manager = [self getHTTPManager];
    } else if (requestManagerType == QRequestManagerTypeJSON) {
        manager = [self getJSONManager];
    }
    if (httpMethod == HttpMethodGet) {
        
        DDLogDebug(@"url = %@ param = %@",URLString,params);
        
        dataTask = [manager GET:URLString  parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            id result = [self printHTTPLogWithMethod:URLString Response:responseObject Error:nil];
            NSMutableString *jsonStr = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (successReqBlock) {
                successReqBlock(dataTask, jsonStr);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self printHTTPLogWithMethod:URLString Response:nil Error:error];
            
            if (failedReqBlock) {
                failedReqBlock(dataTask, error);
            }
        }];
        
    } else if (httpMethod == HttpMethodPost) {
        
        DDLogDebug(@"url = %@ param = %@",URLString,params);
        
        dataTask = [manager POST:URLString  parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //            id result = [self printHTTPLogWithMethod:URLString Response:responseObject Error:nil];
            if ([responseObject isKindOfClass:[NSData class]]) {
                NSMutableString *jsonStr = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if (successReqBlock) {
                    successReqBlock(dataTask, jsonStr);
                }
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (successReqBlock) {
                    successReqBlock(dataTask, responseObject);
                }
            } else {
                if (successReqBlock) {
                    successReqBlock(dataTask, responseObject);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self printHTTPLogWithMethod:URLString Response:nil Error:error];
            
            if (failedReqBlock) {
                failedReqBlock(dataTask, error);
            }
        }];
        
    }
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithBaseURLStr:(NSString *)URLString
                                   params:(id)params
                               httpMethod:(HttpMethod)httpMethod
                                 userInfo:(NSDictionary*)userInfo
                             successBlock:(HTTPRequestV2SuccessBlock)successReqBlock
                              failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock
{
    NSURLSessionDataTask *dataTask;
//    AFHTTPClientV2 *httpV2 =  [[AFHTTPClientV2 alloc] init];
//    httpV2.userInfo = userInfo;
    
//    DDLogDebug(@"url = %@ param = %@",URLString,params);
    
    if (httpMethod == HttpMethodGet) {
        
         DDLogDebug(@"url = %@ param = %@",URLString,params);
        
        dataTask = [[self getHTTPManager] GET:URLString  parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id result = [self printHTTPLogWithMethod:URLString Response:responseObject Error:nil];
            if (successReqBlock) {
                successReqBlock(dataTask, result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self printHTTPLogWithMethod:URLString Response:nil Error:error];
            
            if (failedReqBlock) {
                failedReqBlock(dataTask, error);
            }
        }];
        
    }else if (httpMethod == HttpMethodPost){
        DDLogDebug(@"url = %@ param = %@",URLString,params);
        
        BOOL isJson = [params isKindOfClass:[NSDictionary class]];
//        isJson = YES;
        if (!isJson) {
            NSMutableURLRequest *request = [[self getHTTPManager].requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
            [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//            [request setValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0" forHTTPHeaderField:@"User-Agent"];
            request.timeoutInterval = TimeOut_Request;
            NSData *body = [params dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:body];
        
            dataTask = [[self getHTTPManager] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    [self printHTTPLogWithMethod:URLString Response:nil Error:error];
                    if (failedReqBlock) {
                        failedReqBlock(dataTask, error);
                    }
                } else {
                    id result = [self printHTTPLogWithMethod:URLString Response:responseObject Error:nil];
                    if (successReqBlock) {
                         successReqBlock(dataTask, result);
                    }
                }
            }];
            [dataTask resume];
        } else {
            dataTask = [[self getHTTPManager] POST:URLString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id result = [self printHTTPLogWithMethod:URLString Response:responseObject Error:nil];
                if (successReqBlock) {
                    successReqBlock(dataTask, result);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self printHTTPLogWithMethod:URLString Response:nil Error:error];

                if (failedReqBlock) {
                    failedReqBlock(dataTask, error);
                }
            }];
        }
    }else if (httpMethod == HttpMethodDelete){
        
        dataTask = [[self getHTTPManager] DELETE:URLString  parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id result = [self printJSONLogWithMethod:URLString Response:responseObject Error:nil];
            
            if (successReqBlock) {
                successReqBlock(dataTask, result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self printJSONLogWithMethod:URLString Response:nil Error:error];
            
            if (failedReqBlock) {
                failedReqBlock(dataTask, error);
            }
        }];
    }

    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithBaseURLStr:(NSString *)URLString
                               parameters:(id)parameters
                                 userInfo:(NSDictionary*)userInfo
                constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  success:(void (^)(NSURLSessionDataTask *dataTask, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure
{
    NSURLSessionDataTask *dataTask;
//    AFHTTPClientV2 *httpV2 =  [[AFHTTPClientV2 alloc] init];
//    httpV2.userInfo = userInfo;
    
    DDLogDebug(@"url = %@ param = %@",URLString,parameters);
//    CGFloat  sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
    
    dataTask = [[self getHTTPManager] POST:URLString
                                           parameters:(id)parameters
                            constructingBodyWithBlock:block
                   progress:^(NSProgress * _Nonnull uploadProgress) {
                   }
                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                  id result = [self printHTTPLogWithMethod:URLString Response:responseObject Error:nil];
                                                  if (success) {
                                                      success(dataTask, result);
                                                  }
                                              }
                                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                  [self printHTTPLogWithMethod:URLString Response:nil Error:nil];
                                                  if (failure) {
                                                      failure(dataTask, error);
                                                  }
                                              }];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithBaseURLStr:(NSString *)URLString
                               parameters:(id)parameters
                constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  success:(void (^)(NSURLSessionDataTask *dataTask, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure
{
    return [self requestWithBaseURLStr:URLString parameters:parameters userInfo:nil constructingBodyWithBlock:block success:success failure:failure];
}

+ (void)cancelAllOperations {
    AFHTTPSessionManager *httpManager = [AFHTTPClientV2 shareInstance].httpManager;
    if (httpManager.dataTasks.count > 0) {
        [httpManager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
    }
    [httpManager.operationQueue cancelAllOperations];
    
    AFHTTPSessionManager *jsonManager = [AFHTTPClientV2 shareInstance].jsonManager;
    if (jsonManager.dataTasks.count > 0) {
        [jsonManager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
    }
    [jsonManager.operationQueue cancelAllOperations];
    
    AFURLSessionManager *urlManager = [AFHTTPClientV2 shareInstance].urlManager;
    if (urlManager.dataTasks.count > 0) {
        [urlManager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
    }
    [urlManager.operationQueue cancelAllOperations];
}

//#pragma mark - NSCopying
//- (id)copyWithZone:(NSZone *)zone
//{
//    AFHTTPClientV2  *clientV2 = [[self class] init];
//    [clientV2 setUserInfo:[[self userInfo] copyWithZone:zone]];
//    return clientV2;
//}

#pragma mark - 打印返回数据
+ (id)printHTTPLogWithMethod:(NSString *)method Response:(id)response Error:(NSError *)erro {
    id result = nil;
    
    if (response) {
        
        NSMutableString *jsonStr = [[NSMutableString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        if ([K_Print_JsonStr boolValue]) {
            NSLog(@"response JSON = %@",jsonStr);
        }
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        //结果（字符串）
        NSError *error;
        //结果（字典、数组）
        result = [NSJSONSerialization
                  JSONObjectWithData:jsonData
                  options:kNilOptions
                  error:&error];
        
        NSString *responseObjectDesc = [result description];
        if (!response || [response isKindOfClass:[NSNull class]]) {
            //TODO:这里打印出json来造model
            if ([K_Print_JsonStr boolValue]) {
                DDLogDebug(@"method = %@ result = %@",method,result);
            }
        } else {
            if (responseObjectDesc) {
                responseObjectDesc = [NSString stringWithCString:[responseObjectDesc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
                if ([K_Print_JsonStr boolValue]) {
                    DDLogDebug(@"method = %@ result = %@",method,![responseObjectDesc isBlankString]?responseObjectDesc:result);
                }
            } else {
                if ([K_Print_JsonStr boolValue]) {
                    DDLogDebug(@"method = %@ result = %@",method,![responseObjectDesc isBlankString]?responseObjectDesc:jsonStr);
                }
            }
        }
    } else if (erro) {
//        if ([K_Print_JsonStr boolValue]) {
            DDLogDebug(@"method = %@ error = %@",method,erro.description);
//        }
    }
    
    return result;
}

+ (id)printJSONLogWithMethod:(NSString *)method Response:(id)response Error:(NSError *)erro {
    id result = nil;
    
    if (response) {
        NSString *responseObje = [response description];
        responseObje = [NSString stringWithCString:[responseObje cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
        if ([K_Print_JsonStr boolValue]) {
            DDLogDebug(@"method = %@ result = %@",method,![responseObje isBlankString]?responseObje:response);
        }
        
//        if ([response[Server_MessageKey] isEqualToString:@"未登录"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:SessionKeyOut_Noti object:nil];
//        }
        
        return response;
    } else if (erro) {
        DDLogDebug(@"method = %@ error = %@",method,erro.description);
    }
    
    return result;
}

@end
