//
//  Get_account_permission_service.m
//  pocketEOS
//
//  Created by oraclechain on 2018/11/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "Get_account_permission_service.h"
#import "EOS_Keys.h"
#import <eosFramework/AppConstant.h>
#import <MJExtension/MJExtension.h>

@implementation Get_account_permission_service

- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}

- (NSMutableArray *)chainAccountOwnerPublicKeyArray{
    if (!_chainAccountOwnerPublicKeyArray) {
        _chainAccountOwnerPublicKeyArray = [[NSMutableArray alloc] init];
    }
    return _chainAccountOwnerPublicKeyArray;
}

- (NSMutableArray *)chainAccountActivePublicKeyArray{
    if (!_chainAccountActivePublicKeyArray) {
        _chainAccountActivePublicKeyArray = [[NSMutableArray alloc] init];
    }
    return _chainAccountActivePublicKeyArray;
}

- (void)getAccountPermission:(CompleteBlock)complete{
    WS(weakSelf);
    [self.chainAccountOwnerPublicKeyArray removeAllObjects];
    [self.chainAccountActivePublicKeyArray removeAllObjects];
    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
        EOS_GetAccountResult *result = [EOS_GetAccountResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            NSLog(@"%@", result.message);
            complete(nil , NO);
        }else{
            EOS_GetAccount *model = [EOS_GetAccount mj_objectWithKeyValues:result.data];
            for (EOS_Permission *permission in model.permissions) {
                
                NSMutableArray *keysArray = [EOS_Keys mj_objectArrayWithKeyValuesArray:permission.required_auth_keyArray];
                
                if ([permission.perm_name isEqualToString:@"active"]) {
                    
                    for (EOS_Keys *key in keysArray) {
                        [weakSelf.chainAccountActivePublicKeyArray addObject:key.key];
                    }
                }else if ([permission.perm_name isEqualToString:@"owner"]){
                    
                    for (EOS_Keys *key in keysArray) {
                        [weakSelf.chainAccountOwnerPublicKeyArray addObject:key.key];
                    }
                }
            }
            complete(weakSelf , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
    
    
}


@end
