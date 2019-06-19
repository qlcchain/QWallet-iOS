//
//  NEOBackupDetailViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/12.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class QLCWalletInfo;

@interface QLCBackupDetailViewController : QBaseViewController

@property (nonatomic, strong) QLCWalletInfo *walletInfo;

@end

NS_ASSUME_NONNULL_END
