//
//  AppConfigUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/6.
//  Copyright © 2018 pan. All rights reserved.
//

#import "AppConfigUtil.h"

@implementation AppConfigUtil

+ (instancetype)shareInstance {
    static AppConfigUtil *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

@end
