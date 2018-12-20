//
//  EOSRegisterAccountViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/5.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSRegisterAccountViewController.h"
#import "EOSWalletUtil.h"
#import <eosFramework/RegularExpression.h>
#import <eosFramework/EosPrivateKey.h>
#import "Qlink-Swift.h"
#import "HMScanner.h"
#import "NSString+RemoveZero.h"
#import "ETHTransferConfirmView.h"
#import "WalletCommonModel.h"
#import <ETHFramework/ETHFramework.h>
#import "ReportUtil.h"
#import "TipOKView.h"
#import "EOSWalletInfo.h"
#import "EOSAccountInfoModel.h"

@implementation EOSCreateSourceModel

@end

@interface EOSRegisterAccountViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountNameTF;
@property (weak, nonatomic) IBOutlet UITextView *ownerKeyTV;
@property (weak, nonatomic) IBOutlet UITextView *activeKeyTV;
@property (weak, nonatomic) IBOutlet UIImageView *qrImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qrBackHeight; // 190  47
@property (weak, nonatomic) IBOutlet UIButton *switchQRCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic, strong) EOSCreateSourceModel *eosCreateSourceM;
@property (nonatomic, strong) NSString *toEthAddress;
@property (nonatomic, strong) NSNumber *ethAmount;
@property (nonatomic) BOOL isValidName;

@end

@implementation EOSRegisterAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    [_registerBtn cornerRadius:4];
}

- (void)configInit {
    [self switchQRCodeAction:_switchQRCodeBtn];
    
    NSString *eosSourceStr = [KeychainUtil getKeyValueWithKeyName:EOS_CreateSource_InKeychain];
    if (eosSourceStr != nil && eosSourceStr.length > 0) {
        NSDictionary *eosSourceDic = [eosSourceStr mj_JSONObject];
        _eosCreateSourceM = [EOSCreateSourceModel getObjectWithKeyValues:eosSourceDic];
    } else {
        EosPrivateKey *eosPrivateKey = [[EosPrivateKey alloc] initEosPrivateKey];
        _eosCreateSourceM = [EOSCreateSourceModel new];
        _eosCreateSourceM.ownerPrivateKey = eosPrivateKey.eosPrivateKey;
        _eosCreateSourceM.ownerPublicKey = eosPrivateKey.eosPublicKey;
        _eosCreateSourceM.activePrivateKey = eosPrivateKey.eosPrivateKey;
        _eosCreateSourceM.activePublicKey = eosPrivateKey.eosPublicKey;
    }
    _ownerKeyTV.text = _eosCreateSourceM.ownerPublicKey;
    _activeKeyTV.text = _eosCreateSourceM.ownerPublicKey;
    _accountNameTF.text = _eosCreateSourceM.accountName;
    
    _accountNameTF.delegate = self;
    [_accountNameTF addTarget:self action:@selector(checkAccountName:) forControlEvents:UIControlEventEditingChanged];
    
    if (_accountNameTF.text.length > 0) {
        [self checkAccountName:_accountNameTF];
    }
}

- (void)showETHTransferConfirmView {
    NSString *decimals = ETH_Decimals;
    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
    NSInteger gasLimit = 60000;
    NSInteger gasPrice = 6;
    NSNumber *ethFloatNum = @(gasPrice*gasLimit*[decimalsNum doubleValue]);
    
    __block WalletCommonModel *transferETHM = nil;
    // 判断是否有eth钱包
    if ([TrustWalletManage.sharedInstance isHavaWallet]) {
        // 判断是否有足够余额的eth钱包
        NSNumber *enoughBalanceNum = @([ethFloatNum doubleValue]+[_ethAmount doubleValue]);
        [[WalletCommonModel getAllWalletModel] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WalletCommonModel *model = obj;
            if (model.walletType==WalletTypeETH) {
                if ([model.balance doubleValue] >= [enoughBalanceNum doubleValue]) {
                    transferETHM = model;
                    *stop = YES;
                }
            }
        }];
        
        if (transferETHM == nil) {
            [kAppD.window makeToastDisappearWithText:@"No ETH Wallet Of Enough Balance"];
            return;
        }
    } else {
        [kAppD.window makeToastDisappearWithText:@"No ETH Wallet"];
        return;
    }
    
