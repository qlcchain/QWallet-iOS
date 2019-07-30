//
//  NewOrderViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "NewOrderViewController.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "QLCWalletManage.h"
#import "WalletCommonModel.h"
#import "QlinkTabbarViewController.h"
#import "WalletsViewController.h"
#import "QLCAddressInfoModel.h"
#import <ETHFramework/ETHFramework.h>
#import "QLCTransferToServerConfirmView.h"
#import "ChooseWalletViewController.h"
#import "Qlink-Swift.h"
#import "QLCTokenInfoModel.h"
#import "WalletSelectViewController.h"
#import "QNavigationController.h"

@interface NewOrderViewController () <UITextFieldDelegate>

// BUY
@property (weak, nonatomic) IBOutlet UITextField *buyUsdtTF;
@property (weak, nonatomic) IBOutlet UITextField *buyTotalTF;
@property (weak, nonatomic) IBOutlet UITextField *buyVolumeMinAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *buyVolumeMaxAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *buyAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *buyConfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *buySegBtn;
@property (weak, nonatomic) IBOutlet UIImageView *buyReceiveQgasWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *buyReceiveQgasWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *buyReceiveQgasWalletAddressLab;
@property (weak, nonatomic) IBOutlet UIView *buyReceiveQgasWalletBack;


// SELL
@property (weak, nonatomic) IBOutlet UITextField *sellUsdtTF;
@property (weak, nonatomic) IBOutlet UITextField *sellTotalTF;
@property (weak, nonatomic) IBOutlet UITextField *sellVolumeMinAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *sellVolumeMaxAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *sellAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *sellQLCAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *sellNextBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellSegBtn;
@property (weak, nonatomic) IBOutlet UIView *sellReceiveUsdtWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *sellReceiveUsdtWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *sellReceiveUsdtWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *sellReceiveUsdtWalletAddressLab;

@property (weak, nonatomic) IBOutlet UIView *sellSendQgasWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *sellSendQgasWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *sellSendQgasWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *sellSendQgasWalletAddressLab;


@property (weak, nonatomic) IBOutlet UIView *sliderV;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScorll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentWidth;

@property (nonatomic, strong) NSString *sellFromAddress;
@property (nonatomic, strong) NSString *sellTxid;

@property (nonatomic, strong) WalletCommonModel *buyReceiveQgasWalletM;
@property (nonatomic, strong) WalletCommonModel *sellReceiveUsdtWalletM;
@property (nonatomic, strong) WalletCommonModel *sellSendQgasWalletM;
@property (nonatomic) BOOL isFirstAppear;

@end

@implementation NewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isFirstAppear = YES;
    [self configInit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isFirstAppear) {
        _isFirstAppear = NO;
        [self refreshSelect:_buySegBtn];
    }
}

#pragma mark - Operation
- (void)configInit {
    _buyConfirmBtn.layer.cornerRadius = 4.0;
    _buyConfirmBtn.layer.masksToBounds = YES;
    
    _sellNextBtn.layer.cornerRadius = 4.0;
    _sellNextBtn.layer.masksToBounds = YES;
    
    _buyReceiveQgasWalletBack.hidden = YES;
    _sellReceiveUsdtWalletBack.hidden = YES;
    _sellSendQgasWalletBack.hidden = YES;

    _scrollContentWidth.constant = 2*SCREEN_WIDTH;
}

- (void)refreshSelect:(UIButton *)sender {
    _buySegBtn.selected = sender==_buySegBtn?YES:NO;
    _sellSegBtn.selected = sender==_sellSegBtn?YES:NO;
    kWeakSelf(self);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakself.sliderV.frame = CGRectMake(0, sender.height, sender.width+10, 2);
        weakself.sliderV.center = CGPointMake(sender.center.x, sender.height+1);
    } completion:^(BOOL finished) {
    }];
}

