//
//  OCBaseModel.m
//  
//
//  Created by 1234 on 15/10/13.
//  Copyright © 2015年 life. All rights reserved.
//

#import "BBaseModel.h"

@implementation BBaseModel

// NSCoding实现
MJExtensionCodingImplementation

+ (void)load {
    [BBaseModel mj_setupIgnoredCodingPropertyNames:^NSArray *{
        return nil;
    }];
}

+ (id)getObjectWithKeyValues:(NSDictionary *)dic {
    Class getClass = [self class];
    id model = [getClass mj_objectWithKeyValues:dic];
    return model;
}

@end
