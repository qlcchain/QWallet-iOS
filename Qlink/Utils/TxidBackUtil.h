//
//  TxidBackUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/11/22.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TxidBackModel : BBaseModel

@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *chain;
@property (nonatomic, strong) NSString *tokenName;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *type1;

@end

@interface TxidBackUtil : NSObject

+ (void)requestSys_txid_backup:(TxidBackModel *)model completeBlock:(void(^)(BOOL success, NSString *msg))completeBlock;

@end

NS_ASSUME_NONNULL_END
