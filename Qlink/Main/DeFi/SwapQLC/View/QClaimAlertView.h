//
//  QClaimAlertView.h
//  Qlink
//
//  Created by 旷自辉 on 2020/8/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WalletCommonModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^QClaimConfirmBlock)(NSString *gasPrice);

@interface QClaimAlertView : UIView

@property (nonatomic, copy) QClaimConfirmBlock confirmBlock;

+ (instancetype)getInstance;
- (void)configWithFromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress amount:(NSString *)amount tokenName:(NSString *)tokenName fromType:(NSInteger) walletType alertTitle:(NSString *) alertTitle ethAddress:(NSString *) ethAddress;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
