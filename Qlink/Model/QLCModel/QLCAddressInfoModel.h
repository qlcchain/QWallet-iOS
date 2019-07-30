//
//  QLCAddressInfoModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/5/27.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

@class QLCTokenInfoModel;

@interface QLCTokenModel : BBaseModel

@property (nonatomic, strong) NSString *type; //": "45dd217cd9ff89f7b64ceda4886cc68dde9dfa47a8a422d165e2ce6f9a834fad",
@property (nonatomic, strong) NSString *header; //": "758f79b656340c329cb5b11302865c5ff0b0c99fd8a268d6b8760170e33e8cd1",
@property (nonatomic, strong) NSString *representative; //": "qlc_1t1uynkmrs597z4ns6ymppwt65baksgdjy1dnw483ubzm97oayyo38ertg44",
@property (nonatomic, strong) NSString *open; //": "758f79b656340c329cb5b11302865c5ff0b0c99fd8a268d6b8760170e33e8cd1",
@property (nonatomic, strong) NSString *balance; //": "40000000000000",
@property (nonatomic, strong) NSString *account; //": "qlc_1t1uynkmrs597z4ns6ymppwt65baksgdjy1dnw483ubzm97oayyo38ertg44",
@property (nonatomic, strong) NSNumber *modified; //": 1552455585,
@property (nonatomic, strong) NSNumber *blockCount; //": 1,
@property (nonatomic, strong) NSString *tokenName; //": "QLC",
@property (nonatomic, strong) NSString *pending; //": "0"
@property (nonatomic, strong) QLCTokenInfoModel *tokenInfoM;

- (NSString *)getTokenNum;
- (NSString *)getPrice:(NSArray *)tokenPriceArr;
- (NSUInteger)getTransferNum:(NSString *)input;

@end

@interface QLCAddressInfoModel : BBaseModel

@property (nonatomic, strong) NSString *account; //": "qlc_1u1d7mgo8hq5nad8jwesw6azfk53a31ge5minwxdfk8t1fqknypqgk8mi3z7",
@property (nonatomic, strong) NSNumber *coinBalance; //": "0",
@property (nonatomic, strong) NSNumber *vote; //": "4400000000",
@property (nonatomic, strong) NSNumber *network; //": "0",
@property (nonatomic, strong) NSNumber *storage; //": "0",
@property (nonatomic, strong) NSNumber *oracle; //": "0",
@property (nonatomic, strong) NSString *representative; //": "qlc_1t1uynkmrs597z4ns6ymppwt65baksgdjy1dnw483ubzm97oayyo38ertg44",
@property (nonatomic, strong) NSArray *tokens; //"

@end