- (void)showSubmitSuccess {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Submitted Successfully! " message:@"Verification status will be updated on the ME page." preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self)
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertVC addAction:action1];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showQLCAddressAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeQLC;
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.buyReceiveQgasWalletBack.hidden = NO;
        weakself.buyReceiveQgasWalletM = model;
        weakself.buyReceiveQgasWalletNameLab.text = model.name;
        weakself.buyReceiveQgasWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.buyAddressTF.text = model.address;
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    return;
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *qlcArr = [WalletCommonModel getWalletModelWithType:WalletTypeQLC];
    [qlcArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *model = obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:model.address style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.buyAddressTF.text = model.address;
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)showETHAddressAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeETH;
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.sellReceiveUsdtWalletBack.hidden = NO;
        weakself.sellReceiveUsdtWalletM = model;
        weakself.sellReceiveUsdtWalletNameLab.text = model.name;
        weakself.sellReceiveUsdtWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.sellAddressTF.text = model.address;
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    return;
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *ethArr = [WalletCommonModel getWalletModelWithType:WalletTypeETH];
    [ethArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *model = obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:model.address style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.sellAddressTF.text = model.address;
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)showSellSendQGasAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeQLC;
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.sellSendQgasWalletBack.hidden = NO;
        weakself.sellSendQgasWalletM = model;
        weakself.sellSendQgasWalletNameLab.text = model.name;
        weakself.sellSendQgasWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.sellQLCAddressTF.text = model.address;
        [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    return;
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *qlcArr = [WalletCommonModel getWalletModelWithType:WalletTypeQLC];
    [qlcArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *model = obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:model.address style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.sellQLCAddressTF.text = model.address;
            [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)buySegAction:(id)sender {
    [self refreshSelect:sender];
    [_mainScorll setContentOffset:CGPointMake(SCREEN_WIDTH*0, 0) animated:YES];
}

- (IBAction)sellSegAction:(id)sender {
    [self refreshSelect:sender];
    [_mainScorll setContentOffset:CGPointMake(SCREEN_WIDTH*1, 0) animated:YES];
}

- (IBAction)createOneNowAction:(id)sender {
    [self jumpToChooseWallet];
}

- (IBAction)buyConfirmAction:(id)sender {
    if ([_buyUsdtTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"Unit Price is empty"];
        return;
    }
    if ([_buyUsdtTF.text doubleValue] <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Unit Price needs greater than 0"];
        return;
    }
    if ([_buyTotalTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"Total Amount is empty"];
        return;
    }
    if ([_buyVolumeMinAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"Min Amount is empty"];
        return;
    }
    if ([_buyVolumeMaxAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"Max Amount is empty"];
        return;
    }
    if ([_buyAddressTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"Address is empty"];
        return;
    }
    
    // 检查地址有效性
    BOOL validateQLCAddress = [QLCWalletManage.shareInstance walletAddressIsValid:_buyAddressTF.text];
    if (!validateQLCAddress) {
        [kAppD.window makeToastDisappearWithText:@"QLC Wallet Address is invalidate"];
        return;
    }
    
    // 下买单
    [self requestEntrustBuyOrder];
}

- (IBAction)sellNextAction:(id)sender {
    if ([_sellUsdtTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"Unit Price is empty"];
        return;
    }
    if ([_sellUsdtTF.text doubleValue] <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Unit Price needs greater than 0"];
        return;
    }
    if ([_sellTotalTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"Total Amount is empty"];
        return;
    }
    if ([_sellVolumeMinAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"Min Amount is empty"];
        return;
    }
    if ([_sellVolumeMaxAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"Max Amount is empty"];
        return;
    }
    if ([_sellTotalTF.text integerValue] < [_sellVolumeMaxAmountTF.text integerValue]) {
        [kAppD.window makeToastDisappearWithText:@"Total Amount need greater than or equal to Max Amount"];
        return;
    }
    if ([_sellAddressTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"Address is empty"];
        return;
    }
    if ([_sellQLCAddressTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"QLC Chain Address is empty"];
        return;
    }
    
    // 检查地址有效性
    BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:_sellAddressTF.text];
    if (!isValid) {
        [kAppD.window makeToastDisappearWithText:@"ETH Wallet Address is invalidate"];
        return;
    }
    
    // 判断当前钱包
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM || currentWalletM.walletType != WalletTypeQLC) {
        [kAppD.window makeToastDisappearWithText:@"Please switch to QLC Wallet"];
        return;
    }
    
    // 判断QLC钱包的QLC asset
    QLCTokenModel *qgasAsset = [kAppD.tabbarC.walletsVC getQGASAsset];
    if (!qgasAsset) {
        [kAppD.window makeToastDisappearWithText:@"Current QLC Wallet have not QGAS"];
        return;
    }
    if ([qgasAsset.balance floatValue] < [_sellTotalTF.text floatValue]) {
        [kAppD.window makeToastDisappearWithText:@"Current QLC Wallet have not enough QGAS"];
        return;
    }
    
    // 检查平台地址
    NSString *qlcAddress = [QLCWalletManage shareInstance].qlcMainAddress;
    if ([qlcAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"QLC Server Address is empty"];
        return;
    }
    
//    [self jumpToSellOrderAddress:qlcAddress qgasAsset:qgasAsset fromAddress:currentWalletM.address];
    [self showSellComfirmView:qlcAddress qgasAsset:qgasAsset fromAddress:currentWalletM.address];
}

- (void)showSellComfirmView:(NSString *)qlcAddress qgasAsset:(QLCTokenModel *)qgasAsset fromAddress:(NSString *)fromAddress {
    QLCTransferToServerConfirmView *view = [QLCTransferToServerConfirmView getInstance];
    [view configWithAddress:qlcAddress amount:_sellTotalTF.text?:@""];
    kWeakSelf(self);
    view.confirmBlock = ^{
        [weakself sendTransferToServer:qgasAsset fromAddress:fromAddress];
    };
    [view show];
}

- (IBAction)buyReceiveQgasWalletCloseAction:(id)sender {
    _buyReceiveQgasWalletM = nil;
    _buyReceiveQgasWalletBack.hidden = YES;
    _buyAddressTF.text = nil;
}

