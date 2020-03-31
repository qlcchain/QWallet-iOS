//
//  ETHTransferViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "OTCPayETHViewController.h"
#import "ETHTransferConfirmView.h"
#import "UITextView+ZWPlaceHolder.h"
#import "WalletCommonModel.h"
#import "ETHAddressInfoModel.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import <ETHFramework/ETHFramework.h>
#import "ReportUtil.h"
#import "WalletQRViewController.h"
#import "WalletSelectViewController.h"
#import "QNavigationController.h"
#import "QlinkTabbarViewController.h"
#import "WalletsViewController.h"
#import "TradeOrderDetailViewController.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
//#import "GlobalConstants.h"
#import "RLArithmetic.h"
#import "OTCOrderTodo.h"
#import "TxidBackUtil.h"
#import "TokenListHelper.h"

@interface OTCPayETHViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *payWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *payWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *payWalletAddressLab;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *gasDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gasDetailHeight; // 143
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *symbolLab;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextView *sendtoAddressTV;
@property (weak, nonatomic) IBOutlet UITextField *memoTF;
@property (weak, nonatomic) IBOutlet UILabel *gascostLab;
@property (weak, nonatomic) IBOutlet UISlider *gasSlider;
@property (weak, nonatomic) IBOutlet UILabel *gasLimitLab;

@property (nonatomic, strong) NSMutableArray *tokenPriceArr;
@property (nonatomic, strong) NSString *gasCostETH;
@property (nonatomic, strong) Token *selectToken;
@property (nonatomic, strong) Token *ethToken;
@property (nonatomic, strong) WalletCommonModel *payWalletM;
@property (nonatomic, strong) NSArray *ethSource;

@end

@implementation OTCPayETHViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserve {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTokenNoti:) name:Update_ETH_Wallet_Token_Noti object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserve];
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    [_sendBtn cornerRadius:6];
}

- (void)configInit {
    _payWalletNameLab.text = nil;
    _payWalletAddressLab.text = nil;
    
    _tokenPriceArr = [NSMutableArray array];
    
    _sendtoAddressTV.placeholder = kLang(@"eth_wallet_address");
    _sendtoAddressTV.text = _sendToAddress;
    _gasDetailHeight.constant = 0;
    _amountTF.text = _sendAmount;
    _memoTF.text = _sendMemo;
    
    _sendBtn.userInteractionEnabled = NO;
    [_amountTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    _sendtoAddressTV.delegate = self;
    
    [self refreshView];
}

- (void)refreshView {
    NSString *symbolStr = _inputPayToken?:@"";
    NSString *balanceStr = [NSString stringWithFormat:@"%@: 0 %@",kLang(@"balance"),_inputPayToken?:@""];
    if (_selectToken) {
        balanceStr = [NSString stringWithFormat:@"%@: %@ %@",kLang(@"balance"),[_selectToken getTokenNum],_selectToken.tokenInfo.symbol];
        symbolStr = _selectToken.tokenInfo.symbol;
    }
    _balanceLab.text = balanceStr;
    _symbolLab.text = symbolStr;
    [self refreshGasCost];
    [self requestTokenPrice];
}

- (void)refreshGasCost {
    NSString *decimals = ETH_Decimals;
    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
//    NSNumber *ethFloatNum = @(_gasSlider.value*[_gasLimitLab.text integerValue]*[decimalsNum doubleValue]);
    NSString *ethFloatStr = @(_gasSlider.value).mul(_gasLimitLab.text).mul(decimalsNum);
    _gasCostETH = [NSString stringWithFormat:@"%@",ethFloatStr];
    
    __block NSString *price = @"";
    [_tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TokenPriceModel *model = obj;
        if ([model.symbol isEqualToString:_selectToken.tokenInfo.symbol]) {
//            NSNumber *priceNum = @([_gasCostETH doubleValue]*[model.price doubleValue]);
//            price = [NSString stringWithFormat:@"%@",priceNum];
            price = _gasCostETH.mul(model.price);
            *stop = YES;
        }
    }];
    _gascostLab.text = [NSString stringWithFormat:@"%@ ETH ≈ %@%@",_gasCostETH,[ConfigUtil getLocalUsingCurrencySymbol],price];
}

- (void)showETHTransferConfirmView {
    NSString *fromAddress = _payWalletM.address?:@"";
    NSString *toAddress = _sendtoAddressTV.text;
    NSString *amount = [NSString stringWithFormat:@"%@ %@",_amountTF.text,_selectToken.tokenInfo.symbol];
    NSString *gasfee = [NSString stringWithFormat:@"%@ ETH",_gasCostETH];
    ETHTransferConfirmView *view = [ETHTransferConfirmView getInstance];
    [view configWithFromAddress:fromAddress toAddress:toAddress amount:amount gasfee:gasfee];
//    [view configWithAddress:address amount:amount gasfee:gasfee];
    kWeakSelf(self);
    view.confirmBlock = ^{
        [weakself sendTransfer:fromAddress];
    };
    [view show];
}

