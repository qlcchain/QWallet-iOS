//
//  WalletsSwitchViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"
#import "ProjectEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class WalletCommonModel;

typedef void(^WalletSelectBlock)(WalletCommonModel *model);

@interface WalletSelectViewController : QBaseViewController

@property (nonatomic) WalletType inputWalletType;
@property (nonatomic, strong) WalletCommonModel *showSelectWalletM;

- (void)configSelectBlock:(WalletSelectBlock)block;

@end

NS_ASSUME_NONNULL_END
