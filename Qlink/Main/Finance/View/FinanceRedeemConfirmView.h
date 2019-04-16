//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FinanceRedeemConfirmBlock)(void);

@interface FinanceRedeemConfirmView : UIView

@property (nonatomic, copy) FinanceRedeemConfirmBlock confirmBlock;

+ (instancetype)getInstance;
- (void)configWithPrincipal:(NSString *)principal earnings:(NSString *)earnings;
- (void)show;

@end

NS_ASSUME_NONNULL_END
