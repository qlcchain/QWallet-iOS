//
//  ETHTransactionRecordViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/26.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class EOSSymbolModel;

@interface EOSTransactionRecordViewController : QBaseViewController

@property (nonatomic, strong) EOSSymbolModel *inputSymbol;
@property (nonatomic, strong) NSArray *inputSourceArr;

@end

NS_ASSUME_NONNULL_END
