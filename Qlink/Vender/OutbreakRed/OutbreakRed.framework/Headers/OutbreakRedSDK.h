//
//  OutbreakRedSDK.h
//  OutbreakRed
//
//  Created by Jelly Foo on 2020/4/15.
//  Copyright © 2020 Jelly Foo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class OR_RequestModel;

@interface OutbreakRedSDK : NSObject

+ (void)getStepWithIntervalDay:(NSInteger)days fromDate:(NSDate *)fromDate completeBlock:(void(^)(NSArray *stepArr))completeBlock;

+ (void)requestGzbd_createWithAccount:(NSString *)account token:(NSString *)token timestamp:(NSString *)timestamp requestM:(OR_RequestModel *)reqeustM completeBlock:(void(^)(NSURLSessionDataTask *dataTask, id responseObject, NSError *error))completeBlock;

+ (void)requestGzbd_focusWithAccount:(NSString *)account token:(NSString *)token timestamp:(NSString *)timestamp requestM:(OR_RequestModel *)reqeustM completeBlock:(void(^)(NSURLSessionDataTask *dataTask, id responseObject, NSError *error))completeBlock;

+ (void)requestGzbd_receive2WithAccount:(NSString *)account token:(NSString *)token timestamp:(NSString *)timestamp signDic:(NSDictionary *)signDic recordId:(NSString *)recordId toAddress:(NSString *)toAddress appKey:(NSString *) appKey scene:(NSString *)scene requestM:(OR_RequestModel *)reqeustM completeBlock:(void(^)(NSURLSessionDataTask *dataTask, id responseObject, NSError *error))completeBlock;

+ (void)requestGzbd_receiveWithAccount:(NSString *)account token:(NSString *)token timestamp:(NSString *)timestamp code:(NSString *)code recordId:(NSString *)recordId toAddress:(NSString *)toAddress requestM:(OR_RequestModel *)reqeustM completeBlock:(void(^)(NSURLSessionDataTask *dataTask, id responseObject, NSError *error))completeBlock;

+ (void)requestGzbd_listWithAccount:(NSString *)account token:(NSString *)token page:(NSString *)page size:(NSString *)size status:(NSString *)status orStatus:(NSString *)orStatus timestamp:(NSString *)timestamp requestM:(OR_RequestModel *)reqeustM completeBlock:(void(^)(NSURLSessionDataTask *dataTask, id responseObject, NSError *error))completeBlock;

+ (void)requestGzbd_claim_qlcWithAccount:(NSString *)account token:(NSString *)token timestamp:(NSString *)timestamp code:(NSString *)code toAddress:(NSString *)toAddress requestM:(OR_RequestModel *)reqeustM completeBlock:(void(^)(NSURLSessionDataTask *dataTask, id responseObject, NSError *error))completeBlock;

+ (void)requestGzbd_claim_qlc2WithAccount:(NSString *)account token:(NSString *)token timestamp:(NSString *)timestamp signDic:(NSDictionary *)signDic toAddress:(NSString *)toAddress appKey:(NSString *) appKey scene:(NSString *)scene requestM:(OR_RequestModel *)reqeustM completeBlock:(void(^)(NSURLSessionDataTask *dataTask, id responseObject, NSError *error))completeBlock;

@end

NS_ASSUME_NONNULL_END
