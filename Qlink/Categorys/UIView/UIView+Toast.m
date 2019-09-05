//
//  UIView+HUD.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/15.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "GlobalConstants.h"

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;
//static const void *HttpRequestHUDMarkKey = &HttpRequestHUDMarkKey;
//static const void *HttpRequestMark = &HttpRequestMark;
//static const void *HttpRequestHUDMarkState = &HttpRequestHUDMarkState;

@implementation UIView (Toast)

//- (NSNumber *)getHUDMarkState {
//    return objc_getAssociatedObject(self, HttpRequestHUDMarkState);
//}
//
//- (void)setHUDMarkState:(NSNumber *)state {
//    objc_setAssociatedObject(self, HttpRequestHUDMarkState, state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSString *)getCurrentMark {
//    return objc_getAssociatedObject(self, HttpRequestMark);
//}
//
//- (void)setCurrentMark:(NSString *)mark {
//    objc_setAssociatedObject(self, HttpRequestMark, mark, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (MBProgressHUD *)HUDMark {
//    return objc_getAssociatedObject(self, HttpRequestHUDMarkKey);
//}
//
//- (void)setHUDMark:(MBProgressHUD *)HUDMark {
//    //修改样式，否则等待框背景色将为半透明
//    HUDMark.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    HUDMark.bezelView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
//    //设置菊花框为白色
//    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
//    HUDMark.label.textColor = [UIColor whiteColor];
//
//    objc_setAssociatedObject(self, HttpRequestHUDMarkKey, HUDMark, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

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

- (void)makeToastInView:(UIView *)view {
    if ([self HUD]) {
        [self hideToast];
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = nil;
    HUD.label.numberOfLines = 0;
    [self setHUD:HUD];
    [view addSubview:HUD];
    [HUD showAnimated:YES];
}

- (void)makeToastInView:(UIView *)view userInteractionEnabled: (BOOL)isEnabled hideTime:(CGFloat)time {
    if ([self HUD]) {
        [self hideToast];
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = nil;
    HUD.label.numberOfLines = 0;
    [self setHUD:HUD];
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    
    HUD.userInteractionEnabled = !isEnabled;
    //    HUD.backgroundView.userInteractionEnabled = isEnabled;
    HUD.removeFromSuperViewOnHide = YES;
    if (time > 0) {
        [HUD hideAnimated:YES afterDelay:time];
    }
}

- (void)makeToastInView:(UIView *)view text:(NSString *)text {
    if ([self HUD]) {
        [self hideToast];
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = text;
    HUD.label.numberOfLines = 0;
    [self setHUD:HUD];
    [view addSubview:HUD];
    [HUD showAnimated:YES];
}

- (void)makeToastInView:(UIView *)view text:(NSString *)text userInteractionEnabled:(BOOL)isEnabled hideTime:(CGFloat)time {
    if ([self HUD]) {
        [self hideToast];
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = text;
    HUD.label.numberOfLines = 0;
    [self setHUD:HUD];
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    
    HUD.userInteractionEnabled = !isEnabled;
    HUD.removeFromSuperViewOnHide = YES;
    if (time > 0) {
        [HUD hideAnimated:YES afterDelay:time];
    }
}

- (void)makeToastDisappearInView:(UIView *)view text:(NSString *)text {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view addSubview:HUD];
    HUD.userInteractionEnabled = YES;
    
    // Configure for text only and offset down
    HUD.mode = MBProgressHUDModeText;
    HUD.label.text = text;
    HUD.label.numberOfLines = 0;
    HUD.margin = 10.f;
    HUD.yOffset = IS_iPhone_5?200.f:150.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hideAnimated:YES afterDelay:2];
}

- (void)makeToastDisappearWithText:(NSString *)text {
    
    [QToastView showWithTitle:text];
    return;
    
    if ([self HUD]) {
        [self hideToast];
    }
    
    //显示提示信息
    //    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.userInteractionEnabled = YES;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.margin = 10.f;
    hud.yOffset = SCREEN_HEIGHT/2 - Height_TabBar - Height_StatusBar;
    hud.removeFromSuperViewOnHide = YES;
    [self setHUD:hud];
    CGFloat delay = 2.0f;
    NSInteger textLegth = [NSStringUtil getNotNullValue:text].length;
    if (textLegth >= 8) {
        delay = 3.0f;
    }
    [hud hideAnimated:YES afterDelay:delay];
}

- (void)makeToastDisappearWithText:(NSString *)text yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = YES;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.margin = 10.f;
    hud.yOffset = IS_iPhone_5?200.f:150.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)hideToast {
    MBProgressHUD *HUD = [self HUD];
    [HUD hideAnimated:YES];
}

//- (void)makeToastInView:(UIView *)view text:(NSString *)text mark:(NSString *)mark {
//    MBProgressHUD *HUDMark = [self HUDMark];
//    NSNumber *HUDMarkState = [self getHUDMarkState];
//    if (HUDMark && HUDMarkState && [HUDMarkState boolValue] == YES) {
//        return;
////        [self hideToast:mark];
//    }
//
//    [self setCurrentMark:mark];
//    [self setHUDMarkState:@(YES)];
//
//    HUDMark = [[MBProgressHUD alloc] initWithView:view];
//    HUDMark.label.text = text;
//    HUDMark.label.numberOfLines = 0;
//    [self setHUDMark:HUDMark];
//    [view addSubview:HUDMark];
//    [HUDMark showAnimated:YES];
//}
//
//- (void)hideToast:(NSString *)mark {
//    NSString *currentMark = [self getCurrentMark];
//    if (![mark isEqualToString:currentMark]) {
//        return;
//    }
//
//    [self setHUDMarkState:@(NO)];
//    MBProgressHUD *HUDMark = [self HUDMark];
//    [HUDMark hideAnimated:YES];
//}

@end
