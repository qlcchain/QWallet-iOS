//
//  NEOWalletDetailViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class WalletCommonModel,EOSSymbolModel;

@interface EOSWalletDetailViewController : QBaseViewController

@property (nonatomic, strong) WalletCommonModel *inputWalletCommonM;
@property (nonatomic) BOOL isDeleteCurrentWallet;
@property (nonatomic, strong) EOSSymbolModel *inputSymbolM;

@end

NS_ASSUME_NONNULL_END
