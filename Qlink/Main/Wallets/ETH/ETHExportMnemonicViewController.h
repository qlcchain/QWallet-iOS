//
//  ETHMnemonicViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/22.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ETHExportMnemonicEnterTypeImport,
    ETHExportMnemonicEnterTypeExport,
} ETHExportMnemonicEnterType;

@interface ETHExportMnemonicViewController : QBaseViewController

@property (nonatomic) ETHExportMnemonicEnterType enterType;

@end

NS_ASSUME_NONNULL_END
