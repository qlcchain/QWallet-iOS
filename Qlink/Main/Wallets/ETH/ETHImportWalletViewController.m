//
//  ETHImportWalletViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHImportWalletViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "QlinkTabbarViewController.h"
#import "SuccessTipView.h"
#import <ETHFramework/ETHFramework.h>
#import "LoginPWModel.h"
#import "WalletQRViewController.h"
#import "ETHWalletInfo.h"
#import "ReportUtil.h"
#import <TrustCore/Crypto.h>
#import "NSString+HexStr.h"

typedef enum : NSUInteger {
    ETHImportTypeMnemonic,
    ETHImportTypeKeystore,
    ETHImportTypePrivatekey,
    ETHImportTypeWatch,
} ETHImportType;

@interface ETHImportWalletViewController () {
    BOOL mnemonicAgree;
    BOOL keystoreAgree;
    BOOL privatekeyAgree;
    BOOL watchAgree;
}

@property (nonatomic) ETHImportType importType;

@property (weak, nonatomic) IBOutlet UIButton *mnemonicBtn;
@property (weak, nonatomic) IBOutlet UIButton *officialBtn;
@property (weak, nonatomic) IBOutlet UIButton *privateKeyBtn;
@property (weak, nonatomic) IBOutlet UIButton *watchBtn;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UIView *scrollBack;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScorll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentWidth;

#pragma mark - Mnemonic
@property (weak, nonatomic) IBOutlet UIView *mnemonicTVBack;
@property (weak, nonatomic) IBOutlet UITextView *mnemonicTV;
@property (weak, nonatomic) IBOutlet UIButton *mnemonicStartImportBtn;

#pragma mark - Official
@property (weak, nonatomic) IBOutlet UIView *officialTVBack;
@property (weak, nonatomic) IBOutlet UITextView *officialTV;
@property (weak, nonatomic) IBOutlet UIButton *officialStartImportBtn;
@property (weak, nonatomic) IBOutlet UITextField *officialPWTF;

#pragma mark - PrivateKey
@property (weak, nonatomic) IBOutlet UIView *privateTVBack;
@property (weak, nonatomic) IBOutlet UITextView *privateTV;
@property (weak, nonatomic) IBOutlet UIButton *privateStartImportBtn;

#pragma mark - Watch
@property (weak, nonatomic) IBOutlet UIView *watchTVBack;
@property (weak, nonatomic) IBOutlet UITextView *watchTV;
@property (weak, nonatomic) IBOutlet UIButton *watchStartImportBtn;

@end

@implementation ETHImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
    [self renderMnemonicView];
    [self renderOfficialView];
    [self renderPrivatekeyView];
    [self renderWatchView];
}

#pragma mark - Operation
- (void)renderView {
    [_scrollBack addSubview:_mainScorll];
    kWeakSelf(self);
    [_mainScorll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.scrollBack).offset(0);
    }];
    _scrollContentWidth.constant = SCREEN_WIDTH*4;
}

- (void)configInit {
//    _importType = ETHImportTypeMnemonic;
    [self refreshSelectImport:_mnemonicBtn];
}

- (void)renderMnemonicView {
    [_mnemonicTVBack cornerRadius:6 strokeSize:1 color:UIColorFromRGB(0xECEFF1)];
    _mnemonicTV.placeholder = @"Please use space to separate the mnemonic words";
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_mnemonicStartImportBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
}

- (void)renderOfficialView {
    [_officialTVBack cornerRadius:6 strokeSize:1 color:UIColorFromRGB(0xECEFF1)];
    _officialTV.placeholder = @"Keystore content";
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_officialStartImportBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
}

- (void)renderPrivatekeyView {
    [_privateTVBack cornerRadius:6 strokeSize:1 color:UIColorFromRGB(0xECEFF1)];
    _privateTV.placeholder = @"Please input your private key";
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_privateStartImportBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
}

- (void)renderWatchView {
    [_watchTVBack cornerRadius:6 strokeSize:1 color:UIColorFromRGB(0xECEFF1)];
    _watchTV.placeholder = @"Wallet Address";
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_watchStartImportBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
}

