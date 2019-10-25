//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WalletCommonModel;

typedef void(^TopupPayCompleteBlock)(void);

@interface TopupPayLoadView : UIView

+ (instancetype)getInstance;
- (void)config:(WalletCommonModel *)model symbol:(NSString *)symbol completeB:(TopupPayCompleteBlock)completeB;
- (void)show;
- (void)hide;
- (void)startPayAnimate;

@end

NS_ASSUME_NONNULL_END
