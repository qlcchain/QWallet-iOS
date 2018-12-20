//
//  Get_account_permission_service.h
//  pocketEOS
//
//  Created by oraclechain on 2018/11/19.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseService.h"
#import "GetAccountRequest.h"
#import "EOS_GetAccountResult.h"
#import "EOS_GetAccount.h"
#import "EOS_Permission.h"

NS_ASSUME_NONNULL_BEGIN

@interface Get_account_permission_service : BaseService
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;


- (void)getAccountPermission:(CompleteBlock)complete;


@property(nonatomic , strong) NSMutableArray *chainAccountOwnerPublicKeyArray;
@property(nonatomic , strong) NSMutableArray *chainAccountActivePublicKeyArray;
@end

NS_ASSUME_NONNULL_END
