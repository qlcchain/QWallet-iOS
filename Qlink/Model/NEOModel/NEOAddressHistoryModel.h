//
//  NEOAddressHistoryModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/13.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NEOAddressHistoryModel : BBaseModel

@property (nonatomic, strong) NSString *symbol; //" : "GAS",
@property (nonatomic, strong) NSNumber *amount;//" : "0.5",
@property (nonatomic, strong) NSString *address_to;//" : "AN8HRMfe1XvzcPLvPXVBiVd2XAmhq7tYNy",
@property (nonatomic, strong) NSString *txid;//" : "f0c8b4ddbd25cfb1c974b47f4002c73c404866406bce1679c583ad81e0a4e745",
@property (nonatomic, strong) NSNumber *time;//" : 1539089421,
@property (nonatomic, strong) NSNumber *block_height;//" : 1866264,
@property (nonatomic, strong) NSString *asset;//" : "602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
@property (nonatomic, strong) NSString *address_from;//" : "APeTXAPz3UEekLPu5fye26XdmCVjZVUX1P"

- (NSString *)getTokenNum;

@end

NS_ASSUME_NONNULL_END
