//
//  ETHTransferViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "PayNEOViewController.h"
#import "NEOTransferConfirmView.h"
#import "UITextView+ZWPlaceHolder.h"
#import "WalletCommonModel.h"
#import "NEOAddressInfoModel.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import <ETHFramework/ETHFramework.h>
#import "NEOWalletUtil.h"
#import "WalletQRViewController.h"
#import "Qlink-Swift.h"
#import "QlinkTabbarViewController.h"
#import "WalletsViewController.h"
#import "TradeOrderDetailViewController.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "WalletSelectViewController.h"
#import "QNavigationController.h"
//#import "GlobalConstants.h"
#import "ReportUtil.h"
#import <SwiftTheme/SwiftTheme-Swift.h>

@interface PayNEOViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *payWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *payWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *payWalletAddressLab;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *symbolLab;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextView *sendtoAddressTV;
@property (weak, nonatomic) IBOutlet UITextField *memoTF;

@property (nonatomic, strong) NSMutableArray *tokenPriceArr;
@property (nonatomic, strong) NEOAssetModel *selectAsset;
@property (nonatomic, strong) WalletCommonModel *payWalletM;

@end

@implementation PayNEOViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observe
- (void)addObserve {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferSuccess:) name:NEO_Transfer_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTokenNoti:) name:Update_NEO_Wallet_Token_Noti object:nil];
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
    
//    _selectAsset = _inputAsset?:_inputSourceArr?_inputSourceArr.firstObject:nil;
    _tokenPriceArr = [NSMutableArray array];
    
    _sendtoAddressTV.placeholder = kLang(@"neo_wallet_address");
    _sendtoAddressTV.text = _sendToAddress;
    _amountTF.text = _sendAmount;
    _memoTF.text = _sendMemo;
    
    _sendBtn.userInteractionEnabled = NO;
    [_amountTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    _sendtoAddressTV.delegate = self;
    
    [self refreshView];
}

- (void)refreshView {
    NSString *symbolStr = @"NEO";
    NSString *balanceStr = [NSString stringWithFormat:@"%@: 0 NEO",kLang(@"balance")];
    if (_selectAsset) {
        balanceStr = [NSString stringWithFormat:@"%@: %@ %@",kLang(@"balance"),[_selectAsset getTokenNum],_selectAsset.asset_symbol];
        symbolStr = _selectAsset.asset_symbol;
    }
    _balanceLab.text = balanceStr;
    _symbolLab.text = symbolStr;
    
    [self requestTokenPrice];
}

- (void)showNEOTransferConfirmView {
    NSString *address = _sendtoAddressTV.text;
    NSString *amount = [NSString stringWithFormat:@"%@ %@",_amountTF.text,_selectAsset.asset_symbol];
    NEOTransferConfirmView *view = [NEOTransferConfirmView getInstance];
    [view configWithAddress:address amount:amount];
    kWeakSelf(self);
    view.confirmBlock = ^{
        [weakself sendTransfer];
    };
    [view show];
}

- (void)checkSendBtnEnable {
    if (_sendtoAddressTV.text && _sendtoAddressTV.text.length > 0 && _amountTF.text && _amountTF.text.length > 0 && _payWalletM != nil) {
//        [_sendBtn setBackgroundColor:MAIN_BLUE_COLOR];
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

- (void)sendTransfer {
    NSInteger decimals = [NEO_Decimals integerValue];
    NSString *tokenHash = _selectAsset.asset_hash;
    NSString *assetName = _selectAsset.asset;
    NSString *toAddress = _sendtoAddressTV.text;
    NSString *amount = _amountTF.text;
    NSString *symbol = _selectAsset.asset_symbol;
    NSString *fromAddress = [WalletCommonModel getCurrentSelectWallet].address;
    NSString *remarkStr = _memoTF.text;
    NSInteger assetType = 1; // 0:neo、gas  1:代币
    if ([symbol isEqualToString:@"GAS"] || [symbol isEqualToString:@"NEO"]) {
        assetType = 0;
    }
    BOOL isNEOMainNetTransfer = YES;
    double fee = NEO_fee;
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window text:NSStringLocalizable(@"loading")];
    [NEOWalletUtil sendNEOWithTokenHash:tokenHash decimals:decimals assetName:assetName amount:amount toAddress:toAddress fromAddress:fromAddress symbol:symbol assetType:assetType mainNet:isNEOMainNetTransfer remarkStr:remarkStr fee:fee successBlock:^(NSString *txid) {
        [kAppD.window hideToast];
//        [kAppD.window makeToastDisappearWithText:kLang(@"send_success")];
//        NSString *blockChain = @"ETH";
//        [ReportUtil requestWalletReportWalletRransferWithAddressFrom:fromAddress addressTo:toAddress blockChain:blockChain symbol:symbol amount:amount txid:txId?:@""]; // 上报钱包转账
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestTrade_buyer_confirm:txid]; // 买家确认支付
        });
    } failureBlock:^{
        [kAppD.window hideToast];
    }];
}

