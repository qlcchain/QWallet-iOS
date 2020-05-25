//
//  DefiProjectListModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DefiProjectListModel : BBaseModel


@property (nonatomic, strong) NSString *category;// = Lending;
@property (nonatomic, strong) NSString *chain;// = Ethereum;
@property (nonatomic, strong) NSString *ID;// = 09a2d7eb18104faeb4ff6d556bae7757;
@property (nonatomic, strong) NSString *name;// = dForce;
@property (nonatomic, strong) NSString *tvlUsd;
//@property (nonatomic) double tvlUsd;// = "0E-12";
//@property (nonatomic, strong) NSString *tvlUsd_str;// = "";
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSArray *cache;

- (NSString *)getShowName;
- (UIColor *)getCategoryColor;
+ (NSString *)getExperUrl:(NSString *)project;

@end

NS_ASSUME_NONNULL_END
