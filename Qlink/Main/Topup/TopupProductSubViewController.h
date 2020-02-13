//
//  TopupProductSubViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2020/2/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TopupDeductionTokenModel,TopupCountryModel;

typedef void(^TopupUpdateTableHeightBlock)(CGFloat tableHeight);

@interface TopupProductSubViewController : QBaseViewController

@property (nonatomic, strong) NSString *inputGlobalRoaming;
@property (nonatomic, strong) TopupDeductionTokenModel *inputDeductionTokenM;
@property (nonatomic, strong) TopupCountryModel *inputCountryM;
@property (nonatomic, copy) TopupUpdateTableHeightBlock updateTableHeightBlock;

- (void)pullRefresh;
- (CGFloat)getTableHeight;

@end

NS_ASSUME_NONNULL_END
