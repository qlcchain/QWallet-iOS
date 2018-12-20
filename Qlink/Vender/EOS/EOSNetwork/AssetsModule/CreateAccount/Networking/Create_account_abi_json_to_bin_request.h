//
//  Buy_ram_abi_json_to_bin_request.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/22.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseHttpsNetworkRequest.h"

@interface Create_account_abi_json_to_bin_request : BaseHttpsNetworkRequest

@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;

@property(nonatomic, copy) NSString *creator;
@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSString *ownerPublicKey;
@property(nonatomic, copy) NSString *activePublicKey;


@end
