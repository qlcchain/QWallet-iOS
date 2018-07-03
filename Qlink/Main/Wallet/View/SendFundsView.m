//
//  ManageFundsView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "SendFundsView.h"
#import "UIView+Animation.h"

#import "NSString+RegexCategory.h"

@implementation SendFundsView

+ (SendFundsView *)getNibView {
    SendFundsView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"SendFundsView" owner:self options:nil] firstObject];

    [nibView configTextField];
    return nibView;
}

- (void) configTextField
{
    _txtLineView.textField = _txtMoney;
    _txtMoney.delegate = self;
    [_txtMoney addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}
- (IBAction)clickCode:(id)sender {
    
    if (_sendBlock) {
        _sendBlock(CodeType);
    }
}

- (IBAction)backAction:(id)sender {
    [self zoomOutAnimationDuration:.6 target:self callback:@selector(dismiss)];
}
- (IBAction)clickPaste:(id)sender {
    
    UIPasteboard *generalPasteboard = [UIPasteboard generalPasteboard];
    NSMutableArray *types = [[NSMutableArray alloc] init];
    [types addObjectsFromArray:UIPasteboardTypeListString];
    @weakify_self
    if ([generalPasteboard containsPasteboardTypes:types]) {
        weakSelf.lblAddress.text = generalPasteboard.string;
    }
}

- (void)dismiss {
    [self removeFromSuperview];
}
- (IBAction)clickSendNow:(id)sender {
    
    if ([_txtMoney.text.trim isEmptyString] || [_lblAddress.text.trim isEmptyString] || [_txtMoney.text.trim floatValue] == 0.f) {
        return;
    }
    if (![_lblAddress.text.trim isWalletAddress]) {
        [self endEditing:YES];
        [AppD.window showHint:NSStringLocalizable(@"address_format")];
        return;
    }
    
    if (self.sendBlock) {
        self.sendBlock(SendNowType);
    }
//    NSString *msg = [NSString stringWithFormat:@"Sure you want to send %@ QLC\nto\n%@?",_txtMoney.text,_lblAddress.text];
//    NSMutableAttributedString *msgArrtrbuted = [[NSMutableAttributedString alloc] initWithString:msg];
//    [msgArrtrbuted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:16.0] range:[msg rangeOfString:_txtMoney.text]];
//
//    [self showWalletAlertViewWithTitle:@"CONFIRM WITHDRAWAL" msg:msgArrtrbuted isShowTwoBtn:YES block:^{
//         @weakify_self
//        if (weakSelf.sendBlock) {
//                weakSelf.sendBlock(SendNowType);
//        }
//    }];
}

- (IBAction)clickQlc:(id)sender {
//    _qlcImgView.image = [UIImage imageNamed:@"icon_the_selected"];
//    _neoImgView.image = [UIImage imageNamed:@"icon_the_uncheck"];
//    if (_sendBlock) {
//        _sendBlock(QLCType);
//    }
}
- (IBAction)clickMax:(id)sender {
    if (_sendBlock) {
        _sendBlock(MaxType);
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (_sendBlock) {
        _sendBlock(TxtChangeType);
    }
}

#pragma mark - UITextField delegate
//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
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
    return YES;
}
@end
