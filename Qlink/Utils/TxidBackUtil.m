//
//  TxidBackUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/22.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TxidBackUtil.h"
#import "GlobalConstants.h"
#import "MD5Util.h"
#import "RSAUtil.h"
#import "UserModel.h"

@implementation TxidBackModel

@end

@implementation TxidBackUtil

+ (void)requestSys_txid_backup:(TxidBackModel *)model completeBlock:(void(^)(BOOL success, NSString *msg))completeBlock {
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
    NSString *txid = model.txid?:@"";
    NSString *type = model.type?:@"";
    NSString *chain = model.chain?:@"";
    NSString *tokenName = model.tokenName?:@"";
    NSString *amount = model.amount?:@"";
    NSString *platform = model.platform?:@"";
    NSDictionary *params = @{@"account":account,@"token":token, @"txid":txid, @"type":type, @"chain":chain, @"tokenName":tokenName, @"amount":amount, @"platform":platform};
    [RequestService requestWithUrl5:sys_txid_backup_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            if (completeBlock) {
                completeBlock(YES, nil);
            }
        } else {
            NSString *msg = responseObject[Server_Msg];
            if (completeBlock) {
                completeBlock(NO, msg);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (completeBlock) {
            completeBlock(NO, error.localizedDescription);
        }
    }];
}

@end
