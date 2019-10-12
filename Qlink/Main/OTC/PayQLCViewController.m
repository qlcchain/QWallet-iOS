//
//  ETHTransferViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "PayQLCViewController.h"
#import "QLCTransferConfirmView.h"
#import "UITextView+ZWPlaceHolder.h"
#import "WalletCommonModel.h"
#import "QLCAddressInfoModel.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import "NEOWalletUtil.h"
#import "WalletQRViewController.h"
#import <QLCFramework/QLCFramework.h>
#import "QLCTokenInfoModel.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "WalletSelectViewController.h"
#import "TradeOrderDetailViewController.h"
#import "QlinkTabbarViewController.h"
#import "WalletsViewController.h"
//#import "GlobalConstants.h"
#import "QNavigationController.h"
#import <SwiftTheme/SwiftTheme-Swift.h>

@interface PayQLCViewController () <UITextViewDelegate, UITextFieldDelegate>

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
@property (nonatomic, strong) QLCTokenModel *selectAsset;
@property (nonatomic, strong) WalletCommonModel *payWalletM;

@end

@implementation PayQLCViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTokenNoti:) name:Update_QLC_Wallet_Token_Noti object:nil];
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
    
    _sendtoAddressTV.placeholder = kLang(@"qlc_wallet_address");
    _sendtoAddressTV.text = _sendToAddress;
    _amountTF.text = _sendAmount;
    _memoTF.text = _sendMemo;
    
    _sendBtn.userInteractionEnabled = NO;
    [_amountTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    _sendtoAddressTV.delegate = self;
    
    [self refreshView];
}

- (void)refreshView {
    NSString *symbolStr = @"QLC";
    NSString *balanceStr = [NSString stringWithFormat:@"%@: 0 QLC",kLang(@"balance")];
    if (_selectAsset) {
        balanceStr = [NSString stringWithFormat:@"%@: %@ %@",kLang(@"balance"),[_selectAsset getTokenNum],_selectAsset.tokenName];
        symbolStr = _selectAsset.tokenName;
    }
    _balanceLab.text = balanceStr;
    _symbolLab.text = symbolStr;
    
    [self requestTokenPrice];
}

- (void)showQLCTransferConfirmView {
    NSString *address = _sendtoAddressTV.text;
    NSString *amount = [NSString stringWithFormat:@"%@ %@",_amountTF.text,_selectAsset.tokenName];
    QLCTransferConfirmView *view = [QLCTransferConfirmView getInstance];
    [view configWithAddress:address amount:amount];
    kWeakSelf(self);
    view.confirmBlock = ^{
        [weakself sendTransfer];
    };
    [view show];
}

- (void)checkSendBtnEnable {
    if (_sendtoAddressTV.text && _sendtoAddressTV.text.length > 0 && _amountTF.text && _amountTF.text.length > 0) {
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
    NSString *tokenName = _selectAsset.tokenName;
    NSString *to = _sendtoAddressTV.text;
    NSUInteger amount = [_selectAsset getTransferNum:_amountTF.text];
//    NSUInteger amount = [_amountTF.text integerValue];
    NSString *sender = nil;
    NSString *receiver = nil;
    NSString *message = nil;
    BOOL workInLocal = YES;
    BOOL isMainNetwork = [ConfigUtil isMainNetOfServerNetwork];
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___") userInteractionEnabled:NO hideTime:0];
    kWeakSelf(self);
    [[QLCWalletManage shareInstance] sendAssetWithTokenName:tokenName to:to amount:amount sender:sender receiver:receiver message:message isMainNetwork:isMainNetwork workInLocal:workInLocal successHandler:^(NSString * _Nullable responseObj) {
//        [kAppD.window hideToast];
//        [kAppD.window makeToastDisappearWithText:kLang(@"transfer_successful")];
//        [weakself backToRoot];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestTrade_buyer_confirm:responseObj]; // 买家确认支付
        });
    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
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

- (BOOL)haveQLCTokenAssetNum:(NSString *)tokenName {
    __block BOOL haveAssetNum = NO;
    NSArray *source = [kAppD.tabbarC.walletsVC getQLCSource];
    [source enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCTokenModel *model = obj;
        if ([model.tokenName isEqualToString:tokenName]) {
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
    NSDictionary *params = @{@"symbols":@[_selectAsset.tokenName],@"coin":coin};
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

#pragma mark - UITextViewDelegete
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self checkSendBtnEnable];
}

#pragma mark - UITextFieldDelegete
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _amountTF) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        NSInteger flag=0;
        const NSInteger limited = [_selectAsset.tokenInfoM.decimals integerValue];//小数点后需要限制的个数
        for (int i = (int)(futureString.length - 1); i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
                if (flag > limited) {
                    return NO;
                }
                break;
            }
            flag++;
        }
    }
    return YES;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)scanAction:(id)sender {
//    kWeakSelf(self);
//    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
//        if (![[QLCWalletManage shareInstance] walletAddressIsValid:codeValue?:@""]) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"invalid_address")];
//            return;
//        }
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
        [kAppD.window makeToastDisappearWithText:kLang(@"qlc_wallet_address_is_empty")];
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
    BOOL validateAddress = [QLCWalletManage.shareInstance walletAddressIsValid:_sendtoAddressTV.text];
    if (!validateAddress) {
        [kAppD.window makeToastDisappearWithText:kLang(@"qlc_wallet_address_is_invalidate")];
        return;
    }
    
    if (![self haveQLCTokenAssetNum:_selectAsset.tokenName]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"wallet_have_not_balance_of"),_selectAsset.tokenName]];
        return;
    }
    
    [self showQLCTransferConfirmView];
}

- (IBAction)showCurrencyAction:(id)sender {
    if (!_payWalletM) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_choose_wallet_first")];
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    NSArray *sourceArr = [kAppD.tabbarC.walletsVC getQLCSource];
    [sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCTokenModel *model = obj;
        if ([model.tokenName isEqualToString:weakself.inputPayToken]) {
            UIAlertAction *alert = [UIAlertAction actionWithTitle:model.tokenName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakself.selectAsset = model;
                [weakself refreshView];
            }];
            [alertC addAction:alert];
            *stop = YES;
        }
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)showPayWalletAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeQLC;
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
    _selectAsset = [kAppD.tabbarC.walletsVC getQLCAsset:_inputPayToken];
    if (!_selectAsset) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"current_qlc_wallet_have_not"),_inputPayToken]];
        return;
    }
    
    [self refreshView];
}

@end
