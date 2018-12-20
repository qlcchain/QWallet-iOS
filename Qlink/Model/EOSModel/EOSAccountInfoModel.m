//
//  EOSAccountInfoModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSAccountInfoModel.h"

@implementation Key

@end

@implementation RequiredAuth

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"keys" : @"Key"};
}

@end

@implementation Permission

@end

@implementation EOSAccountInfoModel

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"permissions" : @"Permission"};
}

@end
