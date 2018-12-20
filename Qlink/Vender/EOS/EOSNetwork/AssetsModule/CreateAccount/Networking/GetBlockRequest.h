//
//  CreateAccountRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/19.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "BaseHttpsNetworkRequest.h"

//@interface CreateAccountRequest : BaseNetworkRequest
@interface GetBlockRequest : BaseHttpsNetworkRequest

@property(nonatomic, strong) NSString *block_num_or_id;

@end
