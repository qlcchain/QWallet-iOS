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
//#import "QlinkTabbarViewController.h"
#import "MainTabbarViewController.h"
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
#import "RLArithmetic.h"
#import "OTCOrderTodo.h"
#import "NSString+Valid.h"
#import "TxidBackUtil.h"
#import "TradeOrderListModel.h"
#import "VerifyTipView.h"
#import "VerificationViewController.h"
#import "FirebaseUtil.h"
#import "NSString+Trim.h"

@interface BuySellDetailViewController () <UITextFieldDelegate>

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
@property (nonatomic, strong) NSString *buyFromAddress;
@property (nonatomic, strong) NSString *buyTxid;

@property (nonatomic, strong) WalletCommonModel *addressWalletM;
@property (nonatomic, strong) WalletCommonModel *sendQgasWalletM;
@property (nonatomic, strong) TradeOrderListModel *sellOrderM;

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
    
//    [_usdtMaxTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
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
        
        _createOneNowHeight.constant = 0;
        _qgasSendBackHeight.constant = 0;
    } else { // 我是卖家
        _accountPayOrReceiveLab.text = kLang(@"selling_amount");
        _toPayOrReceiveLab.text = kLang(@"to_receive");
        _titleLab.text = [NSString stringWithFormat:@"%@ %@",kLang(@"sell"),_inputEntrustOrderListM.tradeToken];
        _usdtLab.textColor = UIColorFromRGB(0xFF3669);
        
        _createOneNowHeight.constant = 0;
        _qgasSendBackHeight.constant = 102;
    }
    
    _usdtLab.text = _inputEntrustOrderListM.unitPrice_str;
//    _totalLab.text = [NSString stringWithFormat:@"%@",_inputEntrustOrderListM.totalAmount];
    _totalLab.text = [NSString stringWithFormat:@"%@ %@",_inputEntrustOrderListM.totalAmount_str.sub(_inputEntrustOrderListM.lockingAmount_str).sub(_inputEntrustOrderListM.completeAmount_str),_inputTradeToken];
    _volumeSettingLab.text = [NSString stringWithFormat:@"%@-%@",_inputEntrustOrderListM.minAmount,_inputEntrustOrderListM.maxAmount];
    
    _usdtMaxTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLang(@"max"),_inputEntrustOrderListM.maxAmount.mul(_inputEntrustOrderListM.unitPrice_str)];
    _qgasMaxTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLang(@"max"),_inputEntrustOrderListM.maxAmount];
}

- (void)refreshView {
    if (_orderInfoM) {
        _usdtLab.text = _orderInfoM.unitPrice_str;
//        _totalLab.text = [NSString stringWithFormat:@"%@",_orderInfoM.totalAmount];
        _totalLab.text = [NSString stringWithFormat:@"%@ QGAS",_orderInfoM.totalAmount_str.sub(_orderInfoM.lockingAmount_str).sub(_orderInfoM.completeAmount_str)];
        _volumeSettingLab.text = [NSString stringWithFormat:@"%@-%@",_orderInfoM.minAmount,_orderInfoM.maxAmount];
        
        _usdtMaxTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLang(@"max"),_orderInfoM.maxAmount.mul(_orderInfoM.unitPrice_str)];
        _qgasMaxTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLang(@"max"),_orderInfoM.maxAmount];
    }
}

- (void)changedTextField:(UITextField *)tf {
    if (tf == _usdtMaxTF) {
        NSString *str = _usdtMaxTF.text.trim_whitespace.div(_orderInfoM.unitPrice_str);
        _qgasMaxTF.text = [NSString stringWithFormat:@"%@",str];
    } else if (tf == _qgasMaxTF) {
        if ([tf.text isEmptyString]) {
            _usdtMaxTF.text = nil;
        } else {
            NSString *str = _qgasMaxTF.text.trim_whitespace.mul(_orderInfoM.unitPrice_str);
            NSString *str3 = str.roundPlain(8);
            _usdtMaxTF.text = [NSString stringWithFormat:@"%@",str3];
        }
    }
}

