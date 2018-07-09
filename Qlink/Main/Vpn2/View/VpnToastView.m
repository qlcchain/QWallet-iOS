//
//  VpnToastView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VpnToastView.h"

@implementation VpnToastView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _backView.layer.cornerRadius = 8.0f;
}

+ (instancetype) loadVPN2ToastView
{
    VpnToastView *toastView = [[[NSBundle mainBundle] loadNibNamed:@"VpnToastView" owner:self options:nil] lastObject];
    toastView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return toastView;
}

- (void) showToastView
{
    [AppD.window addSubview:self];
    self.alpha = 0.f;
    @weakify_self
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 隐藏alertview
 */
- (void) hidde
{
    @weakify_self
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.alpha = 0.f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}

- (IBAction)clickNo:(id)sender {
    
    [self hidde];
}
- (IBAction)clickYes:(id)sender {
    if (_yesClickBlock) {
        _yesClickBlock();
    }
}
@end
