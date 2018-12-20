//
//  LoginPWModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/2.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginPWCompleteBlock)(void);

@interface LoginPWModel : BBaseModel

@property (nonatomic, strong) NSString *loginPW;

+ (BOOL)isExistLoginPW;
+ (NSString *)getLoginPW;
+ (void)setLoginPW:(NSString *)pw;
+ (BOOL)deleteLoginPW;

@end

NS_ASSUME_NONNULL_END
