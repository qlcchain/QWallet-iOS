//
//  GroupBuyDetialViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2020/1/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TopupProductModel, TopupCountryModel, TopupDeductionTokenModel;

@interface GroupBuyDetialViewController : QBaseViewController

@property (nonatomic, strong) TopupProductModel *inputProductM;
@property (nonatomic, strong) TopupCountryModel *inputCountryM;
@property (nonatomic, strong) TopupDeductionTokenModel *inputDeductionTokenM;
@property (nonatomic, strong) NSString *inputPhoneNum;

@end

NS_ASSUME_NONNULL_END
