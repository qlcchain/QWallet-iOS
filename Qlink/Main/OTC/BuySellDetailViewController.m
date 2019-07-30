//
//  BuySellDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BuySellDetailViewController.h"
#import "EntrustOrderListModel.h"
#import "EntrustOrderInfoModel.h"
#import "QLCWalletManage.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import <ETHFramework/ETHFramework.h>
#import "PayReceiveAddressViewController.h"
#import "QLCAddressInfoModel.h"
#import "WalletCommonModel.h"
#import "QlinkTabbarViewController.h"
#import "WalletsViewController.h"
#import "QLCTransferToServerConfirmView.h"
#import "ChooseWalletViewController.h"
#import "NSString+RemoveZero.h"
#import "WalletSelectViewController.h"
#import "QNavigationController.h"

@interface BuySellDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *usdtLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *volumeSettingLab;
@property (weak, nonatomic) IBOutlet UITextField *usdtMaxTF;
@property (weak, nonatomic) IBOutlet UITextField *qgasMaxTF;
@property (weak, nonatomic) IBOutlet UILabel *addressTipLab;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createOneNowHeight; // 30
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qgasSendBackHeight; // 88
@property (weak, nonatomic) IBOutlet UITextField *qgasSendTF;

@property (weak, nonatomic) IBOutlet UIView *addressWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *addressWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *addressWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressWalletAddressLab;

@property (weak, nonatomic) IBOutlet UIView *sendQgasWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *sendQgasWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *sendQgasWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *sendQgasWalletAddressLab;


@property (nonatomic, strong) EntrustOrderInfoModel *orderInfoM;
@property (nonatomic, strong) NSString *sellFromAddress;
@property (nonatomic, strong) NSString *sellTxid;

@property (nonatomic, strong) WalletCommonModel *addressWalletM;
@property (nonatomic, strong) WalletCommonModel *sendQgasWalletM;

@end

@implementation BuySellDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestEntrust_order_info];
}

