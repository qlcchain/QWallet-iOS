//
//  DefiProjectModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/8.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DefiProject_ValModel : BBaseModel

@property (nonatomic, strong) NSString *relative_1d;
@property (nonatomic, strong) NSString *value;

@end

@interface DefiProject_KeyModel : BBaseModel

@property (nonatomic, strong) NSString *keyStr;
@property (nonatomic, strong) DefiProject_ValModel *valModel;

@end

@interface DefiProjectModel : BBaseModel

@property (nonatomic, strong) NSString *category;// = Payments;
@property (nonatomic, strong) NSString *chain;// = Ethereum;
@property (nonatomic, strong) NSString *contributesTo;// = "";
@property (nonatomic, strong) NSString *Description;// = "";
@property (nonatomic, strong) NSString *ID;// = 9f76d700de1c4ff3b1003e63c0d83236;
@property (nonatomic, strong) NSString *jsonValue;// = "{\"balance\":{\"ERC20\":{\"DAI\":{\"relative_1d\":-0.15,\"value\":12266.2020454265}}},\"total\":{\"BTC\":{},\"ETH\":{},\"USD\":{\"relative_1d\":0.31,\"value\":12395}},\"tvl\":{\"BTC\":{\"relative_1d\":0.21,\"value\":1.3724339526540736},\"ETH\":{\"relative_1d\":0.75,\"value\":59.67167340650876},\"USD\":{\"relative_1d\":0.31,\"value\":12395}}}";
@property (nonatomic, strong) NSString *name;// = Connext;
@property (nonatomic, strong) NSString *permissioning;// = "";
@property (nonatomic, strong) NSString *rating;// = 0;
@property (nonatomic, strong) NSString *relative;// = "0.31";
@property (nonatomic, strong) NSString *tvlUsd;// = "12395.000000000000";
@property (nonatomic, strong) NSString *variability;// = "";
@property (nonatomic, strong) NSString *website;// = "";
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *qlcAmount;
@property (nonatomic, strong) NSString *projectName;

@property (nonatomic, strong) NSArray *tvlArr;

+ (NSString *)getRatingStr:(NSString *)_ratingr;
+ (UIColor *)getRatingColor:(NSString *)_rating;
- (NSString *)getShowName;
- (UIColor *)getCategoryColor;
+ (NSString *)getExperUrl:(NSString *)project;
+ (NSString *)getScoreStr:(NSString *)_selectRate;

@end

NS_ASSUME_NONNULL_END
