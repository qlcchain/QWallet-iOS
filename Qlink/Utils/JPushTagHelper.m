//
//  JPushTagHelper.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/22.
//  Copyright © 2019 pan. All rights reserved.
//

#import "JPushTagHelper.h"
#import "JPushConstants.h"
#import "JPUSHService.h"
#import "GlobalConstants.h"
#import "UserModel.h"

static NSInteger seq = 1;

@implementation JPushTagHelper

+ (void)setTags {
    if (![UserModel haveLoginAccount]) {
        return;
    }
    NSMutableSet *tags = [NSMutableSet setWithObject:JPush_Tag_All];
    if ([UserModel isBind]) {
        [tags addObject:JPush_Tag_Debit];
    }
    [JPUSHService setTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        DDLogDebug(@"setTags iResCode:%@  iTags:%@   seq:%@",@(iResCode),iTags,@(seq));
    } seq:seq++];
}

+ (void)cleanTags {
    [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        DDLogDebug(@"cleanTags iResCode:%@  iTags:%@   seq:%@",@(iResCode),iTags,@(seq));
    } seq:seq++];
}

@end