- (void)showVerifyTipView {
    VerifyTipView *view = [VerifyTipView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
        [weakself jumpToVerification];
    };
    [view showWithTitle:kLang(@"please_finish_the_verification_on_me_page")];
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

- (void)buy_transfer:(NSString *)fromAddress amountStr:(NSString *)amountStr tokenChain:(NSString *)tokenChain tokenName:(NSString *)tokenName memo:(NSString *)memo {
    kWeakSelf(self);
    if ([tokenChain isEqualToString:QLC_Chain]) {
        [NewOrderQLCTransferUtil transferQLC:fromAddress tokenName:tokenName amountStr:amountStr memo:memo successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下买单
            weakself.buyFromAddress = sendAddress;
            weakself.buyTxid = txid;
            [weakself requestTrade_buy_order];
        }];
    } else if ([tokenChain isEqualToString:NEO_Chain]) {
        [NewOrderNEOTransferUtil transferNEO:fromAddress tokenName:tokenName amountStr:amountStr successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下买单
            weakself.buyFromAddress = sendAddress;
            weakself.buyTxid = txid;
            [weakself requestTrade_buy_order];
        }];
    } else if ([tokenChain isEqualToString:EOS_Chain]) {
        
    } else if ([tokenChain isEqualToString:ETH_Chain]) {
        [NewOrderETHTransferUtil transferETH:fromAddress tokenName:tokenName amountStr:amountStr ethFee:0  successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下买单
            weakself.buyFromAddress = sendAddress;
            weakself.buyTxid = txid;
            [weakself requestTrade_buy_order];
        }];
    }
}

- (void)sell_transfer:(NSString *)fromAddress amountStr:(NSString *)amountStr tokenChain:(NSString *)tokenChain tokenName:(NSString *)tokenName memo:(NSString *)memo {
    kWeakSelf(self);
    if ([tokenChain isEqualToString:QLC_Chain]) {
        [NewOrderQLCTransferUtil transferQLC:fromAddress tokenName:tokenName amountStr:amountStr memo:memo successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
//            [weakself requestTrade_sell_orderWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
            [weakself requestTrade_sell_order_txidWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
        }];
    } else if ([tokenChain isEqualToString:NEO_Chain]) {
        [NewOrderNEOTransferUtil transferNEO:fromAddress tokenName:tokenName amountStr:amountStr successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
//            [weakself requestTrade_sell_orderWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
            [weakself requestTrade_sell_order_txidWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
        }];
    } else if ([tokenChain isEqualToString:EOS_Chain]) {
        
    } else if ([tokenChain isEqualToString:ETH_Chain]) {
        [NewOrderETHTransferUtil transferETH:fromAddress tokenName:tokenName amountStr:amountStr ethFee:0 successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
//            [weakself requestTrade_sell_orderWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
            [weakself requestTrade_sell_order_txidWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
        }];
    }
}

#pragma mark - Request
- (void)requestEntrust_order_info {
    kWeakSelf(self);
    NSDictionary *params = @{@"entrustOrderId":_inputEntrustOrderListM.ID?:@""};
    [RequestService requestWithUrl10:entrust_order_info_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
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
    NSString *usdtAmount = _usdtMaxTF.text.trim_whitespace?:@"";
    NSString *qgasAmount = _qgasMaxTF.text.trim_whitespace?:@"";
    NSString *qgasToAddress = _receiveAddressTF.text.trim_whitespace?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"entrustOrderId":entrustOrderId,@"usdtAmount":usdtAmount,@"qgasAmount":qgasAmount,@"qgasToAddress":qgasToAddress};
//    NSString *fromAddress = _buyFromAddress?:@"";
//       NSString *txid = _buyTxid?:@"";
//    NSDictionary *params = @{@"account":account,@"token":token,@"entrustOrderId":entrustOrderId,@"usdtAmount":usdtAmount,@"qgasAmount":qgasAmount,@"qgasToAddress":qgasToAddress,@"fromAddress":fromAddress,@"txid":txid};
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:trade_buy_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] doubleValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            kAppD.pushToOrderList = YES;
            TradeOrderInfoModel *model = [TradeOrderInfoModel getObjectWithKeyValues:responseObject[@"order"]];
            [weakself jumpToPayAddress:model];
//            [weakself.navigationController popToRootViewControllerAnimated:YES];
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