- (void)refreshSelectImport:(UIButton *)sender {
    if (sender == _mnemonicBtn) {
        _importType = ETHImportTypeMnemonic;
    } else if (sender == _officialBtn) {
        _importType = ETHImportTypeKeystore;
    } else if (sender == _privateKeyBtn) {
        _importType = ETHImportTypePrivatekey;
    } else if (sender == _watchBtn) {
        _importType = ETHImportTypeWatch;
    }
    _mnemonicBtn.selected = sender==_mnemonicBtn?YES:NO;
    _officialBtn.selected = sender==_officialBtn?YES:NO;
    _privateKeyBtn.selected = sender==_privateKeyBtn?YES:NO;
    _watchBtn.selected = sender==_watchBtn?YES:NO;
    kWeakSelf(self);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.sliderView.frame = CGRectMake(0, sender.height, sender.width+10, 2);
        weakself.sliderView.center = CGPointMake(sender.center.x, sender.height+1);
    } completion:^(BOOL finished) {
    }];
}

- (void)showImportSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:@"Import Success"];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)scanAction:(id)sender {
    kWeakSelf(self);
    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
        if (weakself.importType == ETHImportTypeMnemonic) {
            weakself.mnemonicTV.text = codeValue;
        } else if (weakself.importType == ETHImportTypeKeystore) {
            weakself.officialTV.text = codeValue;
        } else if (weakself.importType == ETHImportTypePrivatekey) {
            weakself.privateTV.text = codeValue;
        } else if (weakself.importType == ETHImportTypeWatch) {
            weakself.watchTV.text = codeValue;
        }
    } needPop:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)mnemonicAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    mnemonicAgree = sender.selected;
}

- (IBAction)keystoreAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    keystoreAgree = sender.selected;
}

- (IBAction)privatekeyAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    privatekeyAgree = sender.selected;
}

- (IBAction)watchAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    watchAgree = sender.selected;
}

- (IBAction)mnemonicAction:(UIButton *)sender {
    [self refreshSelectImport:sender];
    [_mainScorll setContentOffset:CGPointMake(SCREEN_WIDTH*0, 0) animated:YES];
}

- (IBAction)officialAction:(UIButton *)sender {
    [self refreshSelectImport:sender];
    [_mainScorll setContentOffset:CGPointMake(SCREEN_WIDTH*1, 0) animated:YES];
}

