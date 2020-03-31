//
//  NEOGasClaimModel.m
//  Qlink
//
//  Created by Jelly Foo on 2020/3/29.
//  Copyright © 2020 pan. All rights reserved.
//

#import "NEOGasClaimModel.h"
#import "NSString+RemoveZero.h"

@implementation NEOGasClaimModel

- (NSString *)unclaimed_str {
    return [NSString doubleToString:_unclaimed];
}

@end
