//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "MnemonicTipView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface MnemonicTipView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;

@end

@implementation MnemonicTipView

+ (instancetype)getInstance {
    MnemonicTipView *view = [[[NSBundle mainBundle] loadNibNamed:@"MnemonicTipView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    [self.tipBack showPopAnimate];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_okBlock) {
        _okBlock();
    }
    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}


@end