- (IBAction)privatekeyAction:(UIButton *)sender {
    [self refreshSelectImport:sender];
    [_mainScorll setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
}

- (IBAction)watchAction:(UIButton *)sender {
    [self refreshSelectImport:sender];
    [_mainScorll setContentOffset:CGPointMake(SCREEN_WIDTH*3, 0) animated:YES];
}

- (IBAction)selectPathAction:(id)sender {
//    kWeakSelf(self);
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Select Path" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [@[@"dsfdf",@"sagsg",@"aljlsf"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *alert = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)mnemonicImportAction:(id)sender {
    if (!mnemonicAgree) {
        [kAppD.window makeToastDisappearWithText:@"Please Agree First"];
        return;
    }
    if (_mnemonicTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Please Input First"];
        return;
    }
    
    kWeakSelf(self);
//    NSString *pw = [LoginPWModel getLoginPW];
    NSString *pw = @"";
    NSString *mnemonic = _mnemonicTV.text;
    [kAppD.window makeToastInView:kAppD.window];
    [TrustWalletManage.sharedInstance importWalletWithKeystoreInput:nil privateKeyInput:nil addressInput:nil mnemonicInput:mnemonic password:pw :^(BOOL success, NSString *address) {
        [kAppD.window hideToast];
        if (success) {
            [TrustWalletManage.sharedInstance exportPrivateKeyWithAddress:address?:@"" :^(NSString * privateKey) {
                
                ETHWalletInfo *walletInfo = [[ETHWalletInfo alloc] init];
                walletInfo.privatekey = privateKey;
                walletInfo.mnemonic = mnemonic;
                walletInfo.keystore = @"";
                walletInfo.password = pw;
                walletInfo.address = address;
                walletInfo.type = @"1"; // mnemonic
                // 存储keychain
                [walletInfo saveToKeyChain];
                
                [TrustWalletManage.sharedInstance exportPublicKeyWithAddress:walletInfo.address :^(NSString * _Nullable publicKey) {
                    [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"ETH" address:walletInfo.address pubKey:publicKey?:@"" privateKey:walletInfo.privatekey]; // 上报钱包创建
                }];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Add_ETH_Wallet_Noti object:nil];
                [weakself showImportSuccessView];
    //            [weakself performSelector:@selector(jumpToTabbar) withObject:nil afterDelay:2];
                [weakself performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
            }];
        }
    }];
}

- (IBAction)officialImportAction:(id)sender {
    if (!keystoreAgree) {
        [kAppD.window makeToastDisappearWithText:@"Please Agree First"];
        return;
    }
    if (_officialTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Please Input First"];
        return;
    }
    
    kWeakSelf(self);
//    NSString *pw = [LoginPWModel getLoginPW];
    NSString *pw = _officialPWTF.text?:@"";
    NSString *keystore = _officialTV.text;
    [kAppD.window makeToastInView:kAppD.window];
    [TrustWalletManage.sharedInstance importWalletWithKeystoreInput:keystore privateKeyInput:nil addressInput:nil mnemonicInput:nil password:pw :^(BOOL success, NSString *address) {
        [kAppD.window hideToast];
        if (success) {
            [TrustWalletManage.sharedInstance exportPrivateKeyWithAddress:address?:@"" :^(NSString * privateKey) {
                
                ETHWalletInfo *walletInfo = [[ETHWalletInfo alloc] init];
                walletInfo.privatekey = privateKey;
                walletInfo.mnemonic = @"";
                walletInfo.keystore = keystore;
                walletInfo.password = pw;
                walletInfo.address = address;
                walletInfo.type = @"2"; // keystore
                // 存储keychain
                [walletInfo saveToKeyChain];
            
                [TrustWalletManage.sharedInstance exportPublicKeyWithAddress:walletInfo.address :^(NSString * _Nullable publicKey) {
                    [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"ETH" address:walletInfo.address pubKey:publicKey?:@"" privateKey:walletInfo.privatekey]; // 上报钱包创建
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:Add_ETH_Wallet_Noti object:nil];
                [weakself showImportSuccessView];
                [weakself performSelector:@selector(jumpToTabbar) withObject:nil afterDelay:2];
            }];
        }
    }];
}

- (IBAction)privatekeyImportAction:(id)sender {
    if (!privatekeyAgree) {
        [kAppD.window makeToastDisappearWithText:@"Please Agree First"];
        return;
    }
    if (_privateTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Please Input First"];
        return;
    }
    
    kWeakSelf(self);
    NSString *privatekey =_privateTV.text;
    [kAppD.window makeToastInView:kAppD.window];
    [TrustWalletManage.sharedInstance importWalletWithKeystoreInput:nil privateKeyInput:privatekey addressInput:nil mnemonicInput:nil password:nil :^(BOOL success, NSString *address) {
        [kAppD.window hideToast];
        if (success) {
            ETHWalletInfo *walletInfo = [[ETHWalletInfo alloc] init];
            walletInfo.privatekey = privatekey;
            walletInfo.mnemonic = @"";
            walletInfo.keystore = @"";
            walletInfo.password = @"";
            walletInfo.address = address;
            walletInfo.type = @"3"; // private
            // 存储keychain
            [walletInfo saveToKeyChain];
            
            [TrustWalletManage.sharedInstance exportPublicKeyWithAddress:walletInfo.address :^(NSString * _Nullable publicKey) {
                [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"ETH" address:walletInfo.address pubKey:publicKey?:@"" privateKey:walletInfo.privatekey]; // 上报钱包创建
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:Add_ETH_Wallet_Noti object:nil];
            [weakself showImportSuccessView];
            [weakself performSelector:@selector(jumpToTabbar) withObject:nil afterDelay:2];
        } else {
            [kAppD.window makeToastDisappearWithText:@"Import fail"];
        }
    }];
}

- (IBAction)watchImportAction:(id)sender {
    if (!watchAgree) {
        [kAppD.window makeToastDisappearWithText:@"Please Agree First"];
        return;
    }
    if (_watchTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Please Input First"];
        return;
    }
    
    // 检查地址有效性
    BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:_watchTV.text];
    if (!isValid) {
        [kAppD.window makeToastDisappearWithText:@"Address is invalidate"];
        return;
    }
    
    kWeakSelf(self);
    NSString *address = _watchTV.text;
    [kAppD.window makeToastInView:kAppD.window];
    [TrustWalletManage.sharedInstance importWalletWithKeystoreInput:nil privateKeyInput:nil addressInput:address mnemonicInput:nil password:nil :^(BOOL success, NSString *address) {
        [kAppD.window hideToast];
        if (success) {
            ETHWalletInfo *walletInfo = [[ETHWalletInfo alloc] init];
            walletInfo.privatekey = @"";
            walletInfo.mnemonic = @"";
            walletInfo.keystore = @"";
            walletInfo.password = @"";
            walletInfo.address = address;
            walletInfo.type = @"4"; // address
            // 存储keychain
            [walletInfo saveToKeyChain];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Add_ETH_Wallet_Noti object:nil];
            [weakself showImportSuccessView];
            [weakself performSelector:@selector(jumpToTabbar) withObject:nil afterDelay:2];
        }
    }];
}

#pragma mark - Transition
- (void)jumpToTabbar {
    [kAppD setRootTabbar];
    kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
}

@end
