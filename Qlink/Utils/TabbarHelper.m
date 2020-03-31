//
//  TabbarHelper.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/21.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TabbarHelper.h"
#import "MD5Util.h"
#import "RSAUtil.h"
#import "UserModel.h"
#import "GlobalConstants.h"

@implementation TabbarHelper

+ (void)requestUser_red_pointWithCompleteBlock:(void(^)(RedPointModel *redPointM))completeBlock {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    //    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSDictionary *params = @{@"account":account,@"token":token};
    [RequestService requestWithUrl11:user_red_point_Url params:params timestamp:timestamp httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            RedPointModel *model = [RedPointModel getObjectWithKeyValues:responseObject];
            if (completeBlock) {
                completeBlock(model);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
