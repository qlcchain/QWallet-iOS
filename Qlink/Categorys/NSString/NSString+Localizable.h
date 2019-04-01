//
//  NSString+Localizable.h
//  Qlink
//
//  Created by 旷自辉 on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSStringLocalizable(key) [NSString localizableString:key]

@interface NSString (Localizable)

+ (NSString *)localizableString:(NSString *)key;

@end
