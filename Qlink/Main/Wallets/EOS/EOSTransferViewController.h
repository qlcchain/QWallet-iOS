//
//  ETHTransferViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class EOSSymbolModel;

@interface EOSTransferViewController : QBaseViewController

@property (nonatomic, strong) EOSSymbolModel *inputSymbol;
@property (nonatomic, strong) NSArray *inputSourceArr;
@property (nonatomic, strong) NSString *inputAccount_name;

@end

NS_ASSUME_NONNULL_END
