//
//  UserUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "UserUtil.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"

#import "GlobalConstants.h"

@implementation UserUtil

+ (void)updateUserInfo {
    if (![UserModel haveLoginAccount]) {
        return;
    }
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token}];
    [RequestService requestWithUrl11:user_user_info_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            UserModel *tempUserM = [UserModel getObjectWithKeyValues:responseObject[Server_Data]];
            userM.head = tempUserM.head;
            userM.number = tempUserM.number;
            userM.phone = tempUserM.phone;
            userM.facePhoto = tempUserM.facePhoto;
            userM.nickname = tempUserM.nickname;
            userM.totalInvite = tempUserM.totalInvite;
            userM.vStatus = tempUserM.vStatus;
            userM.account = tempUserM.account;
            userM.email = tempUserM.email;
            userM.otcTimes = tempUserM.otcTimes;
            userM.holdingPhoto = tempUserM.holdingPhoto;
            userM.ID = tempUserM.ID;
            userM.bindDate = tempUserM.bindDate;
            [UserModel storeUser:userM useLogin:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:User_UpdateInfo_Noti object:nil];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

+ (void)updateUserInfoAfterLogin {
    if (![UserModel haveLoginAccount]) {
        return;
    }
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token}];
    [RequestService requestWithUrl11:user_user_info_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            UserModel *tempUserM = [UserModel getObjectWithKeyValues:responseObject[Server_Data]];
            userM.head = tempUserM.head;
            userM.number = tempUserM.number;
            userM.phone = tempUserM.phone;
            userM.facePhoto = tempUserM.facePhoto;
            userM.nickname = tempUserM.nickname;
            userM.totalInvite = tempUserM.totalInvite;
            userM.vStatus = tempUserM.vStatus;
            userM.account = tempUserM.account;
            userM.email = tempUserM.email;
            userM.otcTimes = tempUserM.otcTimes;
            userM.holdingPhoto = tempUserM.holdingPhoto;
            userM.ID = tempUserM.ID;
            userM.bindDate = tempUserM.bindDate;
            [UserModel storeUser:userM useLogin:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:User_UpdateInfo_Noti object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:User_UpdateInfoAfterLogin_Noti object:nil];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}



@end
