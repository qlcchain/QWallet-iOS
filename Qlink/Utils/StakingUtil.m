//
//  StakingUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import "StakingUtil.h"
#import "NSDate+Category.h"

@implementation StakingUtil

+ (BOOL)isRedeemable:(NSTimeInterval)withdrawTime {
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:withdrawTime];
    NSDate *date2 = [NSDate date];
    NSInteger seconds = [date2 secondsAfterDate:date1];
    if (seconds >= 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
