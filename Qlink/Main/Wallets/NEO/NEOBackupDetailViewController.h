//
//  NEOBackupDetailViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/12.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class NEOWalletInfo;

@interface NEOBackupDetailViewController : QBaseViewController

@property (nonatomic, strong) NEOWalletInfo *walletInfo;

@end

NS_ASSUME_NONNULL_END
