//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "DeleteWalletConfirmView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"

@interface DeleteWalletConfirmView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;

@end

@implementation DeleteWalletConfirmView

+ (instancetype)getInstance {
    DeleteWalletConfirmView *view = [[[NSBundle mainBundle] loadNibNamed:@"DeleteWalletConfirmView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
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
