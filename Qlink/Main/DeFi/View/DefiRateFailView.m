//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "DefiRateFailView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface DefiRateFailView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation DefiRateFailView

+ (instancetype)getInstance {
    DefiRateFailView *view = [[[NSBundle mainBundle] loadNibNamed:@"DefiRateFailView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)show {
    self.titleLab.text = kLang(@"defi_rate_fail_no_qlc_tip");
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    [self.tipBack showPopAnimate];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:2];
}

- (void)hide {
    [self removeFromSuperview];
}


@end
