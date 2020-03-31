//
//  NEOJSUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/29.
//  Copyright © 2019 pan. All rights reserved.
//

#import "NEOJSUtil.h"

@interface NEOJSUtil ()

@property (nonatomic, strong) NEOJSView *neojsV;

@end

@implementation NEOJSUtil

+ (instancetype)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static NEOJSUtil *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc]init];
    });
    return sharedObj;
}

//+ (NEOJSView *)getNEOJSView {
//    return [NEOJSUtil shareInstance].neojsV;
//}

+ (void)addNEOJSView {
    [NEOJSUtil shareInstance].neojsV = [NEOJSView add];
}

+ (void)removeNEOJSView {
    [[NEOJSUtil shareInstance].neojsV remove];
    [NEOJSUtil shareInstance].neojsV = nil;
}

+ (void)neoTransferWithFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress assetHash:(NSString *)assetHash amount:(NSString *)amount numOfDecimals:(NSString *)numOfDecimals wif:(NSString *)wif resultHandler:(NEOJSResultBlock)resultHandler {
    [[NEOJSUtil shareInstance].neojsV neoTransferWithFromAddress:fromAddress toAddress:toAddress assetHash:assetHash amount:amount numOfDecimals:numOfDecimals wif:wif resultHandler:resultHandler];
}

+ (void)claimgasWithPrivateKey:(NSString *)privateKey resultHandler:(NEOJSResultBlock)resultHandler {
    [[NEOJSUtil shareInstance].neojsV claimgasWithPrivateKey:privateKey resultHandler:resultHandler];
}

@end
