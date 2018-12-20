//
//  ETHWalletDetailViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/26.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class WalletCommonModel;

@interface ETHWalletDetailViewController : QBaseViewController

@property (nonatomic, strong) WalletCommonModel *inputWalletCommonM;
@property (nonatomic) BOOL isDeleteCurrentWallet;

@end

NS_ASSUME_NONNULL_END