- (void)checkSendBtnEnable {
    if (_sendtoAddressTV.text && _sendtoAddressTV.text.length > 0 && _amountTF.text && _amountTF.text.length > 0 && _payWalletM != nil) {
        _sendBtn.theme_backgroundColor = globalBackgroundColorPicker;
        _sendBtn.userInteractionEnabled = YES;
    } else {
        [_sendBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
        _sendBtn.userInteractionEnabled = NO;
    }
}

- (void)textFieldDidEnd {
    [self checkSendBtnEnable];
}

- (void)sendTransfer:(NSString *)from_address {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    NSString *fromAddress = currentWalletM.address;
    NSString *fromAddress = from_address;
    NSString *contractAddress = _selectToken.tokenInfo.address;
    NSString *toAddress = _sendtoAddressTV.text;
    NSString *name = _selectToken.tokenInfo.name;
    NSString *symbol = _selectToken.tokenInfo.symbol;
    NSString *amount = _amountTF.text;
    NSInteger gasLimit = [_gasLimitLab.text integerValue];
    NSInteger gasPrice = _gasSlider.value;
    NSInteger decimals = [_selectToken.tokenInfo.decimals integerValue];
    NSString *value = @"";
    NSString *memo = _memoTF.text?:@"";
    BOOL isCoin = [_selectToken.tokenInfo.symbol isEqualToString:@"ETH"]?YES:NO;
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window];
    [TrustWalletManage.sharedInstance sendFromAddress:fromAddress contractAddress:contractAddress toAddress:toAddress name:name symbol:symbol amount:amount gasLimit:gasLimit gasPrice:gasPrice memo:memo decimals:decimals value:value isCoin:isCoin :^(BOOL success, NSString *txId) {
        [kAppD.window hideToast];
        if (success) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"send_success")];
            NSString *blockChain = @"ETH";
            [ReportUtil requestWalletReportWalletRransferWithAddressFrom:fromAddress addressTo:toAddress blockChain:blockChain symbol:symbol amount:amount txid:txId?:@""]; // 上报钱包转账
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
                [weakself requestTrade_buyer_confirm:txId tokenName:symbol tokenAmount:amount]; // 买家确认支付
            });
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"send_fail")];
        }
    }];
}

- (void)requestTrade_buyer_confirm:(NSString *)txid tokenName:(NSString *)tokenName tokenAmount:(NSString *)tokenAmount {
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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token,@"tradeOrderId":_inputTradeOrderId?:@"",@"txid":txid?:@""}];
    
    OTCOrder_Buysell_Buy_Confirm_ParamsModel *paramsM = [OTCOrder_Buysell_Buy_Confirm_ParamsModel getObjectWithKeyValues:params];
    paramsM.timestamp = timestamp;
    [[OTCOrderTodo shareInstance] savePayOrder_Buysell_Buy_Confirm:paramsM];
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:trade_buyer_confirm_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [[OTCOrderTodo shareInstance] handlerPayOrder_Buysell_Buy_Confirm_Success:paramsM];
            
            if (weakself.transferToRoot) {
                [weakself backToRoot];
            } else if (weakself.transferToTradeDetail) {
                [weakself backToTradeDetail];
            } else {
                [weakself backAction:nil];
            }
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
            
            // 上传txid备份
            TxidBackModel *txidBackM = [TxidBackModel new];
            txidBackM.txid = params[@"txid"];
            txidBackM.type = Txid_Backup_Type_TRADE_ORDER;
            txidBackM.platform = Platform_iOS;
            txidBackM.chain = ETH_Chain;
            txidBackM.tokenName = tokenName?:@"";
            txidBackM.amount = tokenAmount?:@"";
            [TxidBackUtil requestSys_txid_backup:txidBackM completeBlock:^(BOOL success, NSString *msg) {
                if (success) {
                    [[OTCOrderTodo shareInstance] handlerPayOrder_Buysell_Buy_Confirm_Success:paramsM];
                }
            }];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backToTradeDetail {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[TradeOrderDetailViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (BOOL)haveETHTokenAssetNum:(NSString *)tokenName {
    __block BOOL haveEthAssetNum = NO;
    if (!_ethSource) {
        return haveEthAssetNum;
    }
//    NSArray *ethSource = [kAppD.tabbarC.walletsVC getETHSource];
    [_ethSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Token *model = obj;
        if ([model.tokenInfo.symbol isEqualToString:tokenName]) {
            NSString *ethNum = [model getTokenNum];
            if ([ethNum doubleValue] > 0) {
                haveEthAssetNum = YES;
            }
            *stop = YES;
        }
    }];
    return haveEthAssetNum;
}

- (NSString *)getETHTokenAssetNum:(NSString *)tokenName {
    __block NSString *ethAssetNum = @"0";
    if (!_ethSource) {
        return ethAssetNum;
    }
//    NSArray *ethSource = [kAppD.tabbarC.walletsVC getETHSource];
    [_ethSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Token *model = obj;
        if ([model.tokenInfo.symbol isEqualToString:tokenName]) {
            ethAssetNum = [model getTokenNum];
            *stop = YES;
        }
    }];
    return ethAssetNum;
}

