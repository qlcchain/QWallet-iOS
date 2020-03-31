//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NeoClaimGasTipView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"

@interface NeoClaimGasTipView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@end

@implementation NeoClaimGasTipView

+ (instancetype)getInstance {
    NeoClaimGasTipView *view = [[[NSBundle mainBundle] loadNibNamed:@"NeoClaimGasTipView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)showWithNum:(NSString *)num {
    _tipLab.text = [NSString stringWithFormat:@"There are %@ GAS available to claim.",num];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_claimBlock) {
        _claimBlock();
    }
    [self hide];
}

- (IBAction)closeAction:(id)sender {
    if (_closeBlock) {
        _closeBlock();
    }
    [self hide];
}


@end