- (void)requestTrade_buyer_confirm:(NSString *)txid {
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
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:trade_buyer_confirm_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            if (weakself.transferToRoot) {
                [weakself backToRoot];
            } else if (weakself.transferToTradeDetail) {
                [weakself backToTradeDetail];
            } else {
                [weakself backAction:nil];
            }
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
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

- (BOOL)haveNEOTokenAssetNum:(NSString *)tokenName {
    __block BOOL haveAssetNum = NO;
    NSArray *source = [kAppD.tabbarC.walletsVC getNEOSource];
    [source enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOAssetModel *model = obj;
        if ([model.asset_symbol isEqualToString:tokenName]) {
            NSString *num = [model getTokenNum];
            if ([num doubleValue] > 0) {
                haveAssetNum = YES;
            }
            *stop = YES;
        }
    }];
    return haveAssetNum;
}

#pragma mark - Request
- (void)requestTokenPrice {
    if (!_selectAsset) {
        return;
    }
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency];
    NSDictionary *params = @{@"symbols":@[_selectAsset.asset_symbol],@"coin":coin};
    [RequestService requestWithUrl5:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.tokenPriceArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
                model.coin = coin;
                [weakself.tokenPriceArr addObject:model];
            }];
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
        [kAppD.window makeToastDisappearWithText:kLang(@"neo_wallet_address_is_empty")];
        return;
    }
    if ([_amountTF.text doubleValue] == 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_zero")];
        return;
    }
    if ([_amountTF.text doubleValue] > [[_selectAsset getTokenNum] doubleValue]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"balance_is_not_enough")];
        return;
    }
    
    // 检查地址有效性
    BOOL validateNEOAddress = [NEOWalletManage.sharedInstance validateNEOAddressWithAddress:_sendtoAddressTV.text];
    if (!validateNEOAddress) {
        [kAppD.window makeToastDisappearWithText:kLang(@"neo_wallet_address_is_invalidate")];
        return;
    }
    
//    // 转QLC需要gas检查
//    if ([_selectAsset.asset_symbol isEqualToString:@"QLC"]) {
//        __block NSNumber *gas = @(0);
//        NSArray *sourceArr = [kAppD.tabbarC.walletsVC getNEOSource];
//        [sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NEOAssetModel *asset = obj;
//            if ([asset.asset_symbol isEqualToString:@"GAS"]) {
//                gas = asset.amount;
//            }
//        }];
//        if (([gas doubleValue] < GAS_Control)) {
//            [kAppD.window showWalletAlertViewWithTitle:NSStringLocalizable(@"prompt") msg:[[NSMutableAttributedString alloc] initWithString:NSStringLocalizable(@"neo_nep5_gas_less")] isShowTwoBtn:NO block:^{
//            }];
//            return;
//        }
//    }
    
    if (![self haveNEOTokenAssetNum:_selectAsset.asset_symbol]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"wallet_have_not_balance_of"),_selectAsset.asset_symbol]];
        return;
    }
    
    [self showNEOTransferConfirmView];
}

- (IBAction)showCurrencyAction:(id)sender {
    if (!_payWalletM) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_choose_wallet_first")];
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    NSArray *sourceArr = [kAppD.tabbarC.walletsVC getNEOSource];
    [sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NEOAssetModel *model = obj;
        if ([model.asset_symbol isEqualToString:weakself.inputPayToken]) {
            UIAlertAction *alert = [UIAlertAction actionWithTitle:model.asset_symbol style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakself.selectAsset = model;
                [weakself refreshView];
            }];
            [alertC addAction:alert];
            *stop = YES;
        }
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)showPayWalletAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeNEO;
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.payWalletM = model;
        weakself.payWalletNameLab.text = model.name;
        weakself.payWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
        [weakself checkSendBtnEnable];
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Noti
//- (void)transferSuccess:(NSNotification *)noti {
//    [self backToRoot];
//}

- (void)updateTokenNoti:(NSNotification *)noti {
    _selectAsset = [kAppD.tabbarC.walletsVC getNEOAsset:_inputPayToken];
    if (!_selectAsset) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"current_neo_wallet_have_not"),_inputPayToken]];
        return;
    }
    
    [self refreshView];
}

@end
