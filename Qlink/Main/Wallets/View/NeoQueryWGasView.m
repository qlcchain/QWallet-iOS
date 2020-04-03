//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NeoQueryWGasView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface NeoQueryWGasView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@end

@implementation NeoQueryWGasView

+ (instancetype)getInstance {
    NeoQueryWGasView *view = [[[NSBundle mainBundle] loadNibNamed:@"NeoQueryWGasView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)showWithNum:(NSString *)num {
    _tipLab.text = [NSString stringWithFormat:@"You can get %@ WinqGas",num];
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
