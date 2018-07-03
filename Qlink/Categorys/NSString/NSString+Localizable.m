//
//  NSString+Localizable.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "NSString+Localizable.h"

@implementation NSString (Localizable)

+ (NSString *)localizableString:(NSString *)key {
    
    return NSLocalizedString(key, nil);
}

@end