- (IBAction)sellReceiveUsdtWalletCloseAction:(id)sender {
    _sellReceiveUsdtWalletM = nil;
    _sellReceiveUsdtWalletBack.hidden = YES;
    _sellAddressTF.text = nil;
}

- (IBAction)sellSendQgasWalletCloseAction:(id)sender {
    _sellSendQgasWalletM = nil;
    _sellSendQgasWalletBack.hidden = YES;
    _sellQLCAddressTF.text = nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _buyUsdtTF || textField == _sellUsdtTF) {
        if (string.length == 0) {
            return YES;
        }
        
        NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        //正则表达式（只支持3位小数）
        NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,3})?$";
        return [self isValid:checkStr withRegex:regex];
    } else {
        return YES;
    }
}

- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex {
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}


#pragma mark - Request
- (void)requestEntrustBuyOrder {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *unitPrice = _buyUsdtTF.text?:@"";
    NSString *totalAmount = _buyTotalTF.text?:@"";
    NSString *minAmount = _buyVolumeMinAmountTF.text?:@"";
    NSString *maxAmount = _buyVolumeMaxAmountTF.text?:@"";
    NSString *qgasAddress = _buyAddressTF.text?:@"";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"account":account,@"token":token,@"type":@"BUY",@"unitPrice":unitPrice,@"totalAmount":totalAmount,@"minAmount":minAmount,@"maxAmount":maxAmount}];
    [params setObject:qgasAddress forKey:@"qgasAddress"];
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:entrust_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
//            [kAppD.window makeToastDisappearWithText:@"Success."];
//            [weakself showSubmitSuccess];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [kAppD.window makeToastDisappearWithText:@"Failed."];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)sendTransferToServer:(QLCTokenModel *)selectAsset fromAddress:(NSString *)fromAddress {
    NSString *tokenName = selectAsset.tokenName;
    NSString *to = [QLCWalletManage shareInstance].qlcMainAddress?:@"";
    NSUInteger amount = [selectAsset getTransferNum:_sellTotalTF.text?:@""];
    NSString *sender = nil;
    NSString *receiver = nil;
    NSString *message = nil;
    [kAppD.window makeToastInView:kAppD.window text:@"Process..." userInteractionEnabled:NO hideTime:0];
    kWeakSelf(self);
    [[QLCWalletManage shareInstance] sendAssetWithTokenName:tokenName to:to amount:amount sender:sender receiver:receiver message:message successHandler:^(NSString * _Nullable responseObj) {
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:@"Transfer Successful."];
        
        // 下卖单
        weakself.sellFromAddress = fromAddress;
        weakself.sellTxid = responseObj;
        [weakself requestEntrustSellOrder];
        
    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
        [kAppD.window hideToast];
    }];
}

- (void)requestEntrustSellOrder {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]])];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *unitPrice = _sellUsdtTF.text?:@"";
    NSString *totalAmount = _sellTotalTF.text?:@"";
    NSString *minAmount = _sellVolumeMinAmountTF.text?:@"";
    NSString *maxAmount = _sellVolumeMaxAmountTF.text?:@"";
    NSString *usdtAddress = _sellAddressTF.text?:@"";
    NSString *fromAddress = _sellFromAddress?:@"";
    NSString *txid = _sellTxid?:@"";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"account":account,@"token":token,@"type":@"SELL",@"unitPrice":unitPrice,@"totalAmount":totalAmount,@"minAmount":minAmount,@"maxAmount":maxAmount}];
    [params setObject:usdtAddress forKey:@"usdtAddress"];
    [params setObject:fromAddress forKey:@"fromAddress"];
    [params setObject:txid forKey:@"txid"];
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:entrust_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            //            [kAppD.window makeToastDisappearWithText:@"Success."];
            
//            [weakself showSubmitSuccess];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [kAppD.window makeToastDisappearWithText:@"Failed."];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

//- (void)requestQLCTokens {
//    [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
//    [LedgerRpc tokensWithSuccessHandler:^(id _Nullable responseObject) {
//        [kAppD.window hideToast];
//
//        if (responseObject != nil) {
//            NSArray *tokenArr = [QLCTokenInfoModel mj_objectArrayWithKeyValuesArray:responseObject];
//            [weakself.qlcAddressInfoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                QLCTokenModel *tokenM = obj;
//                [tokenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    QLCTokenInfoModel *tokenInfoM = obj;
//                    if ([tokenM.tokenName isEqualToString:tokenInfoM.tokenName]) {
//                        tokenM.tokenInfoM = tokenInfoM;
//                        *stop = YES;
//                    }
//                }];
//            }];
//            [weakself updateWalletWithQLC:weakself.qlcAddressInfoM];
//            [weakself refreshDataWithQLC];
//        }
//
//    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
//        if (showLoad) {
//            [kAppD.window hideToast];
//        }
//        [kAppD.window makeToastDisappearWithText:message];
//    }];
//}

#pragma mark - Transition
- (void)jumpToChooseWallet {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
