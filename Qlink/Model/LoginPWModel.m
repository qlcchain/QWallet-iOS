//
//  LoginPWModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/2.
//  Copyright © 2018 pan. All rights reserved.
//

#import "LoginPWModel.h"
#import "Qlink-Swift.h"

@implementation LoginPWModel

+ (BOOL)isExistLoginPW {
    BOOL isExist = YES;
    NSString *value = [KeychainUtil getKeyValueWithKeyName:LOGIN_PW_KEY];
    if (value == nil || [value isEmptyString]) {
        isExist = NO;
    }
    return isExist;
}

+ (NSString *)getLoginPW {
    NSString *value = [KeychainUtil getKeyValueWithKeyName:LOGIN_PW_KEY];
    return value?:@"";
}

+ (void)setLoginPW:(NSString *)pw {
    BOOL success = [KeychainUtil saveValueToKeyWithKeyName:LOGIN_PW_KEY keyValue:pw];
}

+ (BOOL)deleteLoginPW {
    return [KeychainUtil removeKeyWithKeyName:LOGIN_PW_KEY];
//    BOOL success = [KeychainUtil saveValueToKeyWithKeyName:LOGIN_PW_KEY keyValue:pw];
}

@end
