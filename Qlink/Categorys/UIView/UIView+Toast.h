//
//  UIView+HUD.h
//  Qlink
//
//  Created by 旷自辉 on 2018/5/15.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Toast)

- (void)makeToastInView:(UIView *)view;
- (void)makeToastInView:(UIView *)view userInteractionEnabled: (BOOL)isEnabled hideTime:(CGFloat)time;
- (void)makeToastInView:(UIView *)view text:(NSString *)text;
- (void)makeToastInView:(UIView *)view text:(NSString *)text userInteractionEnabled: (BOOL)isEnabled hideTime:(CGFloat)time;
- (void)hideToast;

//- (void)makeToastInView:(UIView *)view text:(NSString *)text mark:(NSString *)mark;
//- (void)hideToast:(NSString *)mark;

- (void)makeToastDisappearInView:(UIView *)view text:(NSString *)text;
- (void)makeToastDisappearWithText:(NSString *)text;
// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)makeToastDisappearWithText:(NSString *)text yOffset:(float)yOffset;

@end
