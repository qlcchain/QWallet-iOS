//
//  ETHMnemonicViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/22.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ETHWalletInfo;

@interface ETHMnemonicViewController : QBaseViewController

@property (nonatomic, strong) ETHWalletInfo *walletInfo;

@end

NS_ASSUME_NONNULL_END
