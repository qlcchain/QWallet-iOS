//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MiningActivityModel;

typedef void(^SheetMiningTipConfirmBlock)(void);

@interface SheetMiningTipView : UIView

//+ (instancetype)getInstance;
+ (void)show:(MiningActivityModel *)model confirmB:(SheetMiningTipConfirmBlock)block;

@end

NS_ASSUME_NONNULL_END
