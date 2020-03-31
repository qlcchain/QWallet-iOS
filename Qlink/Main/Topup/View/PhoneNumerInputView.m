//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "PhoneNumerInputView.h"
//#import "UIView+Visuals.h"
#import "UITextView+ZWPlaceHolder.h"
#import "GlobalConstants.h"

@interface PhoneNumerInputView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UITextView *textV;


@end

@implementation PhoneNumerInputView

+ (instancetype)getInstance {
    PhoneNumerInputView *view = [[[NSBundle mainBundle] loadNibNamed:@"PhoneNumerInputView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    [view configInit];
    return view;
}

- (void)configInit {
    _textV.placeholder = kLang(@"phone_number");
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_confirmBlock) {
        _confirmBlock(_textV.text);
    }
//    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}


@end
