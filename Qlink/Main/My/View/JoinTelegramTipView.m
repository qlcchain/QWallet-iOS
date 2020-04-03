//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "JoinTelegramTipView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface JoinTelegramTipView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *claimBtn;
@property (nonatomic, copy) JoinTelegramTipConfirmBlock confirmBlock;

@end

@implementation JoinTelegramTipView

+ (instancetype)getInstance {
    JoinTelegramTipView *view = [[[NSBundle mainBundle] loadNibNamed:@"JoinTelegramTipView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    view.claimBtn.layer.cornerRadius = 25;
    view.claimBtn.layer.masksToBounds = YES;
    [view configInit];
    return view;
}

- (void)configInit {
    _titleLab.text = kLang(@"join_us_on_telegram_to_get_the_latest_qgas_news");
    [_claimBtn setTitle:kLang(@"join_now") forState:UIControlStateNormal];
}

+ (void)show:(JoinTelegramTipConfirmBlock)block {
    JoinTelegramTipView *view = [JoinTelegramTipView getInstance];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:view];
    view.confirmBlock = block;
    [view.tipBack showPopAnimate];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_confirmBlock) {
        _confirmBlock();
    }
    
    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}

@end
