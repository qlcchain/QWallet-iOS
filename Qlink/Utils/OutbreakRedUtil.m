//
//  AppConfigUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/6.
//  Copyright © 2018 pan. All rights reserved.
//

#import "OutbreakRedUtil.h"

@implementation OutbreakRedUtil

+ (instancetype)shareInstance {
    static OutbreakRedUtil *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

@end
