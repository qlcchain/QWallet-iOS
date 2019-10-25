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
typedef void(^TopupPayCloseBlock)(void);

@interface TopupPayLoadView : UIView

+ (instancetype)getInstance;
- (void)config:(WalletCommonModel *)model symbol:(NSString *)symbol completeB:(TopupPayCompleteBlock)completeB closeB:(TopupPayCloseBlock)closeB;
- (void)show;
- (void)hide;
- (void)startPayAnimate1;
- (void)startPayAnimate2;
- (void)showCloseBtn;

@end

NS_ASSUME_NONNULL_END
