//
//  EOSTraceModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/4.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EOSTraceModel : BBaseModel

@property (nonatomic, strong) NSString * trx_id;//" : "dfab30f059c8180d6aa04db5818486cc67daaa35a63b6d58d47a53eadb8be4f3",
@property (nonatomic, strong) NSString * symbol;//" : "HVT",
@property (nonatomic, strong) NSString * code;//" : "hirevibeshvt",
@property (nonatomic, strong) NSNumber * quantity;//" : "0.8775",
@property (nonatomic, strong) NSString * receiver;//" : "yfhuangeos55",
@property (nonatomic, strong) NSString * sender;//" : "airdropsdac5",
@property (nonatomic, strong) NSString * memo;//" : "*HireVibes (HVT) https://www.hirevibes.io/ Token Airdrop and Claim opportunity has started. For more info visit: https://goo.gl/nrELgi | To claim, use our website Claim Tool OR go to: https://goo.gl/em1x3o OR Transfer any amount of HVT to any account.*",
@property (nonatomic, strong) NSString * timestamp;//" : "2018-11-05T05:26:28.500",
@property (nonatomic, strong) NSString * status;//" : "executed"

- (NSString *)getTokenNum;

@end

NS_ASSUME_NONNULL_END
