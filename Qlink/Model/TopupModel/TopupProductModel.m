//
//  TopupProductModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupProductModel.h"

@implementation TopupProductModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Description" : @"description", @"ID" : @"id"};
}

@end
