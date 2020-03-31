//
//  NEOGasClaimUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/29.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NEOGasClaimUtil.h"

@implementation NEOGasClaimUtil

+ (instancetype)shareInstance {
    static id shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

- (instancetype)init {
    if (self = [super init]) {
        self.claimStatus = NEOGasClaimStatusNone;
    }
    return self;
}

@end
