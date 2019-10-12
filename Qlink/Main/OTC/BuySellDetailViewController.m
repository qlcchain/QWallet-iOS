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
#import <QLCFramework/QLCFramework.h>
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
#import "TradeOrderInfoModel.h"
#import "PairsModel.h"
#import "NewOrderQLCTransferUtil.h"
#import "NewOrderNEOTransferUtil.h"
#import "NewOrderETHTransferUtil.h"
//#import "GlobalConstants.h"

@interface BuySellDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *usdtLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *volumeSettingLab;
@property (weak, nonatomic) IBOutlet UILabel *accountPayOrReceiveLab;
@property (weak, nonatomic) IBOutlet UILabel *toPayOrReceiveLab;
@property (weak, nonatomic) IBOutlet UITextField *usdtMaxTF;
@property (weak, nonatomic) IBOutlet UITextField *qgasMaxTF;
@property (weak, nonatomic) IBOutlet UILabel *receiveAddressTipLab;
@property (weak, nonatomic) IBOutlet UITextField *receiveAddressTF;
@property (weak, nonatomic) IBOutlet UILabel *sendAddressTipLab;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createOneNowHeight; // 30
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qgasSendBackHeight; // 102
@property (weak, nonatomic) IBOutlet UITextField *qgasSendTF;

@property (weak, nonatomic) IBOutlet UIView *addressWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *addressWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *addressWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressWalletAddressLab;

@property (weak, nonatomic) IBOutlet UIView *sendQgasWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *sendQgasWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *sendQgasWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *sendQgasWalletAddressLab;

@property (weak, nonatomic) IBOutlet UILabel *unitPriceTipLab;
@property (weak, nonatomic) IBOutlet UILabel *volumeAmountTipLab;
@property (weak, nonatomic) IBOutlet UILabel *volumeSettingsTipLab;
@property (weak, nonatomic) IBOutlet UILabel *maxPayUnitTipLab;
@property (weak, nonatomic) IBOutlet UILabel *maxTradeUnitTipLab;



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
    
    _unitPriceTipLab.text = [NSString stringWithFormat:@"%@ (%@)",kLang(@"unit_price"),_inputPayToken];
    _volumeAmountTipLab.text = [NSString stringWithFormat:@"%@ (%@)",kLang(@"volume_amount"),_inputTradeToken];
    _volumeSettingsTipLab.text = [NSString stringWithFormat:@"%@ (%@)",kLang(@"limits"),_inputTradeToken];
    _maxPayUnitTipLab.text = _inputPayToken;
    _maxTradeUnitTipLab.text = _inputTradeToken;
    _receiveAddressTipLab.text = kLang(@"send_to");
    _receiveAddressTF.placeholder = kLang(@"wallet_address");
    _sendAddressTipLab.text = kLang(@"receive_from");
    _qgasSendTF.placeholder = kLang(@"wallet_address");
    if ([_inputEntrustOrderListM.type isEqualToString:@"SELL"]) { // 我是买家
        _accountPayOrReceiveLab.text = kLang(@"buying_amount");
        _toPayOrReceiveLab.text = kLang(@"to_pay");
        _titleLab.text = [NSString stringWithFormat:@"%@ %@",kLang(@"buy"),_inputTradeToken];
        _usdtLab.textColor = MAIN_BLUE_COLOR;
        
        _createOneNowHeight.constant = 30;
        _qgasSendBackHeight.constant = 0;
    } else { // 我是卖家
        _accountPayOrReceiveLab.text = kLang(@"selling_amount");
        _toPayOrReceiveLab.text = kLang(@"to_receive");
        _titleLab.text = [NSString stringWithFormat:@"%@ %@",kLang(@"sell"),_inputEntrustOrderListM.tradeToken];
        _usdtLab.textColor = UIColorFromRGB(0xFF3669);
        
        _createOneNowHeight.constant = 0;
        _qgasSendBackHeight.constant = 102;
    }
    
    _usdtLab.text = _inputEntrustOrderListM.unitPrice;
//    _totalLab.text = [NSString stringWithFormat:@"%@",_inputEntrustOrderListM.totalAmount];
    _totalLab.text = [NSString stringWithFormat:@"%@ %@",@([_inputEntrustOrderListM.totalAmount doubleValue] - [_inputEntrustOrderListM.lockingAmount doubleValue] - [_inputEntrustOrderListM.completeAmount doubleValue]),_inputTradeToken];
    _volumeSettingLab.text = [NSString stringWithFormat:@"%@-%@",_inputEntrustOrderListM.minAmount,_inputEntrustOrderListM.maxAmount];
    _usdtMaxTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLang(@"max"),@([_inputEntrustOrderListM.maxAmount doubleValue]*[_inputEntrustOrderListM.unitPrice doubleValue])];
    _qgasMaxTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLang(@"max"),_inputEntrustOrderListM.maxAmount];
}

