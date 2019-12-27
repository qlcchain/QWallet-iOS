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

typedef void(^EOSTransferConfirmBlock)(void);

@interface EOSTransferConfirmView : UIView

@property (nonatomic, copy) EOSTransferConfirmBlock confirmBlock;

+ (instancetype)getInstance;
- (void)configWithFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress amount:(NSString *)amount memo:(NSString *)memo;
- (void)configWithWallet:(WalletCommonModel *)fromM to:(NSString *)sendto amount:(NSString *)amount memo:(NSString *)memo showMemo:(BOOL)showMemo;
- (void)show;

@end

NS_ASSUME_NONNULL_END
