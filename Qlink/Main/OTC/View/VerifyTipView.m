//
//  TipOKView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "VerifyTipView.h"

@interface VerifyTipView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation VerifyTipView

+ (instancetype)getInstance {
    VerifyTipView *view = [[[NSBundle mainBundle] loadNibNamed:@"VerifyTipView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)showWithTitle:(NSString *)title {
    _titleLab.text = title;
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

- (IBAction)cancelAction:(id)sender {
    [self hide];
}


@end