- (void)refreshView {
    if (_orderInfoM) {
        _usdtLab.text = _orderInfoM.unitPrice;
//        _totalLab.text = [NSString stringWithFormat:@"%@",_orderInfoM.totalAmount];
        _totalLab.text = [NSString stringWithFormat:@"%@ QGAS",@([_orderInfoM.totalAmount doubleValue] - [_orderInfoM.lockingAmount doubleValue] - [_orderInfoM.completeAmount doubleValue])];
        _volumeSettingLab.text = [NSString stringWithFormat:@"%@-%@",_orderInfoM.minAmount,_orderInfoM.maxAmount];
        _usdtMaxTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLang(@"max"),@([_orderInfoM.maxAmount doubleValue]*[_orderInfoM.unitPrice doubleValue])];
        _qgasMaxTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLang(@"max"),_orderInfoM.maxAmount];
    }
}

- (void)changedTextField:(UITextField *)tf {
    if (tf == _usdtMaxTF) {
        double dou = [_usdtMaxTF.text doubleValue]/[_orderInfoM.unitPrice doubleValue];
        NSString *str = [NSString stringFromDouble:dou];
        _qgasMaxTF.text = [NSString stringWithFormat:@"%@",str];
    } else if (tf == _qgasMaxTF) {
        double dou = [_qgasMaxTF.text doubleValue]*[NSString doubleFormString:_orderInfoM.unitPrice];
        NSString *str = [NSString stringFromDouble:dou];
        _usdtMaxTF.text = [NSString stringWithFormat:@"%@",str];
    }
}

//- (void)showSubmitSuccess {
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Submitted Successfully! " message:@"Verification status will be updated on the ME page." preferredStyle:UIAlertControllerStyleAlert];
//    kWeakSelf(self)
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakself.navigationController popToRootViewControllerAnimated:YES];
//    }];
//    [alertVC addAction:action1];
//    [self presentViewController:alertVC animated:YES completion:nil];
//}

- (void)sell_transfer:(NSString *)amountStr tokenChain:(NSString *)tokenChain tokenName:(NSString *)tokenName {
    kWeakSelf(self);
    if ([tokenChain isEqualToString:QLC_Chain]) {
        [NewOrderQLCTransferUtil transferQLC:tokenName amountStr:amountStr successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
            [weakself requestTrade_sell_order];
        }];
    } else if ([tokenChain isEqualToString:NEO_Chain]) {
        [NewOrderNEOTransferUtil transferNEO:tokenName amountStr:amountStr successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
            [weakself requestTrade_sell_order];
        }];
    } else if ([tokenChain isEqualToString:EOS_Chain]) {
        
    } else if ([tokenChain isEqualToString:ETH_Chain]) {
        [NewOrderETHTransferUtil transferETH:tokenName amountStr:amountStr successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
            [weakself requestTrade_sell_order];
        }];
    }
}

#pragma mark - Request
- (void)requestEntrust_order_info {
    kWeakSelf(self);
    NSDictionary *params = @{@"entrustOrderId":_inputEntrustOrderListM.ID?:@""};
    [RequestService requestWithUrl5:entrust_order_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] doubleValue] == 0) {
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
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *entrustOrderId = _orderInfoM.ID?:@"";
    NSString *usdtAmount = _usdtMaxTF.text?:@"";
    NSString *qgasAmount = _qgasMaxTF.text?:@"";
    NSString *qgasToAddress = _receiveAddressTF.text?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"entrustOrderId":entrustOrderId,@"usdtAmount":usdtAmount,@"qgasAmount":qgasAmount,@"qgasToAddress":qgasToAddress};

    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:trade_buy_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] doubleValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            kAppD.pushToOrderList = YES;
            TradeOrderInfoModel *model = [TradeOrderInfoModel getObjectWithKeyValues:responseObject[@"order"]];
            [weakself jumpToPayAddress:model];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

