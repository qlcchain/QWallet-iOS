//
//  DeFiRatingInfoModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/15.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeFiRatingInfoModel : BBaseModel

@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *qlcAmount;
@property (nonatomic, strong) NSString *projectName;

@end

NS_ASSUME_NONNULL_END
