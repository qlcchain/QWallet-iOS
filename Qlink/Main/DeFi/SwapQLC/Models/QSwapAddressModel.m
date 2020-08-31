//
//  QSwapAddressModel.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/31.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QSwapAddressModel.h"

@implementation QSwapAddressModel

+ (QSwapAddressModel *)getShareObject {
    
    static QSwapAddressModel *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

@end
