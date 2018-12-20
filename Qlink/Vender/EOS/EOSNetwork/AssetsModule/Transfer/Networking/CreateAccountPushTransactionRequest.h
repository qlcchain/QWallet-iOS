//
//  PushTransactionRequest.h
//  pocketEOS
//
//  Created by oraclechain on 2018/3/21.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHttpsNetworkRequest.h"

@interface CreateAccountPushTransactionRequest : BaseHttpsNetworkRequest

@property(nonatomic, copy) NSString *packed_trx;
@property(nonatomic, copy) NSString *signatureStr;

@property (nonatomic, copy) NSDictionary *transactionDic;

@end
