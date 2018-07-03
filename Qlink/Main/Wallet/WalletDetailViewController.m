//
//  WalletDetailViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletDetailViewController.h"
#import "UILabel+Copy.h"
#import "NewWalletViewController.h"
#import "WalletChangeWalletViewController.h"
#import "WalletPublicAddressViewController.h"
#import <Hero/Hero-Swift.h>
#import "HMScanner.h"

@interface WalletDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPublicKey;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblPrivateKey;
@property (weak, nonatomic) IBOutlet UIButton *copeBtn;

@end

@implementation WalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify_self
    [HMScanner qrImageWithString:[CurrentWalletInfo getShareInstance].address avatar:nil completion:^(UIImage *image) {
        [weakSelf.codeBtn setBackgroundImage:image forState:UIControlStateNormal];
    }];
    
    _codeBtn.heroID = @"scancode";
    self.isHeroEnabled = YES;
    self.navigationController.isHeroEnabled = YES;
    // 注册钱包发生变化时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(walletDidChange:) name:WALLET_CHANGE_TZ object:nil];
    [self setLabelValue];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
   self.navigationController.isHeroEnabled = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self addNewGuide];
}

#pragma mark - Config View
//- (void)addNewGuide {
////    [HWUserdefault insertObj:@(NO) withkey:NEW_GUIDE_BACKUP_KEY];
//    NSNumber *guideLocal = [HWUserdefault getObjectWithKey:NEW_GUIDE_BACKUP_KEY];
//    if (!guideLocal || [guideLocal boolValue] == NO) {
//        UIView *guideBV = [NewGuideUtil showNewGuideWithKey:NEW_GUIDE_BACKUP_KEY TapBlock:nil];
//        UIImage *guideImg = [UIImage imageNamed:@"img_floating_layer_wallet_detail"];
//        UIImageView *guideImgV = [[UIImageView alloc] init];
//        guideImgV.frame = CGRectZero;
//        if (IS_iPhone_5) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 150, guideImg.size.width, guideImg.size.height);
//        } else if (IS_iPhone_6) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 150, guideImg.size.width, guideImg.size.height);
//        } else if (IS_iPhone6_Plus) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 150, guideImg.size.width, guideImg.size.height);
//        } else if (IS_iPhoneX) {
//            guideImgV.frame = CGRectMake((SCREEN_WIDTH-guideImg.size.width)/2.0, 180, guideImg.size.width, guideImg.size.height);
//        }
//        
//        guideImgV.image = guideImg;
//        [guideBV addSubview:guideImgV];
//    }
//}

- (IBAction)clickWIF:(id)sender {
    
    [self showAlertViewCodeType:WifStyle];
    
}
- (IBAction)clickPrivateKey:(id)sender {
    
    [self showAlertViewCodeType:PrivateKeyStyle];
}

- (IBAction)clickBack:(id)sender {
    self.navigationController.isHeroEnabled = NO;
    [self leftNavBarItemPressedWithPop:YES];
}
- (IBAction)clickCopyAdress:(id)sender {
    
    //  通用的粘贴板
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    if (_lblAddress.text) {
        pBoard.string = _lblAddress.text;
        [AppD.window showHint:NSStringLocalizable(@"copy_successs")];
    }
}
- (IBAction)clickCode:(id)sender {
    
    [self jumpToWalletPublic];
}

- (void)jumpToWalletPublic {
    [self showAlertViewCodeType:AddressStyle];
}

- (void) showAlertViewCodeType:(EnterCodeType) codeType
{
    if (codeType == AddressStyle) {
        WalletPublicAddressViewController *vc = [[WalletPublicAddressViewController alloc] initWithCodeType:codeType];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSString *attstr = NSStringLocalizable(@"surroundings");
    NSString *msg = NSStringLocalizable(@"always_keep");
    
    NSMutableAttributedString *msgArrtrbuted = [[NSMutableAttributedString alloc] initWithString:msg];
    NSRange range = [msg rangeOfString:attstr];
    if (range.location != NSNotFound) {
        [msgArrtrbuted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:15.0] range:[msg rangeOfString:attstr]];
        [msgArrtrbuted addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[msg rangeOfString:attstr]];
    }
    
    @weakify_self
    [self.view showWalletAlertViewWithTitle:NSStringLocalizable(@"security_check") msg:msgArrtrbuted isShowTwoBtn:YES block:^{
        WalletPublicAddressViewController *vc = [[WalletPublicAddressViewController alloc] initWithCodeType:codeType];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (IBAction)clickExport:(id)sender {
    
    //NewWalletViewController *vc = [[NewWalletViewController alloc] initWithJump:WalletJump];
    //[self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickChange:(id)sender {
    WalletChangeWalletViewController *vc = [[WalletChangeWalletViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 钱包更改时通知

 @param notification 通知中心
 */
- (void) walletDidChange:(NSNotificationCenter *) notification
{
    [self setLabelValue];
}

/**
 初始化key
 */
- (void) setLabelValue
{
    CurrentWalletInfo *walletInfo = [CurrentWalletInfo getShareInstance];
    _lblAddress.text = walletInfo.address;
    _lblAddress.isCopyable = YES;
    _lblPublicKey.text = walletInfo.wif;
    _lblPublicKey.isCopyable = YES;
    _lblPrivateKey.text = walletInfo.privateKey;
    _lblPrivateKey.isCopyable = YES;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
