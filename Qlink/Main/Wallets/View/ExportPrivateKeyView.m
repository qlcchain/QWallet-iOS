//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ExportPrivateKeyView.h"
#import "UIView+Visuals.h"
#import "ExportPrivateKeyQRView.h"
#import "GlobalConstants.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface ExportPrivateKeyView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UIView *textBack;
@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (nonatomic, strong) NSString *privateKey;

@end

@implementation ExportPrivateKeyView

+ (instancetype)getInstance {
    ExportPrivateKeyView *view = [[[NSBundle mainBundle] loadNibNamed:@"ExportPrivateKeyView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    UIColor *borderColor = UIColorFromRGB(0xE8EAEC);
    [view.textBack cornerRadius:6 strokeSize:1 color:borderColor];
    return view;
}

- (void)showWithPrivateKey:(NSString *)privateKey title:(NSString *)title {
    _titleLab.text = title;
    _privateKey = privateKey;
    _textV.text = _privateKey;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    [self.tipBack showPopAnimate];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)copyAction:(id)sender {
//    if (_copyBlock) {
//        _copyBlock();
//    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _privateKey;
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
    [self hide];
}

- (IBAction)qrcodeAction:(id)sender {
    ExportPrivateKeyQRView *view = [ExportPrivateKeyQRView getInstance];
    [view showWithPrivateKey:_privateKey title:kLang(@"export_qrcode")];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}


@end

