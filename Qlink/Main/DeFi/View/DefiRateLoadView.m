//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "DefiRateLoadView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface DefiRateLoadView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
//@property (weak, nonatomic) IBOutlet UILabel *importantLab;

@end

@implementation DefiRateLoadView

+ (instancetype)getInstance {
    DefiRateLoadView *view = [[[NSBundle mainBundle] loadNibNamed:@"DefiRateLoadView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    _titleLab.text = kLang(@"defi_please_wait");
    _tipLab.text = kLang(@"defi_checking_your_exclusive__");
//    _importantLab.text = kLang(@"defi_important_dont__");
    [self.tipBack showPopAnimate];
    
}

- (void)hide {
    [self removeFromSuperview];
}


@end
