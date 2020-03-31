//
//  ChooseCountryCodeViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2019/12/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TopupCountryModel;

typedef void(^ChooseCountryCodeResultBlock)(TopupCountryModel *selectM);

@interface ChooseCountryCodeViewController : QBaseViewController

@property (nonatomic, strong) NSString *inputCountryCode;
@property (nonatomic, copy) ChooseCountryCodeResultBlock resultB;

@end

NS_ASSUME_NONNULL_END
