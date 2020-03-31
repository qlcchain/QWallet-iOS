//
//  StartGroupViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2020/2/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TopupProductModel,TopupDeductionTokenModel;

typedef void(^StartGroupBuySuccessBlock)(void);

@interface StartGroupViewController : QBaseViewController

@property (nonatomic, strong) TopupProductModel *inputProductM;
@property (nonatomic, strong) TopupDeductionTokenModel *inputDeductionTokenM;
@property (nonatomic, copy) StartGroupBuySuccessBlock successBlock;

@end

NS_ASSUME_NONNULL_END
