//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QLCTransferToServerConfirmBlock)(void);

@interface QLCTransferToServerConfirmView : UIView

@property (nonatomic, copy) QLCTransferToServerConfirmBlock confirmBlock;

+ (instancetype)getInstance;
- (void)configWithFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress amount:(NSString *)amount tokenName:(NSString *)tokenName memo:(NSString *)memo;
- (void)show;

@end

NS_ASSUME_NONNULL_END
