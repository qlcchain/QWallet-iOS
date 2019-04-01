//
//  CreateETHWalletViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/22.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class NEOWalletInfo;

@interface NEOCreateWalletViewController : QBaseViewController

@property (nonatomic, strong) NEOWalletInfo *walletInfo;

@end

NS_ASSUME_NONNULL_END
