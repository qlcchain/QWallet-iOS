//
//  ChooseDeductionTokenViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2020/2/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TopupDeductionTokenModel;

typedef void(^ChooseTokenCompleteBlock)(TopupDeductionTokenModel *model);

@interface ChooseDeductionTokenViewController : QBaseViewController

@property (nonatomic, copy) ChooseTokenCompleteBlock completeBlock;

@end

NS_ASSUME_NONNULL_END
