//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "TradeIDInputView.h"
//#import "UIView+Visuals.h"
#import "UITextView+ZWPlaceHolder.h"
#import "GlobalConstants.h"

@interface TradeIDInputView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UITextView *textV;


@end

@implementation TradeIDInputView

+ (instancetype)getInstance {
    TradeIDInputView *view = [[[NSBundle mainBundle] loadNibNamed:@"TradeIDInputView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    [view configInit];
    return view;
}

- (void)configInit {
    _textV.placeholder = kLang(@"transaction_id");
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
    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}


@end
