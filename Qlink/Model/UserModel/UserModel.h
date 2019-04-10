//
//  UserModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

#define UserModel_Local @"UserModel_Local"

@interface UserModel : BBaseModel

@property (nonatomic, copy) NSString *email; // = "";
@property (nonatomic, copy) NSString *head; // = "";
@property (nonatomic, copy) NSString *ID; // = ;
@property (nonatomic, copy) NSString *phone; // = "";
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *md5PW;
@property (nonatomic, copy) NSString *rsaPublicKey;
@property (nonatomic, copy) NSNumber *isLogin;

+ (NSString *)getOwnP2PId;
+ (void)storeUser:(UserModel *)model;
+ (UserModel *)fetchUserOfLogin;
+ (UserModel *)fetchUser:(NSString *)account;
+ (void)logout:(NSString *)account;
+ (void)cleanUser:(NSString *)account;
+ (void)cleanAllUser;
+ (BOOL)haveLoginAccount;
+ (BOOL)inLogin:(NSString *)account;

@end