//- (void)sendTransferToServer:(QLCTokenModel *)selectAsset fromAddress:(NSString *)fromAddress {
//    NSString *tokenName = selectAsset.tokenName;
//    NSString *to = [QLCWalletManage shareInstance].qlcMainAddress?:@"";
//    NSUInteger amount = [selectAsset getTransferNum:_qgasMaxTF.text];
//    NSString *sender = nil;
//    NSString *receiver = nil;
//    NSString *message = nil;
//    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___") userInteractionEnabled:NO hideTime:0];
//    kWeakSelf(self);
//    [[QLCWalletManage shareInstance] sendAssetWithTokenName:tokenName to:to amount:amount sender:sender receiver:receiver message:message successHandler:^(NSString * _Nullable responseObj) {
//        [kAppD.window hideToast];
//        [kAppD.window makeToastDisappearWithText:kLang(@"transfer_successful")];
//
//        // 下卖单
//        weakself.sellFromAddress = fromAddress;
//        weakself.sellTxid = responseObj;
//        [weakself requestTrade_sell_order];
//
//    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
//        [kAppD.window hideToast];
//    }];
//}

- (void)requestTrade_sell_order {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *entrustOrderId = _orderInfoM.ID?:@"";
    NSString *usdtAmount = _usdtMaxTF.text?:@"";
    NSString *qgasAmount = _qgasMaxTF.text?:@"";
    NSString *usdtToAddress = _receiveAddressTF.text?:@"";
    NSString *fromAddress = _sellFromAddress?:@"";
    NSString *txid = _sellTxid?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"entrustOrderId":entrustOrderId,@"usdtAmount":usdtAmount,@"qgasAmount":qgasAmount,@"usdtToAddress":usdtToAddress,@"fromAddress":fromAddress,@"txid":txid};
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:trade_sell_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] doubleValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
//            [weakself showSubmitSuccess];
            kAppD.pushToOrderList = YES;
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
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
    NSString *tokenChain = nil;
    if ([_inputEntrustOrderListM.type isEqualToString:@"SELL"]) {
        tokenChain = _inputEntrustOrderListM.tradeTokenChain;
    } else {
        tokenChain = _inputEntrustOrderListM.payTokenChain;
    }
    if ([tokenChain isEqualToString:QLC_Chain]) {
        vc.inputWalletType = WalletTypeQLC;
    } else if ([tokenChain isEqualToString:NEO_Chain]) {
        vc.inputWalletType = WalletTypeNEO;
    } else if ([tokenChain isEqualToString:EOS_Chain]) {
        vc.inputWalletType = WalletTypeEOS;
    } else if ([tokenChain isEqualToString:ETH_Chain]) {
        vc.inputWalletType = WalletTypeETH;
    }
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.addressWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
        weakself.addressWalletBack.hidden = NO;
        weakself.addressWalletM = model;
        weakself.addressWalletNameLab.text = model.name;
        weakself.addressWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.receiveAddressTF.text = model.address;
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)showSendAddressAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    NSString *tokenChain = _inputEntrustOrderListM.tradeTokenChain;
    if ([tokenChain isEqualToString:QLC_Chain]) {
        vc.inputWalletType = WalletTypeQLC;
    } else if ([tokenChain isEqualToString:NEO_Chain]) {
        vc.inputWalletType = WalletTypeNEO;
    } else if ([tokenChain isEqualToString:EOS_Chain]) {
        vc.inputWalletType = WalletTypeEOS;
    } else if ([tokenChain isEqualToString:ETH_Chain]) {
        vc.inputWalletType = WalletTypeETH;
    }
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.sendQgasWalletBack.hidden = NO;
        weakself.sendQgasWalletM = model;
        weakself.sendQgasWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
        weakself.sendQgasWalletNameLab.text = model.name;
        weakself.sendQgasWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.qgasSendTF.text = model.address;
        [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


- (IBAction)createOneNowAction:(id)sender {
    [self jumpToChooseWallet];
}

- (IBAction)submitAction:(id)sender {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if ([_orderInfoM.userId isEqualToString:userM.ID]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"you_can_not_buy_or_sell_your_own_entrust_order")];
        return;
    }
    
    if ([_usdtMaxTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",_inputPayToken,kLang(@"is_empty")]];
        return;
    }
    if ([_usdtMaxTF.text doubleValue] > [_orderInfoM.maxAmount doubleValue]*[_orderInfoM.unitPrice doubleValue]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",_inputPayToken,kLang(@"is_over_max")]];
        return;
    }
    if ([_qgasMaxTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",_inputTradeToken,kLang(@"is_empty")]];
        return;
    }
    if ([_qgasMaxTF.text doubleValue] > [_orderInfoM.maxAmount doubleValue]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",_inputTradeToken,kLang(@"is_greater_than_max_volume")]];
        return;
    }
    if ([_qgasMaxTF.text doubleValue] < [_orderInfoM.minAmount doubleValue]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",_inputTradeToken,kLang(@"is_less_than_min_volume")]];
        return;
    }
    // 检查剩余QGAS量
    NSInteger restAmount = [_orderInfoM.totalAmount doubleValue]-[_orderInfoM.lockingAmount doubleValue]-[_orderInfoM.completeAmount doubleValue];
    if (restAmount<[_qgasMaxTF.text doubleValue]) { // 交易量不足
        NSString *tip = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@ %@",_inputTradeToken,kLang(@"remain")],@(restAmount)];
        [kAppD.window makeToastDisappearWithText:tip];
        return;
    }
    
    if ([_inputEntrustOrderListM.type isEqualToString:@"SELL"]) { // 我要买
        // 检查地址有效性
        BOOL validReceiveAddress = [WalletCommonModel validAddress:_receiveAddressTF.text tokenChain:_inputEntrustOrderListM.tradeTokenChain];
        if (!validReceiveAddress) {
            [kAppD.window makeToastDisappearWithText:kLang(@"wallet_address_is_invalidate")];
            return;
        }
    
        [self requestTrade_buy_order];
    } else { // 我要卖
        // 检查地址有效性
        BOOL validReceiveAddress = [WalletCommonModel validAddress:_receiveAddressTF.text tokenChain:_inputEntrustOrderListM.payTokenChain];
        if (!validReceiveAddress) {
            [kAppD.window makeToastDisappearWithText:kLang(@"eth_wallet_address_is_invalidate")];
            return;
        }
        
        [self sell_transfer:_qgasMaxTF.text tokenChain:_inputEntrustOrderListM.tradeTokenChain tokenName:_inputEntrustOrderListM.tradeToken];
        
//        // 判断当前钱包
//        WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//        if (!currentWalletM || currentWalletM.walletType != WalletTypeQLC) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"please_switch_to_qlc_wallet")];
//            return;
//        }
//
//        // 判断QLC钱包的QLC asset
//        QLCTokenModel *qgasAsset = [kAppD.tabbarC.walletsVC getQGASAsset];
//        if (!qgasAsset) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"current_qlc_wallet_have_not_qgas")];
//            return;
//        }
//        if ([qgasAsset.balance doubleValue] < [_qgasMaxTF.text doubleValue]) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"current_qlc_wallet_have_not_enough_qgas")];
//            return;
//        }
//
//        // 检查平台地址
//        NSString *qlcAddress = [QLCWalletManage shareInstance].qlcMainAddress;
//        if ([qlcAddress isEmptyString]) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"qlc_server_address_is_empty")];
//            return;
//        }
//
//        [self showSellComfirmView:qlcAddress qgasAsset:qgasAsset fromAddress:currentWalletM.address];
    }
}

//- (void)showSellComfirmView:(NSString *)qlcAddress qgasAsset:(QLCTokenModel *)qgasAsset fromAddress:(NSString *)fromAddress {
//    QLCTransferToServerConfirmView *view = [QLCTransferToServerConfirmView getInstance];
//    [view configWithAddress:qlcAddress amount:_qgasMaxTF.text?:@"" tokenName:qgasAsset.tokenName];
//    kWeakSelf(self);
//    view.confirmBlock = ^{
//        // 转账给平台
//        [weakself sendTransferToServer:qgasAsset fromAddress:fromAddress];
//    };
//    [view show];
//}

- (IBAction)addressWalletCloseAction:(id)sender {
    _addressWalletM = nil;
    _addressWalletBack.hidden = YES;
    _receiveAddressTF.text = nil;
}

- (IBAction)sendQgasWalletCloseAction:(id)sender {
    _sendQgasWalletM = nil;
    _sendQgasWalletBack.hidden = YES;
    _qgasSendTF.text = nil;
}


#pragma mark - Transition
- (void)jumpToPayAddress:(TradeOrderInfoModel *)model {
    PayReceiveAddressViewController *vc = [PayReceiveAddressViewController new];
//    vc.inputAddress = model.usdtToAddress?:@"";
//    vc.inputAmount = _usdtMaxTF.text;
//    vc.inputAddressType = PayReceiveAddressTypeUSDT;
    vc.backToRoot = YES;
    vc.tradeM = model;
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
