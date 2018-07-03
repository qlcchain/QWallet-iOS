//
//  NotifactionView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "NotifactionView.h"

@implementation NotifactionView
+ (instancetype) loadNotifactionView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"NotifactionView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _backView.layer.cornerRadius = 8.0f;
    _backView.layer.masksToBounds = YES;
    _iconImgView.layer.cornerRadius = 5.0f;
    _iconImgView.layer.masksToBounds = YES;
    _lblName.text = APP_NAME;
}

- (void) show
{
    if (!IS_iPhoneX) {
        _contraintTop.constant = STATUS_BAR_HEIGHT;
    }
    [self performSelector:@selector(hide) withObject:self afterDelay:3.0f];
    self.frame = CGRectMake(0,-(80+STATUS_BAR_HEIGHT), SCREEN_WIDTH,80+STATUS_BAR_HEIGHT);
    [AppD.window addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectMake(0,0, SCREEN_WIDTH,80+STATUS_BAR_HEIGHT);
    }];
}

- (void) hide
{
    [UIView animateWithDuration:.3f animations:^{
        self.frame = CGRectMake(0,-(80+STATUS_BAR_HEIGHT), SCREEN_WIDTH,80+STATUS_BAR_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
