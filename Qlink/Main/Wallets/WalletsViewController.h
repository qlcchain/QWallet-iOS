//
//  WalletsViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/25.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class QLCTokenModel,Token;

@interface WalletsViewController : QBaseViewController

- (QLCTokenModel *)getQGASAsset;
- (Token *)getUSDTAsset;

@end

NS_ASSUME_NONNULL_END
