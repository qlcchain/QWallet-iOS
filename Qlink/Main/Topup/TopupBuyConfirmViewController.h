//
//  JoinGroupBuyViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2020/2/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TopupOrderModel,TopupProductModel,TopupDeductionTokenModel,GroupBuyListModel;

//typedef void(^JoinGroupBuySuccessBlock)(TopupOrderModel *model);

@interface TopupBuyConfirmViewController : QBaseViewController

@property (nonatomic, strong) TopupProductModel *inputProductM;
@property (nonatomic, strong) TopupDeductionTokenModel *inputDeductionTokenM;
//@property (nonatomic, strong) GroupBuyListModel *inputGroupBuyListM;
//@property (nonatomic, copy) JoinGroupBuySuccessBlock successBlock;

@end

NS_ASSUME_NONNULL_END
