//
//  DeFiRatingViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class DefiProjectModel;

typedef void(^DeFiRatingSuccessBlock)(NSString *rating);

@interface DeFiRatingViewController : QBaseViewController

@property (nonatomic, strong) DefiProjectModel *inputProjectM;
@property (nonatomic, copy) DeFiRatingSuccessBlock ratingSuccessB;

@end

NS_ASSUME_NONNULL_END