//    NSString *gasCostETH = [[NSString stringWithFormat:@"%Lf",ethFloat] removeFloatAllZero];
    NSString *gasCostETH = [[NSString stringWithFormat:@"%@",ethFloatNum] removeFloatAllZero];
    NSString *fromAddress = transferETHM.address;
    NSString *name = transferETHM.name;
    NSString *toAddress = _toEthAddress;
    NSString *amount = [NSString stringWithFormat:@"%@ ETH",_ethAmount];
    NSString *gasfee = [NSString stringWithFormat:@"%@ ETH",gasCostETH];
    ETHTransferConfirmView *view = [ETHTransferConfirmView getInstance];
    [view configWithName:name sendFrom:fromAddress sendTo:toAddress amount:amount gasfee:gasfee];
    kWeakSelf(self);
    view.confirmBlock = ^{
        [weakself sendTransferWithFromAddress:fromAddress contractAddress:fromAddress toAddress:_toEthAddress amount:[NSString stringWithFormat:@"%@",_ethAmount] gasLimit:gasLimit gasPrice:gasPrice];
    };
    [view show];
}

- (void)sendTransferWithFromAddress:(NSString *)fromAddress contractAddress:(NSString *)contractAddress toAddress:(NSString *)toAddress amount:(NSString *)amount gasLimit:(NSInteger)gasLimit gasPrice:(NSInteger)gasPrice {
    NSString *name = @"ETH";
    NSString *symbol = @"ETH";
    NSInteger decimals = 0;
    NSString *value = @"";
    BOOL isCoin = YES;
    kWeakSelf(self);
    [TrustWalletManage.sharedInstance sendFromAddress:fromAddress contractAddress:contractAddress toAddress:toAddress name:name symbol:symbol amount:amount gasLimit:gasLimit gasPrice:gasPrice decimals:decimals value:value isCoin:isCoin :^(BOOL success, NSString *txId) {
        if (success) {
            [kAppD.window makeToastDisappearWithText:@"Send Success"];
            NSString *blockChain = @"ETH";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
                [ReportUtil requestWalletReportWalletRransferWithAddressFrom:fromAddress addressTo:toAddress blockChain:blockChain symbol:symbol amount:amount txid:txId?:@""]; // 上报钱包转账
            });
            
            [weakself requestEosNew_account:txId?:@""]; // 后台创建eos账号
            
        } else {
            [kAppD.window makeToastDisappearWithText:@"Send Fail"];
        }
    }];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showTipOKView:(NSString *)title {
    TipOKView *view = [TipOKView getInstance];
    view.okBlock = ^{
    };
    [view showWithTitle:title];
}

- (void)checkAccountName:(UITextField *)tf {
    if (tf == _accountNameTF) {
        _isValidName = NO;
        if (_accountNameTF.text.length == 12) {
            kWeakSelf(self);
            NSDictionary *params = @{@"account":_accountNameTF.text?:@""};
            [RequestService requestWithUrl:eosGet_account_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
                if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
                    NSDictionary *dic = responseObject[Server_Data][Server_Data];
                    EOSAccountInfoModel *model = [EOSAccountInfoModel getObjectWithKeyValues:dic];
                    if (model.creator.length <= 0) {
                        weakself.isValidName = YES;
                    } else {
                        weakself.isValidName = NO;
                    }
                }
            } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
            }];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _accountNameTF) {
        return textField.text.length + string.length <= 12;
    }
    return YES;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(id)sender {
    if (_switchQRCodeBtn.selected == YES) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[_qrImg.image] applicationActivities:nil];
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
}

- (IBAction)copyOwnerKeyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _ownerKeyTV.text?:@"";
    [kAppD.window makeToastDisappearWithText:@"Copied"];
}

- (IBAction)copyActiveKeyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _activeKeyTV.text?:@"";
    [kAppD.window makeToastDisappearWithText:@"Copied"];
}

