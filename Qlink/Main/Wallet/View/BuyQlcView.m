//
//  ManageFundsView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BuyQlcView.h"
#import "UIView+Animation.h"


@implementation BuyQlcView

+ (BuyQlcView *)getNibView {
    BuyQlcView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"BuyQlcView" owner:self options:nil] firstObject];
    [nibView configTextField];
    return nibView;
}

- (void) configTextField
{
    _txtNEO.delegate = self;
    _txtLineView.textField = _txtNEO;
    //_txtQLC.delegate = self;
    [_txtNEO addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}
- (IBAction)clickBuy:(id)sender {
    if ([_txtNEO.text.trim isEmptyString] || [_txtNEO.text.trim floatValue] == 0.f) {
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"%@ %@ %@ %@ NEO?",NSStringLocalizable(@"want_buy"),_txtQLC.text,NSStringLocalizable(@"amount_of"),_txtNEO.text];
    NSMutableAttributedString *msgArrtrbuted = [[NSMutableAttributedString alloc] initWithString:msg];
    
    [msgArrtrbuted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:16.0] range:[msg rangeOfString:_txtQLC.text]];
    [msgArrtrbuted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:16.0] range:[msg rangeOfString:_txtNEO.text]];
    [self showWalletAlertViewWithTitle:NSStringLocalizable(@"withdrawal") msg:msgArrtrbuted isShowTwoBtn:YES block:^{
        @weakify_self
        if (weakSelf.buyBlcok) {
            weakSelf.buyBlcok(BuyQLCType);
        }
    }];
}
- (IBAction)clickNEOMax:(id)sender {
    
    if (_buyBlcok) {
        _buyBlcok(BuyMaxType);
    }
}
- (IBAction)clickQLCMax:(id)sender {
   // _txtQLC.text = _currentQLC;
}

- (IBAction)backAction:(id)sender {
    [self zoomOutAnimationDuration:.6 target:self callback:@selector(dismiss)];
}

- (void)dismiss {
    [self removeFromSuperview];
    
}

#pragma mark UITextField delegate

- (void)textFieldDidChange:(UITextField *)textField
{
    if (_buyBlcok) {
        _buyBlcok(BuyTxtChangeType);
    }
}

#pragma mark - UITextField delegate
//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (string.length >0) {
        if ([string isEqualToString:@"."]) {
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
        if (textField.text.length == 0) {
            if([string isEqualToString:@"0"]) {
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
    }
    return YES;
    
    /*
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if (string.length >0) {
        if (textField.text.length == 0) {
            if([string isEqualToString:@"."]) {
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        // 当第一个为0时  第二个必须为点
        if (textField.text.length == 1 && [textField.text isEqualToString:@"0"]) {
            if (![string isEqualToString:@"."]) {
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        if ([string isEqualToString:@"."]) {
            if (!isHaveDian) { // 还没有点
                isHaveDian = YES;
                return YES;
            } else{
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        } else {
            if (isHaveDian) {//存在小数点
                //判断小数点的位数
                NSRange ran = [textField.text rangeOfString:@"."];
                if (range.location - ran.location <= 2) {
                    return YES;
                }else{
                    return NO;
                }
            } else {
                return YES;
            }
        }
    }
    
    NSLog(@"text = %@  -- str = %@",textField.text,string);
    return YES; */
}
@end
