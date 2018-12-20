//
//  UIView+ToastAlert.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/27.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ToastAlert)

- (void) showWalletAlertViewWithTitle:(NSString *) alertTitle msg:(NSMutableAttributedString *) msgArrtrbuted isShowTwoBtn:(BOOL) isTwo block:(void (^)(void))calculateBlock;

+ (void) showVPNToastAlertViewWithTopImageName:(NSString *) imageName content:(NSString *) content block:(void (^)(void))clickYesBlock;

@end

NS_ASSUME_NONNULL_END
