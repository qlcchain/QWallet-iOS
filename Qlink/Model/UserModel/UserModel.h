//
//  UserModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

#define UserModel_Local @"UserModel_Local"
#define UserModel_LastLoginAccount @"UserModel_LastLoginAccount"

static NSString *const kyc_success = @"KYC_SUCCESS";
static NSString *const kyc_not_upload = @"NOT_UPLOAD";
static NSString *const kyc_uploaded = @"UPLOADED";
static NSString *const kyc_fail = @"KYC_FAIL";

@interface UserModel : BBaseModel

@property (nonatomic, copy) NSString *email; // = "";
@property (nonatomic, copy) NSString *head; // = "";
@property (nonatomic, copy) NSString *ID; // = ;
@property (nonatomic, copy) NSString *phone; // = "";
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *md5PW;
@property (nonatomic, copy) NSString *rsaPublicKey;
@property (nonatomic, copy) NSNumber *isLogin;
@property (nonatomic, copy) NSNumber *otcTimes;
@property (nonatomic, copy) NSString *holdingPhoto;
@property (nonatomic, copy) NSString *facePhoto;
@property (nonatomic, copy) NSNumber *number;
@property (nonatomic, copy) NSNumber *totalInvite;
@property (nonatomic, copy) NSString *vStatus; // 验证状态[NOT_UPLOAD/未上传,UPLOADED/已上传,KYC_SUCCESS/KYC成功,KYC_FAIL/KYC失败]
@property (nonatomic, copy) NSString *bindDate;

+ (NSString *)getOwnP2PId;
+ (NSString *)getTopupP2PId;
+ (void)storeUser:(UserModel *)model useLogin:(BOOL)useLogin;
+ (UserModel *)fetchUserOfLogin;
+ (UserModel *)fetchUser:(NSString *)account;
+ (void)logout:(NSString *)account;
+ (void)cleanUser:(NSString *)account;
+ (void)cleanAllUser;
+ (BOOL)haveLoginAccount;
//+ (BOOL)inLogin:(NSString *)account;
+ (BOOL)haveAccountInLocal;
+ (void)storeLastLoginAccount:(NSString *)account; // 刷新最后一次登录的账号
+ (NSString *)getLastLoginAccount; // 获取最后一次登录的账号
+ (void)deleteOneAccount;
+ (BOOL)isBind;

@end
