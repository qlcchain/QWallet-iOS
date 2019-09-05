//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "PaymentDetailsView.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"

@interface PaymentDetailsView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *paymentInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *paymentInfoValLab;
@property (weak, nonatomic) IBOutlet UILabel *toLab;
@property (weak, nonatomic) IBOutlet UILabel *toValLab;
@property (weak, nonatomic) IBOutlet UILabel *fromLab;
@property (weak, nonatomic) IBOutlet UILabel *fromValLab;

@end

@implementation PaymentDetailsView

+ (instancetype)getInstance {
    PaymentDetailsView *view = [[[NSBundle mainBundle] loadNibNamed:@"PaymentDetailsView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    [view configInit];
    return view;
}

- (void)configInit {
    
}

- (void)configWithPayInfo:(NSString *)payInfo amount:(NSString *)amount key1:(NSString *)key1 val1:(NSString *)val1 key2:(NSString *)key2 val2:(NSString *)val2 {
    _paymentInfoValLab.text = payInfo;
    _amountLab.text = amount;
    _toLab.text = key1;
    _toValLab.text = val1;
    _fromLab.text = key2;
    _fromValLab.text = val2;
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_nextBlock) {
        _nextBlock();
    }
    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}

@end


