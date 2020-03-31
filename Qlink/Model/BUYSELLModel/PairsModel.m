//
//  PairsModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/19.
//  Copyright © 2019 pan. All rights reserved.
//

#import "PairsModel.h"
#import <TMCache/TMCache.h>
#import "GlobalConstants.h"

@implementation PairsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (void)storeLocalSelect:(NSArray *)arr {
    [[TMCache sharedCache] setObject:arr forKey:Local_Select_Pairs];
}

+ (NSArray *)fetchLocalSelect {
    return [[TMCache sharedCache] objectForKey:Local_Select_Pairs];
}

+ (void)removeLocalSelect {
    [[TMCache sharedCache] removeObjectForKey:Local_Select_Pairs];
}

@end
