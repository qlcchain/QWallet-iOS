//
//  DeFiDetailViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class DefiProjectListModel;

typedef void(^DeFiDetailRatingCompleteBlock)(DefiProjectListModel *listM);

@interface DeFiDetailViewController : QBaseViewController

@property (nonatomic, strong) DefiProjectListModel *inputProjectListM;
@property (nonatomic, copy) DeFiDetailRatingCompleteBlock rateCompleteB;

@end

NS_ASSUME_NONNULL_END
