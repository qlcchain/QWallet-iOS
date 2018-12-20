//
//  ZhengZeJudge.h
//  TouRongSu
//
//  Created by wwj on 14-7-17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWJRegularJudge : NSObject

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;
//密码格式
+ (BOOL) validatePassword:(NSString *)password;
//交易密码格式
+ (BOOL) validatePaymentPassword:(NSString *)password;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//校验银行卡号
+(BOOL)validateBankCardNumber:(NSString *)cardNumber;

+ (BOOL)isValidateMerRate:(NSString *)merRate;

+(BOOL)isMatchMoneyFormat:(NSString *)text range:(NSRange)range string:(NSString *)string;

+(BOOL)isMatchPasswordFormat:(NSString *)text range:(NSRange)range string:(NSString *)string;
/**
 *  手机号
 */
+(BOOL)isMatchTelephoneFormat:(NSString *)text range:(NSRange)range string:(NSString *)string;

/**
 *  身份证号
 */
+(BOOL)isMatchIdentityCardFormat:(NSString *)text range:(NSRange)range string:(NSString *)string;


/**
 *  短信验证码
 */
+(BOOL)isMatchShortMessageFormat:(NSString *)text range:(NSRange)range string:(NSString *)string;

/**
 *  银行卡号
 */
+(BOOL)isMatchBankCardNumberFormat:(NSString *)text range:(NSRange)range string:(NSString *)string;

@end
