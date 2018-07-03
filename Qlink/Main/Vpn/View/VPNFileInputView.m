//
//  VPNFileInputView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/23.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNFileInputView.h"
#import "VPNFileUtil.h"
#import "NSString+RegexCategory.h"


@implementation VPNFileInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype) loadVPNFileInputView
{
    VPNFileInputView *fileNameView = [[[NSBundle mainBundle] loadNibNamed:@"VPNFileInputView" owner:self options:nil] lastObject];
    fileNameView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [fileNameView registerNotification];
    return fileNameView;
}
#pragma mark -注册通知
- (void) registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBordShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBordHidden:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 通知回调
- (void) keyBordShow:(NSNotification *) notification
{
    // 获取字典信息
    NSDictionary *userInfo = [notification userInfo];
    // 获取键盘弹出后的rect
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keybordRect = [aValue CGRectValue];
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animatinDuration;
    [animationDurationValue getValue:&animatinDuration];
    
    CGFloat jump = (keybordRect.size.height + 40) - (SCREEN_HEIGHT/2);
    if (jump > 0) {
        [UIView animateWithDuration:animatinDuration animations:^{
            _contraintCenterX.constant = -jump;
            [self layoutIfNeeded];
        }];
    }
}
- (void) keyBordHidden:(NSNotification *) notification
{
    // 获取字典信息
    NSDictionary *userInfo = [notification userInfo];
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animatinDuration;
    [animationDurationValue getValue:&animatinDuration];
    [UIView animateWithDuration:animatinDuration animations:^{
        _contraintCenterX.constant = 0;
        [self layoutIfNeeded];
    }];
}

- (IBAction)clickCancel:(id)sender {
    [self endEditing:YES];
    [self hidde];
}
- (IBAction)clickOK:(id)sender {
    [self endEditing:YES];
    // 判断文件名是否存在
    if ([_txtFileName.text.trim isEmptyString]) {
        [AppD.window showHint:NSStringLocalizable(@"input_fileName")];
        return;
    }
    if (![_txtFileName.text.trim isVPNFileName]) {
        [AppD.window showHint:NSStringLocalizable(@"characters")];
        return;
    }
    NSString *vpnFileName = [_txtFileName.text.trim stringByAppendingString:@".ovpn"];
    if ([VPNFileUtil vpnNameIsExitWithName:vpnFileName]) {
        [AppD.window showHint:NSStringLocalizable(@"filename_exists")];
        return;
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:self.vpnURL];
            if (data) {
                // 写入沙盒 并且存入keychain
                [VPNFileUtil saveVPNDataToLibrayPath:data withFileName:vpnFileName];
            }
        });
        [self hidde];
    }
}
/**
 显示alertview
 */
- (void) showVPNFileInputView:(UIView *) view
{
    _lineView.textField = _txtFileName;
    _backView.layer.cornerRadius = 5.0f;

    [view addSubview:self];
   // [AppD.window addSubview:self];
    self.alpha = 0.f;
    @weakify_self
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.alpha = 1.0f;
    } completion:^(BOOL finished) {
       // [_txtFileName becomeFirstResponder];
    }];
}
/**
 隐藏alertview
 */
- (void) hidde
{
    @weakify_self
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.alpha = 0.f;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [weakSelf removeFromSuperview];
    }];
    
}

@end
