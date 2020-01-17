//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GroupBuyGoStakeOKBlock)(void);

@interface GroupBuyGoStakeView : UIView

@property (nonatomic, copy) GroupBuyGoStakeOKBlock okBlock;

+ (instancetype)getInstance;
- (void)show;

@end

NS_ASSUME_NONNULL_END
