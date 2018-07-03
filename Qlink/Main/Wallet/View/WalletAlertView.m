//
//  WalletAlertView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletAlertView.h"

@implementation WalletAlertView

+ (instancetype) loadWalletAlertView
{
    WalletAlertView *walletView = [[[NSBundle mainBundle] loadNibNamed:@"WalletAlertView" owner:self options:nil] lastObject];
    walletView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return walletView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}


/**
 显示alertview

 @param isTwo 是否显示两个btn
 */
- (void) showIsTwoBtn:(BOOL)isTwo
{
    _bgView.layer.cornerRadius = 5.0f;
    
    if (isTwo) {
        _okBtn.hidden = YES;
    } else {
        _yesBtn.hidden = YES;
        _cancelBtn.hidden = YES;
    }
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)clickCancel:(id)sender {
     [self hidde];
    if (self.cancelClickBlock) {
        self.cancelClickBlock();
    }
}

- (IBAction)clickYes:(id)sender {
    
    [self hidde];
    if (self.yesClickBlock) {
        self.yesClickBlock();
    }
}

@end
