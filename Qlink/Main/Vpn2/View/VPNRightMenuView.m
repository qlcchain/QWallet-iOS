//
//  VPNRightMenuView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNRightMenuView.h"

@implementation VPNRightMenuView

+ (instancetype) loadVPNRightMenuView
{
    VPNRightMenuView *menuView = [[[NSBundle mainBundle] loadNibNamed:@"VPNRightMenuView" owner:self options:nil] lastObject];
    menuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return menuView;
}
- (void) showVPNRightMenuViewWithRanging:(BOOL) isShow
{
    if (!isShow) {
        _rankContraintH.constant = 0;
    }
    if (!IS_iPhoneX) {
        _menuContraintV.constant = 67 + STATUS_BAR_HEIGHT;
    }
    _menuImageView.image = [UIImage imageNamed:isShow?@"img_rectangular_box":@"img_rectangular_box_1"];
    _menuBackView.alpha = 0.0f;
    [AppD.window addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        _menuBackView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}
- (void) hiddenVPNRightMenuView
{
    [AppD.window addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        _menuBackView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)rankingAction:(id)sender {
    if (_menuBlock) {
        _menuBlock(2);
    }
    [self hiddenVPNRightMenuView];
}
- (IBAction)detailsAction:(id)sender {
    if (_menuBlock) {
        _menuBlock(1);
    }
    [self hiddenVPNRightMenuView];
}
- (IBAction)clickBack:(id)sender {
    [self hiddenVPNRightMenuView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
