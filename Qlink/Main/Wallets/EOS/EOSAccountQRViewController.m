//
//  ETHWalletAddressViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSAccountQRViewController.h"
#import "WalletCommonModel.h"
#import "UIView+DottedBox.h"
#import "SGQRCodeObtain.h"
//#import "GlobalConstants.h"

@interface EOSAccountQRViewController ()

@property (weak, nonatomic) IBOutlet UIView *qrcodeBack;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImgV;
@property (weak, nonatomic) IBOutlet UIView *boxView;

@end

@implementation EOSAccountQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    [self renderView];
    [self configInit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_boxView addDottedBox:UIColorFromRGB(0xC0C0C0) fillColor:[UIColor clearColor] cornerRadius:6 lineWidth:1];
}

#pragma mark - Operation
- (void)renderView {
    UIColor *shadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_qrcodeBack shadowWithColor:shadowColor offset:CGSizeMake(0, 2) opacity:1 radius:4];
    
}

- (void)configInit {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    _addressLab.text = currentWalletM.account_name?:@"";
    
    UIImage *img = [UIImage imageNamed:@"qrcode_eos"];
    _qrcodeImgV.image = [SGQRCodeObtain generateQRCodeWithData:currentWalletM.address?:@"" size:_qrcodeImgV.width logoImage:img ratio:0.2 logoImageCornerRadius:0 logoImageBorderWidth:0 logoImageBorderColor:[UIColor clearColor]];
}

#pragma mark -Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(id)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[_qrcodeImgV.image] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        if (completed) {
            NSLog(@"Share Success");
        } else {
            NSLog(@"Share Failed == %@",activityError.description);
        }
    };
}

- (IBAction)copyAction:(id)sender {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = currentWalletM.account_name;
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

@end
