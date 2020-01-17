//
//  TopupViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseViewController.h"
#import "ProjectEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class TopupOrderModel;

@interface TopupCredentialViewController : QBaseViewController

@property (nonatomic, strong) TopupOrderModel *inputCredentailM;
@property (nonatomic) TopupPayType inputPayType;

@end

NS_ASSUME_NONNULL_END
