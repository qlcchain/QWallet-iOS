//
//  MiningActivityModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/14.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MiningActivityModel.h"

@implementation MiningActivityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id", @"DescriptionEn":@"descriptionEn", @"Description":@"description"};
}

@end
