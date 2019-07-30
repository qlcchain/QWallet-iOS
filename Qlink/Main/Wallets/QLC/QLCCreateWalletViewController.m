//
//  CreateETHWalletViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/22.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QLCCreateWalletViewController.h"
#import "QLCBackupDetailViewController.h"

@interface QLCCreateWalletViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backupBtn;

@end

@implementation QLCCreateWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self renderView];
}

#pragma mark - Operation
- (void)renderView {
    UIColor *shadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_backupBtn addShadowWithOpacity:1 shadowColor:shadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
    
}

#pragma mark - Action
- (IBAction)backupAction:(id)sender {
    [self jumpToQLCBackupDetail];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Transition
- (void)jumpToQLCBackupDetail {
    QLCBackupDetailViewController *vc = [[QLCBackupDetailViewController alloc] init];
    vc.walletInfo = _walletInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