#pragma mark - Operation
- (void)configInit {
    _submitBtn.layer.cornerRadius = 4.0;
    _submitBtn.layer.masksToBounds = YES;
    
    _addressWalletBack.hidden = YES;
    _sendQgasWalletBack.hidden = YES;
    
    [_usdtMaxTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [_qgasMaxTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    if ([_inputEntrustOrderListM.type isEqualToString:@"SELL"]) { // 我是买家
        _titleLab.text = @"BUY QGAS";
        _usdtLab.textColor = MAIN_BLUE_COLOR;
        _addressTipLab.text = @"QLC Chain Address to receive QGAS";
        _addressTF.placeholder = @"QLC Chain Wallet Address";
        _createOneNowHeight.constant = 30;
        _qgasSendBackHeight.constant = 0;
    } else { // 我是卖家
        _titleLab.text = @"SELL QGAS";
        _usdtLab.textColor = UIColorFromRGB(0xFF3669);
        _addressTipLab.text = @"ERC-20 Address to receive USDT";
        _addressTF.placeholder = @"ERC-20 Wallet Address";
        _createOneNowHeight.constant = 0;
        _qgasSendBackHeight.constant = 88;
    }
    
    _usdtLab.text = _inputEntrustOrderListM.unitPrice;
//    _totalLab.text = [NSString stringWithFormat:@"%@",_inputEntrustOrderListM.totalAmount];
    _totalLab.text = [NSString stringWithFormat:@"%@ QGAS",@([_inputEntrustOrderListM.totalAmount integerValue] - [_inputEntrustOrderListM.lockingAmount integerValue] - [_inputEntrustOrderListM.completeAmount integerValue])];
    _volumeSettingLab.text = [NSString stringWithFormat:@"%@-%@",_inputEntrustOrderListM.minAmount,_inputEntrustOrderListM.maxAmount];
    _usdtMaxTF.placeholder = [NSString stringWithFormat:@"Max %@",@([_inputEntrustOrderListM.maxAmount integerValue]*[_inputEntrustOrderListM.unitPrice floatValue])];
    _qgasMaxTF.placeholder = [NSString stringWithFormat:@"Max %@",_inputEntrustOrderListM.maxAmount];
}

- (void)refreshView {
    if (_orderInfoM) {
        _usdtLab.text = _orderInfoM.unitPrice;
//        _totalLab.text = [NSString stringWithFormat:@"%@",_orderInfoM.totalAmount];
        _totalLab.text = [NSString stringWithFormat:@"%@ QGAS",@([_orderInfoM.totalAmount integerValue] - [_orderInfoM.lockingAmount integerValue] - [_orderInfoM.completeAmount integerValue])];
        _volumeSettingLab.text = [NSString stringWithFormat:@"%@-%@",_orderInfoM.minAmount,_orderInfoM.maxAmount];
        _usdtMaxTF.placeholder = [NSString stringWithFormat:@"Max %@",@([_orderInfoM.maxAmount integerValue]*[_orderInfoM.unitPrice floatValue])];
        _qgasMaxTF.placeholder = [NSString stringWithFormat:@"Max %@",_orderInfoM.maxAmount];
    }
}

- (void)changedTextField:(UITextField *)tf {
    if (tf == _usdtMaxTF) {
        double dou = [_usdtMaxTF.text doubleValue]/[_orderInfoM.unitPrice doubleValue];
        NSString *str = [NSString stringFromDouble:dou];
        _qgasMaxTF.text = [NSString stringWithFormat:@"%@",str];
    } else if (tf == _qgasMaxTF) {
        double dou = [_qgasMaxTF.text integerValue]*[NSString doubleFormString:_orderInfoM.unitPrice];
        NSString *str = [NSString stringFromDouble:dou];
        _usdtMaxTF.text = [NSString stringWithFormat:@"%@",str];
    }
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

#pragma mark - Request
- (void)requestEntrust_order_info {
    kWeakSelf(self);
    NSDictionary *params = @{@"entrustOrderId":_inputEntrustOrderListM.ID?:@""};
    [RequestService requestWithUrl:entrust_order_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.orderInfoM = [EntrustOrderInfoModel getObjectWithKeyValues:responseObject[@"order"]];
            [weakself refreshView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestTrade_buy_order {
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
    
    NSString *entrustOrderId = _orderInfoM.ID?:@"";
    NSString *usdtAmount = _usdtMaxTF.text?:@"";
    NSString *qgasAmount = _qgasMaxTF.text?:@"";
    NSString *qgasToAddress = _addressTF.text?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"entrustOrderId":entrustOrderId,@"usdtAmount":usdtAmount,@"qgasAmount":qgasAmount,@"qgasToAddress":qgasToAddress};

    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:trade_buy_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"Success."];
            kAppD.pushToOrderList = YES;
            [weakself jumpToUSDTAddress:weakself.orderInfoM.usdtAddress?:@""];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)sendTransferToServer:(QLCTokenModel *)selectAsset fromAddress:(NSString *)fromAddress {
    NSString *tokenName = selectAsset.tokenName;
    NSString *to = [QLCWalletManage shareInstance].qlcMainAddress?:@"";
    NSUInteger amount = [selectAsset getTransferNum:_qgasMaxTF.text];
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
        [weakself requestTrade_sell_order];
        
    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
        [kAppD.window hideToast];
    }];
}

- (void)requestTrade_sell_order {
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
    
    NSString *entrustOrderId = _orderInfoM.ID?:@"";
    NSString *usdtAmount = _usdtMaxTF.text?:@"";
    NSString *qgasAmount = _qgasMaxTF.text?:@"";
    NSString *usdtToAddress = _addressTF.text?:@"";
    NSString *fromAddress = _sellFromAddress?:@"";
    NSString *txid = _sellTxid?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"entrustOrderId":entrustOrderId,@"usdtAmount":usdtAmount,@"qgasAmount":qgasAmount,@"usdtToAddress":usdtToAddress,@"fromAddress":fromAddress,@"txid":txid};
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:trade_sell_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"Success."];
//            [weakself showSubmitSuccess];
            kAppD.pushToOrderList = YES;
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [kAppD.window makeToastDisappearWithText:@"Failed."];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showAddressAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    if ([_inputEntrustOrderListM.type isEqualToString:@"SELL"]) {
        vc.inputWalletType = WalletTypeQLC;
    } else {
        vc.inputWalletType = WalletTypeETH;
    }
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        if ([weakself.inputEntrustOrderListM.type isEqualToString:@"SELL"]) {
            weakself.addressWalletIcon.image = [UIImage imageNamed:@"qlc_wallet"];
        } else {
            weakself.addressWalletIcon.image = [UIImage imageNamed:@"eth_wallet"];
        }
        weakself.addressWalletBack.hidden = NO;
        weakself.addressWalletM = model;
        weakself.addressWalletNameLab.text = model.name;
        weakself.addressWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.addressTF.text = model.address;
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    return;
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *arr = @[];
    if ([_inputEntrustOrderListM.type isEqualToString:@"SELL"]) {
        arr = [WalletCommonModel getWalletModelWithType:WalletTypeQLC];
    } else {
        arr = [WalletCommonModel getWalletModelWithType:WalletTypeETH];
    }
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCommonModel *model = obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:model.address style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.addressTF.text = model.address;
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)showSendAddressAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeQLC;
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.sendQgasWalletBack.hidden = NO;
        weakself.sendQgasWalletM = model;
        weakself.sendQgasWalletNameLab.text = model.name;
        weakself.sendQgasWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.qgasSendTF.text = model.address;
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
            weakself.qgasSendTF.text = model.address;
            [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}


