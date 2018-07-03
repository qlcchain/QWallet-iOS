//
//  UIView+HUD.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/15.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIView (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    
    //修改样式，否则等待框背景色将为半透明
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
    //设置菊花框为白色
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    HUD.label.textColor = [UIColor whiteColor];
    
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = hint;
    HUD.label.numberOfLines = 0;
    [self setHUD:HUD];
    [view addSubview:HUD];
    [HUD showAnimated:YES];
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint userInteractionEnabled: (BOOL) isEnabled hideTime:(CGFloat)time{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = hint;
    HUD.label.numberOfLines = 0;
    [self setHUD:HUD];
    [view addSubview:HUD];
    [HUD showAnimated:YES];

    HUD.userInteractionEnabled = isEnabled;
    if (time > 0) {
        [HUD hideAnimated:YES afterDelay:time];
    }
}

- (void)showView:(UIView *)view hint:(NSString *)hint{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view addSubview:HUD];
    HUD.userInteractionEnabled = NO;
    
    // Configure for text only and offset down
    HUD.mode = MBProgressHUDModeText;
    HUD.label.text = hint;
    HUD.label.numberOfLines = 0;
    HUD.margin = 10.f;
    HUD.yOffset = IS_iPhone_5?200.f:150.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hideAnimated:YES afterDelay:2];
}


- (void)showHint:(NSString *)hint
{
    //显示提示信息
//    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.numberOfLines = 0;
    hud.margin = 10.f;
    hud.yOffset = SCREEN_HEIGHT/2 - Tab_BAR_HEIGHT - STATUS_BAR_HEIGHT;
    hud.removeFromSuperViewOnHide = YES;
    [self setHUD:hud];
    CGFloat delay = 2.0f;
    NSInteger textLegth = [NSStringUtil getNotNullValue:hint].length;
    if (textLegth >= 8) {
        delay = 3.0f;
    }
    [hud hideAnimated:YES afterDelay:delay];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.numberOfLines = 0;
    hud.margin = 10.f;
    hud.yOffset = IS_iPhone_5?200.f:150.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)hideHud{
    [[self HUD] hideAnimated:YES];
}

@end
