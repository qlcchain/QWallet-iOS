//
//  UIView+HUD.h
//  Qlink
//
//  Created by 旷自辉 on 2018/5/15.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;
- (void)showHudInView:(UIView *)view hint:(NSString *)hint userInteractionEnabled: (BOOL) isEnabled hideTime:(CGFloat) time;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;
- (void)showView:(UIView *)view hint:(NSString *)hint;

@end
