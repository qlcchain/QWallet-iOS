//
//  ETHImportWalletViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QLCImportWalletViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "QlinkTabbarViewController.h"
#import "SuccessTipView.h"
#import "WalletQRViewController.h"
#import "ReportUtil.h"
#import "QLCWalletInfo.h"
#import <QLCFramework/QLCFramework.h>
#import "WebViewController.h"
//#import "GlobalConstants.h"

typedef enum : NSUInteger {
    QLCImportTypeMnemonic,
    QLCImportTypeSeed,
} QLCImportType;

@interface QLCImportWalletViewController () {
    BOOL mnemonicAgree;
    BOOL seedAgree;
}

@property (nonatomic) QLCImportType importType;

@property (weak, nonatomic) IBOutlet UIButton *mnemonicBtn;
@property (weak, nonatomic) IBOutlet UIButton *seedBtn;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UIView *scrollBack;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScorll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentWidth;

#pragma mark - Mnemonic
@property (weak, nonatomic) IBOutlet UIView *mnemonicTVBack;
@property (weak, nonatomic) IBOutlet UITextView *mnemonicTV;
@property (weak, nonatomic) IBOutlet UIButton *mnemonicStartImportBtn;

#pragma mark - PrivateKey
@property (weak, nonatomic) IBOutlet UIView *seedTVBack;
@property (weak, nonatomic) IBOutlet UITextView *seedTV;
@property (weak, nonatomic) IBOutlet UIButton *seedStartImportBtn;

@end

@implementation QLCImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
    [self renderMnemonicView];
    [self renderPrivatekeyView];
}

#pragma mark - Operation
- (void)renderView {
    [_scrollBack addSubview:_mainScorll];
    kWeakSelf(self);
    [_mainScorll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.scrollBack).offset(0);
    }];
    _scrollContentWidth.constant = SCREEN_WIDTH*2;
}

- (void)configInit {
//    _importType = ETHImportTypeMnemonic;
    [self refreshSelectImport:_mnemonicBtn];
}

- (void)renderMnemonicView {
    [_mnemonicTVBack cornerRadius:6 strokeSize:1 color:UIColorFromRGB(0xECEFF1)];
    _mnemonicTV.placeholder = kLang(@"please_use_space_to_separate_the_mnemonic_phrase");
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_mnemonicStartImportBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
}

- (void)renderPrivatekeyView {
    [_seedTVBack cornerRadius:6 strokeSize:1 color:UIColorFromRGB(0xECEFF1)];
    _seedTV.placeholder = kLang(@"please_input_wallet_seed");
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_seedStartImportBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
}

- (void)refreshSelectImport:(UIButton *)sender {
    if (sender == _mnemonicBtn) {
        _importType = QLCImportTypeMnemonic;
    } else if (sender == _seedBtn) {
        _importType = QLCImportTypeSeed;
    }
    _mnemonicBtn.selected = sender==_mnemonicBtn?YES:NO;
    _seedBtn.selected = sender==_seedBtn?YES:NO;
    kWeakSelf(self);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.sliderView.frame = CGRectMake(sender==_mnemonicBtn?(SCREEN_WIDTH/2.0-10-sender.width):(SCREEN_WIDTH/2.0+10), sender.height, sender.width, 2);
//        weakself.sliderView.center = CGPointMake(sender.center.x, sender.height+1);
    } completion:^(BOOL finished) {
    }];
}

- (void)showImportSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:kLang(@"import_success")];
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
        if (weakself.importType == QLCImportTypeMnemonic) {
            weakself.mnemonicTV.text = codeValue;
        } else if (weakself.importType == QLCImportTypeSeed) {
            weakself.seedTV.text = codeValue;
        }
    } needPop:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)mnemonicAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    mnemonicAgree = sender.selected;
}

- (IBAction)privatekeyAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    seedAgree = sender.selected;
}

- (IBAction)mnemonicAction:(UIButton *)sender {
    [self refreshSelectImport:sender];
    [_mainScorll setContentOffset:CGPointMake(SCREEN_WIDTH*0, 0) animated:YES];
}

- (IBAction)seedAction:(UIButton *)sender {
    [self refreshSelectImport:sender];
    [_mainScorll setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}

- (IBAction)mnemonicImportAction:(id)sender {
    if (!mnemonicAgree) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_agree_first")];
        return;
    }
    if (_mnemonicTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_input_first")];
        return;
    }
    if (![[QLCWalletManage shareInstance] walletMnemonicIsValid:_mnemonicTV.text]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_input_valid_mnemonic")];
        return;
    }
    
//    NSString *pw = @"";
    NSString *mnemonic = _mnemonicTV.text;
    [kAppD.window makeToastInView:kAppD.window];
    BOOL isSuccess = [QLCWalletManage.shareInstance importWalletWithMnemonic:mnemonic];
    [kAppD.window hideToast];
    if (isSuccess) {
        QLCWalletInfo *walletInfo = [[QLCWalletInfo alloc] init];
        walletInfo.address = [QLCWalletManage.shareInstance walletAddress];
        walletInfo.seed = [QLCWalletManage.shareInstance walletSeed];
        walletInfo.privateKey = [QLCWalletManage.shareInstance walletPrivateKeyStr];
        walletInfo.publicKey = [QLCWalletManage.shareInstance walletPublicKeyStr];
        // 存储keychain
        [walletInfo saveToKeyChain];
        
        [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"QLC" address:walletInfo.address pubKey:walletInfo.publicKey privateKey:walletInfo.privateKey]; // 上报钱包创建
        [[NSNotificationCenter defaultCenter] postNotificationName:Add_QLC_Wallet_Noti object:nil];
        [self showImportSuccessView];
        [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
    }
}

- (IBAction)seedImportAction:(id)sender {
    if (!seedAgree) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_agree_first")];
        return;
    }
    if (_seedTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_input_first")];
        return;
    }
    if (![[QLCWalletManage shareInstance] walletSeedIsValid:_seedTV.text]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_input_valid_seed")];
        return;
    }
    
    NSString *seed = _seedTV.text.trim;
    [kAppD.window makeToastInView:kAppD.window];
    BOOL isSuccess = [QLCWalletManage.shareInstance importWalletWithSeed:seed];
    [kAppD.window hideToast];
    if (isSuccess) {
        QLCWalletInfo *walletInfo = [[QLCWalletInfo alloc] init];
        walletInfo.address = [QLCWalletManage.shareInstance walletAddress];
        walletInfo.seed = [QLCWalletManage.shareInstance walletSeed];
        walletInfo.privateKey = [QLCWalletManage.shareInstance walletPrivateKeyStr];
        walletInfo.publicKey = [QLCWalletManage.shareInstance walletPublicKeyStr];
        // 存储keychain
        [walletInfo saveToKeyChain];
        
        [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"QLC" address:walletInfo.address pubKey:walletInfo.publicKey privateKey:walletInfo.privateKey]; // 上报钱包创建
        [[NSNotificationCenter defaultCenter] postNotificationName:Add_QLC_Wallet_Noti object:nil];
        [self showImportSuccessView];
        [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
    }
}

- (IBAction)termsMnemonicAction:(id)sender {
    [self jumpToTerms];
}

- (IBAction)termsSeedAction:(id)sender {
    [self jumpToTerms];
}

#pragma mark - Transition
- (void)jumpToTabbar {
    [kAppD setRootTabbar];
    kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
}

- (void)jumpToTerms {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = TermsOfServiceAndPrivatePolicy_Url;
    vc.inputTitle = TermsOfTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