- (IBAction)createOneNowAction:(id)sender {
    [self jumpToChooseWallet];
}

- (IBAction)submitAction:(id)sender {
    if ([_usdtMaxTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"USDT is empty"];
        return;
    }
    if ([_usdtMaxTF.text floatValue] > [_orderInfoM.maxAmount integerValue]*[_orderInfoM.unitPrice floatValue]) {
        [kAppD.window makeToastDisappearWithText:@"USDT is over max"];
        return;
    }
    if ([_qgasMaxTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:@"QGAS is empty"];
        return;
    }
    if ([_qgasMaxTF.text integerValue] > [_orderInfoM.maxAmount integerValue]) {
        [kAppD.window makeToastDisappearWithText:@"QGAS is greater than max volume"];
        return;
    }
    if ([_qgasMaxTF.text integerValue] < [_orderInfoM.minAmount integerValue]) {
        [kAppD.window makeToastDisappearWithText:@"QGAS is less than min volume"];
        return;
    }
    // 检查剩余QGAS量
    NSInteger restAmount = [_orderInfoM.totalAmount integerValue]-[_orderInfoM.lockingAmount integerValue]-[_orderInfoM.completeAmount integerValue];
    if (restAmount<[_qgasMaxTF.text integerValue]) { // 交易量不足
        NSString *tip = [NSString stringWithFormat:@"QGAS is only %@ left",@(restAmount)];
        [kAppD.window makeToastDisappearWithText:tip];
        return;
    }
    
    if ([_inputEntrustOrderListM.type isEqualToString:@"SELL"]) { // 我要买
        // 检查地址有效性
        BOOL validateQLCAddress = [QLCWalletManage.shareInstance walletAddressIsValid:_addressTF.text];
        if (!validateQLCAddress) {
            [kAppD.window makeToastDisappearWithText:@"QLC Wallet Address is invalidate"];
            return;
        }
        
    
        [self requestTrade_buy_order];
    } else { // 我要卖
        // 检查地址有效性
        BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:_addressTF.text];
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
        if ([qgasAsset.balance floatValue] < [_qgasMaxTF.text floatValue]) {
            [kAppD.window makeToastDisappearWithText:@"Current QLC Wallet have not enough QGAS"];
            return;
        }
        
        // 检查平台地址
        NSString *qlcAddress = [QLCWalletManage shareInstance].qlcMainAddress;
        if ([qlcAddress isEmptyString]) {
            [kAppD.window makeToastDisappearWithText:@"QLC Server Address is empty"];
            return;
        }
        
        [self showSellComfirmView:qlcAddress qgasAsset:qgasAsset fromAddress:currentWalletM.address];
    }
}

- (void)showSellComfirmView:(NSString *)qlcAddress qgasAsset:(QLCTokenModel *)qgasAsset fromAddress:(NSString *)fromAddress {
    QLCTransferToServerConfirmView *view = [QLCTransferToServerConfirmView getInstance];
    [view configWithAddress:qlcAddress amount:_qgasMaxTF.text?:@""];
    kWeakSelf(self);
    view.confirmBlock = ^{
        // 转账给平台
        [weakself sendTransferToServer:qgasAsset fromAddress:fromAddress];
    };
    [view show];
}

- (IBAction)addressWalletCloseAction:(id)sender {
    _addressWalletM = nil;
    _addressWalletBack.hidden = YES;
    _addressTF.text = nil;
}

- (IBAction)sendQgasWalletCloseAction:(id)sender {
    _sendQgasWalletM = nil;
    _sendQgasWalletBack.hidden = YES;
    _qgasSendTF.text = nil;
}


#pragma mark - Transition
- (void)jumpToUSDTAddress:(NSString *)usdtAddress  {
    PayReceiveAddressViewController *vc = [PayReceiveAddressViewController new];
    vc.inputAddress = usdtAddress;
    vc.inputAmount = _usdtMaxTF.text;
    vc.inputAddressType = PayReceiveAddressTypeUSDT;
//    vc.showSubmitTip = YES;
    vc.backToRoot = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)jumpToQGASAddress:(NSString *)qgasAddress {
//    PayReceiveAddressViewController *vc = [PayReceiveAddressViewController new];
//    vc.inputAddress = qgasAddress;
//    vc.inputAmount = _qgasMaxTF.text;
//    vc.inputAddressType = PayReceiveAddressTypeQGAS;
//    vc.showSubmitTip = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)jumpToChooseWallet {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