- (IBAction)switchQRCodeAction:(UIButton *)sender {
    if (sender.selected == YES) {
        if (_accountNameTF.text.length <= 0) {
            [kAppD.window makeToastDisappearWithText:@"Account name is empty"];
            return;
        }
        if (![RegularExpression validateEosAccountName:_accountNameTF.text.trim]) {
            [kAppD.window makeToastDisappearWithText:@"a-z and 1-5 combination of 12-bit characters"];
            return;
        }
        if (_isValidName == NO) {
            [kAppD.window makeToastDisappearWithText:@"Account name is exist"];
            return;
        }
        
        _eosCreateSourceM.accountName = _accountNameTF.text;
        [KeychainUtil saveValueToKeyWithKeyName:EOS_CreateSource_InKeychain keyValue:_eosCreateSourceM.mj_keyValues.mj_JSONString];
        
        NSDictionary *qrDic = @{@"accountName":_eosCreateSourceM.accountName,@"activePublicKey":_eosCreateSourceM.ownerPublicKey,@"ownerPublicKey":_eosCreateSourceM.activePublicKey};
        kWeakSelf(self);
        //[UIImage imageNamed:@"icon_winq"]
        [HMScanner qrImageWithString:[qrDic mj_JSONString]?:@"" avatar:nil completion:^(UIImage *image) {
            weakself.qrImg.image = image;
        }];
    }
    
    sender.selected = !sender.selected;
    _qrBackHeight.constant = sender.selected == YES?47:190;
    [_switchQRCodeBtn setTitle:sender.selected == YES?@"Open QR code":@"Hide QR code" forState:UIControlStateNormal];
}

- (IBAction)registerAction:(id)sender {
    if (_accountNameTF.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Account name is empty"];
        return;
    }
    if (![RegularExpression validateEosAccountName:_accountNameTF.text.trim]) {
        [kAppD.window makeToastDisappearWithText:@"a-z and 1-5 combination of 12-bit characters"];
        return;
    }
    if (_isValidName == NO) {
        [kAppD.window makeToastDisappearWithText:@"Account name is exist"];
        return;
    }
    
    [self requestEthEth_for_activate_eos_wallet];
}

#pragma mark - Request
//- (void)requestEthEth_address {
//    kWeakSelf(self);
//    NSDictionary *params = @{};
//    [RequestService requestWithUrl:ethEth_address_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSDictionary *dic = [responseObject objectForKey:Server_Data];
//            weakself.toEthAddress = dic[@"ethAddress"];
//            [weakself requestEthEth_for_activate_eos_wallet];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//    }];
//}

- (void)requestEthEth_for_activate_eos_wallet {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [RequestService requestWithUrl:ethEth_for_activate_eos_wallet params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            weakself.ethAmount = dic[@"ethAmount"];
            weakself.toEthAddress = dic[@"ethAddress"];
            [weakself showETHTransferConfirmView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestEosNew_account:(NSString *)txid {
    kWeakSelf(self);
    NSString *name = _eosCreateSourceM.accountName;
    NSString *owner = _eosCreateSourceM.ownerPublicKey;
    NSString *active = _eosCreateSourceM.activePublicKey;
    NSDictionary *params = @{@"txid":txid?:@"",@"name":name?:@"",@"owner":owner?:@"",@"active":active?:@""};
    [RequestService requestWithUrl:eosNew_account_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        NSString *msg = [responseObject objectForKey:Server_Msg];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            
//            EOSWalletInfo *walletInfo = [[EOSWalletInfo alloc] init];
//            walletInfo.account_name = weakself.eosCreateSourceM.accountName;
//            walletInfo.account_active_public_key = weakself.eosCreateSourceM.activePublicKey;
//            walletInfo.account_active_private_key = weakself.eosCreateSourceM.activePrivateKey;
//            walletInfo.account_owner_public_key = weakself.eosCreateSourceM.ownerPublicKey;
//            walletInfo.account_owner_private_key = weakself.eosCreateSourceM.ownerPrivateKey;
//            // 存储keychain
//            [walletInfo saveToKeyChain];
//            [KeychainUtil removeKeyWithKeyName:EOS_CreateSource_InKeychain]; // 删除本地临时注册EOS资源
//            [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"EOS" address:walletInfo.account_name pubKey:walletInfo.account_owner_public_key privateKey:walletInfo.account_owner_private_key]; // 上报钱包创建
//            [[NSNotificationCenter defaultCenter] postNotificationName:Add_EOS_Wallet_Noti object:nil];
            
            [kAppD.window makeToastDisappearWithText:msg];
            
            [weakself performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
        } else {
            [weakself showTipOKView:msg];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
