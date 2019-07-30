//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BackupKeyView.h"
#import "UIView+Visuals.h"
#import "SGQRCodeObtain.h"
#import "UIImage+Capture.h"

@interface BackupKeyView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UIImageView *qrImage;
@property (weak, nonatomic) IBOutlet UIView *textBack;
@property (weak, nonatomic) IBOutlet UITextView *textV;

@property (nonatomic, strong) NSString *privateKey;

@end

@implementation BackupKeyView

+ (instancetype)getInstance {
    BackupKeyView *view = [[[NSBundle mainBundle] loadNibNamed:@"BackupKeyView" owner:self options:nil] lastObject];
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
    
    _qrImage.image = [SGQRCodeObtain generateQRCodeWithData:_privateKey?:@"" size:_qrImage.width logoImage:nil ratio:0.15];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)copyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _privateKey;
    [kAppD.window makeToastDisappearWithText:@"Copied"];
    [self hide];
}

- (IBAction)QRCode:(id)sender {
    if (_qrImage.image == nil) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    UIImage *image = [UIImage captureWithView:_qrImage];
    [pasteboard setImage:image];
    [kAppD.window makeToastDisappearWithText:@"Copied"];
    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}


@end
