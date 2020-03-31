//
//  QLCWalletManage.m
//  Qlink
//
//  Created by Jelly Foo on 2019/5/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ETHWalletManage.h"

@interface ETHWalletManage ()

@end

@implementation ETHWalletManage

+ (instancetype)shareInstance {
    static id shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

@end