- (void)requestTrade_sell_orderWithTokenChain:(NSString *)tokenChain tokenName:(NSString *)tokenName tokenAmount:(NSString *)tokenAmount {
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
    NSString *usdtAmount = _usdtMaxTF.text.trim_whitespace?:@"";
    NSString *qgasAmount = _qgasMaxTF.text.trim_whitespace?:@"";
    NSString *usdtToAddress = _receiveAddressTF.text.trim_whitespace?:@"";
    NSString *fromAddress = _sellFromAddress?:@"";
//    NSString *txid = _sellTxid?:@"";
    
    NSDictionary *params = @{@"account":account,@"token":token,@"entrustOrderId":entrustOrderId,@"usdtAmount":usdtAmount,@"qgasAmount":qgasAmount,@"usdtToAddress":usdtToAddress,@"fromAddress":fromAddress};
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:trade_sell_order_v2_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] doubleValue] == 0) {
            
            weakself.sellOrderM = [TradeOrderListModel getObjectWithKeyValues:responseObject[@"order"]];
//            [weakself showSubmitSuccess];
            NSString *memo = [NSString stringWithFormat:@"%@_%@_%@_%@",@"otc",@"trade",@"sell",weakself.sellOrderM.ID?:@""];
            [weakself sell_transfer:fromAddress amountStr:tokenAmount tokenChain:tokenChain tokenName:tokenName memo:memo];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)requestTrade_sell_order_txidWithTokenChain:(NSString *)tokenChain tokenName:(NSString *)tokenName tokenAmount:(NSString *)tokenAmount {
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
    
    NSString *tradeOrderId = _sellOrderM!=nil?_sellOrderM.ID:@"";
    NSString *txid = _sellTxid?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"tradeOrderId":tradeOrderId,@"txid":txid};
    
    OTCOrder_Buysell_Sell_Txid_ParamsModel *paramsM = [OTCOrder_Buysell_Sell_Txid_ParamsModel getObjectWithKeyValues:params];
    paramsM.timestamp = timestamp;
    [[OTCOrderTodo shareInstance] savePayOrder_Buysell_Sell:paramsM];
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:trade_sell_order_txid_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] doubleValue] == 0) {
            [[OTCOrderTodo shareInstance] handlerPayOrder_Buysell_Sell_Success:paramsM];
            
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            //            [weakself showSubmitSuccess];
            kAppD.pushToOrderList = YES;
            [weakself.navigationController popToRootViewControllerAnimated:YES];
            
            [FirebaseUtil logEventWithItemID:OTC_SELL_Order_Success itemName:OTC_SELL_Order_Success contentType:OTC_SELL_Order_Success];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
            
            // 上传txid备份
            TxidBackModel *txidBackM = [TxidBackModel new];
            txidBackM.txid = params[@"txid"];
            txidBackM.type = Txid_Backup_Type_TRADE_ORDER;
            txidBackM.platform = Platform_iOS;
            txidBackM.chain = tokenChain?:@"";
            txidBackM.tokenName = tokenName?:@"";
            txidBackM.amount = tokenAmount?:@"";
            [TxidBackUtil requestSys_txid_backup:txidBackM completeBlock:^(BOOL success, NSString *msg) {
                if (success) {
                    [[OTCOrderTodo shareInstance] handlerPayOrder_Buysell_Sell_Success:paramsM];
                }
            }];
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
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)showSendAddressAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    NSString *tokenChain = @"";
    if ([_inputEntrustOrderListM.type isEqualToString:@"SELL"]) { // 我要买
        tokenChain = _inputEntrustOrderListM.payTokenChain;
    } else { // 我要卖
        tokenChain = _inputEntrustOrderListM.tradeTokenChain;
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
        weakself.sendQgasWalletBack.hidden = NO;
        weakself.sendQgasWalletM = model;
        weakself.sendQgasWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
        weakself.sendQgasWalletNameLab.text = model.name;
        weakself.sendQgasWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.qgasSendTF.text = model.address;
//        [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
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
    
    if ([_usdtMaxTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",_inputPayToken,kLang(@"is_empty")]];
        return;
    }
    if ([_usdtMaxTF.text.trim_whitespace doubleValue] > [_orderInfoM.maxAmount doubleValue]*[_orderInfoM.unitPrice_str doubleValue]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",_inputPayToken,kLang(@"is_over_max")]];
        return;
    }
    if ([_qgasMaxTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",_inputTradeToken,kLang(@"is_empty")]];
        return;
    }
    if ([_receiveAddressTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
        return;
    }
    
    if ([_qgasMaxTF.text.trim_whitespace doubleValue] > [_orderInfoM.maxAmount doubleValue]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",_inputTradeToken,kLang(@"is_greater_than_max_volume")]];
        return;
    }
    if ([_qgasMaxTF.text.trim_whitespace doubleValue] < [_orderInfoM.minAmount doubleValue]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",_inputTradeToken,kLang(@"is_less_than_min_volume")]];
        return;
    }
    // 检查剩余QGAS量
    NSString *restAmount = _orderInfoM.totalAmount_str.sub(_orderInfoM.lockingAmount_str).sub(_orderInfoM.completeAmount_str);
    if ([restAmount doubleValue]<[_qgasMaxTF.text.trim_whitespace doubleValue]) { // 交易量不足
        NSString *tip = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@ %@",_inputTradeToken,kLang(@"remain")],restAmount];
        [kAppD.window makeToastDisappearWithText:tip];
        return;
    }
    
    if ([_inputEntrustOrderListM.tradeToken isEqualToString:@"QGAS"] && [_qgasMaxTF.text.trim_whitespace doubleValue] > 1000) { // QGAS总额大于1000的挂单需要进行kyc验证
        UserModel *userM = [UserModel fetchUserOfLogin];
        if (![userM.vStatus isEqualToString:kyc_success]) {
            [self showVerifyTipView];
            return;
        }
    }
    
    if ([_inputEntrustOrderListM.type isEqualToString:@"SELL"]) { // 我要买
//        if ([_qgasSendTF.text isEmptyString]) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
//            return;
//        }
        
        // 检查地址有效性
        BOOL validReceiveAddress = [WalletCommonModel validAddress:_receiveAddressTF.text.trim_whitespace tokenChain:_inputEntrustOrderListM.tradeTokenChain];
        if (!validReceiveAddress) {
            [kAppD.window makeToastDisappearWithText:kLang(@"wallet_address_is_invalidate")];
            return;
        }
    
//        [self buy_transfer:_usdtMaxTF.text tokenChain:_inputEntrustOrderListM.payTokenChain tokenName:_inputEntrustOrderListM.payToken];
        [self requestTrade_buy_order];
        
        
        
        [FirebaseUtil logEventWithItemID:OTC_BUY_Submit itemName:OTC_BUY_Submit contentType:OTC_BUY_Submit];
    } else { // 我要卖
        if ([_qgasSendTF.text.trim_whitespace isEmptyString]) {
            [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
            return;
        }
        
        // 检查地址有效性
        BOOL validReceiveAddress = [WalletCommonModel validAddress:_receiveAddressTF.text.trim_whitespace tokenChain:_inputEntrustOrderListM.payTokenChain];
        if (!validReceiveAddress) {
            [kAppD.window makeToastDisappearWithText:kLang(@"eth_wallet_address_is_invalidate")];
            return;
        }
        
        _sellFromAddress = _qgasSendTF.text.trim_whitespace?:@"";
        [self requestTrade_sell_orderWithTokenChain:_inputEntrustOrderListM.tradeTokenChain tokenName:_inputEntrustOrderListM.tradeToken tokenAmount:_qgasMaxTF.text.trim_whitespace];
        
//        [self sell_transfer:_qgasMaxTF.text tokenChain:_inputEntrustOrderListM.tradeTokenChain tokenName:_inputEntrustOrderListM.tradeToken];
        
        
        
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
        
        [FirebaseUtil logEventWithItemID:OTC_SELL_Submit itemName:OTC_SELL_Submit contentType:OTC_SELL_Submit];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _qgasMaxTF) {
//        if (textField.text.length == 0 && [string isEqualToString:@"0"]) { // 首位不为0
//            return NO;
//        }
//
//        if (![string isNumber]) { // 限制为数字
//            return NO;
//        }
        
        if (string.length == 0) {
            return YES;
        }
        NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //正则表达式（只支持3位小数）
        NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,3})?$";
        if (![self isValid:checkStr withRegex:regex]) {
            return NO;
        }
        
        // 限制最大值
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (_orderInfoM) {
            NSInteger compareR = newString.compare(_orderInfoM.maxAmount);
            if (compareR <= 0) { // 小于等于最大值
                return YES;
            } else { // 大于最大值
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)isValid:(NSString *)checkStr withRegex:(NSString *)regex {
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}


#pragma mark - Transition
- (void)jumpToPayAddress:(TradeOrderInfoModel *)model {
    PayReceiveAddressViewController *vc = [PayReceiveAddressViewController new];
//    vc.inputAddress = model.usdtToAddress?:@"";
//    vc.inputAmount = _usdtMaxTF.text;
//    vc.inputAddressType = PayReceiveAddressTypeUSDT;
    vc.backToRoot = YES;
    vc.tradeM = model;
    vc.isBuyOrder = YES;
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

- (void)jumpToVerification {
    VerificationViewController *vc = [VerificationViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
