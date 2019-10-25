//
//  TopupPayOrderHelper.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupPayOrderHelper.h"

@implementation TopupPayOrderHelper

+ (instancetype)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static TopupPayOrderHelper *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc]init];
    });
    return sharedObj;
}

@end