#pragma mark - Request
- (void)requestTokenPrice {
    if (!_selectToken) {
        return;
    }
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency];
    NSDictionary *params = @{@"symbols":@[_selectToken.tokenInfo.symbol],@"coin":coin};
    [RequestService requestWithUrl10:tokenPrice_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.tokenPriceArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
                model.coin = coin;
                [weakself.tokenPriceArr addObject:model];
            }];
            [self refreshGasCost];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
}

#pragma mark - UITextViewDelete
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self checkSendBtnEnable];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)scanAction:(id)sender {
//    kWeakSelf(self);
//    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
//        weakself.sendtoAddressTV.text = codeValue;
//    } needPop:YES];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (IBAction)sendAction:(id)sender {
    if (!_payWalletM) {
        [kAppD.window makeToastDisappearWithText:kLang(@"payment_wallet_is_empty")];
        return;
    }
    if (!_amountTF.text || _amountTF.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_empty")];
        return;
    }
    if (!_sendtoAddressTV.text || _sendtoAddressTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"eth_wallet_address_is_empty")];
        return;
    }
    if ([_amountTF.text doubleValue] == 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_zero")];
        return;
    }
    if ([_amountTF.text doubleValue] > [[_selectToken getTokenNum] doubleValue]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"balance_is_not_enough")];
        return;
    }
    if (![self haveETHTokenAssetNum:@"ETH"]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"wallet_have_not_balance_of"),@"ETH"]];
        return;
    }
    if ([_gasCostETH doubleValue] > [[self getETHTokenAssetNum:@"ETH"] doubleValue]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@(ETH)",kLang(@"balance_is_not_enough")]];
        return;
    }
    
    // 检查地址有效性
    BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:_sendtoAddressTV.text];
    if (!isValid) {
        [kAppD.window makeToastDisappearWithText:kLang(@"eth_wallet_address_is_invalidate")];
        return;
    }
    
    if (![self haveETHTokenAssetNum:_selectToken.tokenInfo.symbol]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"wallet_have_not_balance_of"),_selectToken.tokenInfo.symbol]];
        return;
    }
    
    [self showETHTransferConfirmView];
}

- (IBAction)gasDetailAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _gasDetailHeight.constant = sender.selected?143:0;
}


- (IBAction)sliderAction:(UISlider *)sender {
    [self refreshGasCost];
}

- (IBAction)showCurrencyAction:(id)sender {
    if (!_payWalletM) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_choose_wallet_first")];
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    if (!_ethSource) {
        return;
    }
//    NSArray *sourceArr = [kAppD.tabbarC.walletsVC getETHSource];
    [_ethSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[Token class]]) {
            return;
        }
        Token *model = obj;
        if ([model.tokenInfo.symbol isEqualToString:weakself.inputPayToken]) {
            UIAlertAction *alert = [UIAlertAction actionWithTitle:model.tokenInfo.symbol style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakself.selectToken = model;
                [weakself refreshView];
            }];
            [alertC addAction:alert];
            *stop = YES;
        }
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)showPayWalletAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeETH;
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.payWalletM = model;
        weakself.payWalletNameLab.text = model.name;
        weakself.payWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        
//        [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
        [TokenListHelper requestETHAssetWithAddress:model.address?:@"" tokenName:weakself.inputPayToken?:@"" completeBlock:^(ETHAddressInfoModel * _Nonnull infoM, Token * _Nonnull tokenM, Token * _Nonnull ethTokenM, BOOL success) {
            weakself.ethSource = infoM.tokens;
            weakself.ethToken = ethTokenM;
            weakself.selectToken = tokenM;
            if (!weakself.selectToken) {
                [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"current_eth_wallet_have_not"),weakself.inputPayToken]];
                return;
            }

            [weakself refreshView];
            [weakself checkSendBtnEnable];
        }];
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Noti
//- (void)updateTokenNoti:(NSNotification *)noti {
//    // 判断ETH钱包的USDT asset
//    _selectToken = [kAppD.tabbarC.walletsVC getETHAsset:_inputPayToken];
//    if (!_selectToken) {
//        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"current_eth_wallet_have_not"),_inputPayToken]];
//        return;
//    }
//
//    [self refreshView];
//}


@end
