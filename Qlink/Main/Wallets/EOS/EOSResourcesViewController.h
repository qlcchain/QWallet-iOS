//
//  EOSResourcesViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/5.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class EOSSymbolModel;

@interface EOSResourcesViewController : QBaseViewController

//@property (nonatomic, copy) NSString *inputTotalAsset;
@property (nonatomic, strong) EOSSymbolModel *inputSymbolM;

@end

NS_ASSUME_NONNULL_END
