//
//  WalletCreateSuccessViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletCreateSuccessViewController.h"
#import "WalletUtil.h"
//#import "AppDelegate.h"
#import "QlinkTabbarViewController.h"
#import "UILabel+Copy.h"
#import "Qlink-Swift.h"
#import "TransferUtil.h"

@interface WalletCreateSuccessViewController ()
{
    BOOL isFirstWallet;
}
@property (nonatomic ,strong) WalletInfo *walletInfo;

@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPublicKey;
@property (weak, nonatomic) IBOutlet UILabel *lblPrivateKey;
@property (weak, nonatomic) IBOutlet UILabel *lblSave;

@end

@implementation WalletCreateSuccessViewController

- (IBAction)clickExport:(id)sender {
    self.lblSave.hidden = NO;
    [AppD.window showHint:NSStringLocalizable(@"private_key")];
}

- (IBAction)clickContinue:(id)sender {
    
    if ([WalletUtil shareInstance].isLock) { // 是否是第一次启动
        [WalletUtil manageCancelWork];
        [self leftNavBarItemPressedWithPop:YES];
    } else {
        if (![WalletUtil isExistWalletPrivateKey]) {
            [self leftNavBarItemPressedWithPop:YES];
            [WalletUtil manageContiueWork];
        } else {
            [self leftNavBarItemPressedWithPop:YES];
        }
    }
}

- (instancetype) initWtihWalletInfo:(WalletInfo *) walletInfo
{
    if (self = [super init]) {
        // 给属性赋值
        self.walletInfo = walletInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initPropertVlaueWithWalletInfo:self.walletInfo];
    
    // 存储keychain
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([self saveKeyChainWithWalletInfo:self.walletInfo]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:WALLET_ADD_TZ object:nil];
            });
        }
    });
}

- (void) initPropertVlaueWithWalletInfo:(WalletInfo *) walletInfo
{
    _lblAddress.text = walletInfo.address;
    _lblAddress.isCopyable = YES;
    _lblPublicKey.text = walletInfo.wif;
    _lblPublicKey.isCopyable = YES;
    _lblPrivateKey.text = walletInfo.privateKey;
    _lblPrivateKey.isCopyable = YES;
    _lblSave.layer.cornerRadius = 6.0f;
    _lblSave.layer.masksToBounds = YES;
    _lblSave.hidden = YES;
}

/**
 将私钥和公钥还有地址 存储keychain
 @return yes
 */
- (BOOL) saveKeyChainWithWalletInfo:(WalletInfo *) walletInfo
{
    // 判断是否是第一个钱包。第一个则默认为当前钱包
    if (![WalletUtil isExistWalletPrivateKey]) {
        [WalletUtil setKeyValue:CURRENT_WALLET_KEY value:@"0"];
        isFirstWallet = YES;
    }
    
    // 已经存在返回NO
    BOOL isExist= [WalletUtil setWalletkeyWithKey:WALLET_PRIVATE_KEY withWalletValue:walletInfo.privateKey];
    if (!isExist) {
        return YES;
    }
    [WalletUtil setWalletkeyWithKey:WALLET_PUBLIC_KEY withWalletValue:walletInfo.publicKey];
    [WalletUtil setWalletkeyWithKey:WALLET_ADDRESS_KEY withWalletValue:walletInfo.address];
    [WalletUtil setWalletkeyWithKey:WALLET_WIF_KEY withWalletValue:walletInfo.wif];
    
    // 重新初始化 Account->将Account设为当前钱包
    [WalletManage.shareInstance3 configureAccountWithMainNet:[WalletUtil checkServerIsMian]];
    // 是第一个钱包 
    if (isFirstWallet) {
        [WalletUtil getCurrentWalletInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:WALLET_CHANGE_TZ object:nil];
        // 查询当前钱包资产
        [TransferUtil sendGetBalanceRequest];
    }
    
    return YES;
    
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
