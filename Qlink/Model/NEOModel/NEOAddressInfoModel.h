//
//  NEOAddressInfoModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/12.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NEOUnspentModel : BBaseModel

@property (nonatomic, strong) NSNumber * n;// = 0;
@property (nonatomic, strong) NSString * txid;// = ca413e64f84e738f734a1e372dbf15f66a42a0f05b1f18b7cabb719d170a3457;
@property (nonatomic, strong) NSNumber * value;// = "1e-08";

@end

@interface NEOAssetModel : BBaseModel

@property (nonatomic, strong) NSString * asset;
@property (nonatomic, strong) NSNumber * amount;
@property (nonatomic, strong) NSString * asset_hash;
@property (nonatomic, strong) NSString * asset_symbol;
@property (nonatomic, strong) NSArray * unspent;

- (NSString *)getTokenNum;
- (NSString *)getPrice:(NSArray *)tokenPriceArr;

@end

@interface NEOAddressInfoModel : BBaseModel

@property (nonatomic, strong) NSNumber * amount;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSArray * balance;

@end

NS_ASSUME_NONNULL_END
