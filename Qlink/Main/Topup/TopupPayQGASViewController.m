//
//  ETHTransferViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "TopupPayQGASViewController.h"
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
//#import "TradeOrderDetailViewController.h"
#import "QlinkTabbarViewController.h"
#import "WalletsViewController.h"
#import "QNavigationController.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "TopupConstants.h"
#import "TopupOrderModel.h"
#import "TopupProductModel.h"
#import "MyTopupOrderViewController.h"
#import "TopupWebViewController.h"

@interface TopupPayQGASViewController () <UITextViewDelegate, UITextFieldDelegate>

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

@implementation TopupPayQGASViewController

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
    NSString *symbolStr = @"QGAS";
    NSString *balanceStr = [NSString stringWithFormat:@"%@: 0 QGAS",kLang(@"balance")];
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
    BOOL workInLocal = NO;
    BOOL isMainNetwork = [ConfigUtil isMainNetOfServerNetwork];
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___") userInteractionEnabled:NO hideTime:0];
    kWeakSelf(self);
    [[QLCWalletManage shareInstance] sendAssetWithTokenName:tokenName to:to amount:amount sender:sender receiver:receiver message:message isMainNetwork:isMainNetwork workInLocal:workInLocal successHandler:^(NSString * _Nullable responseObj) {
        [kAppD.window hideToast];
//        [kAppD.window makeToastDisappearWithText:kLang(@"transfer_successful")];
//        [weakself backToRoot];
        [kAppD.window makeToastInView:kAppD.window text:kLang(@"qgas_has_been_paid_successfully_Please_wait_for_a_moment") userInteractionEnabled:NO hideTime:0];
        NSString *txid = responseObj;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
            [weakself requestTopup_order:txid];
        });
    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
        [kAppD.window hideToast];
    }];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)showNotEnoughOfBalance {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:kLang(@"insufficient_balance_go_to_otc_page_to_purchase_qgas") preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakself backToRoot];
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"purchase") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [kAppD jumpToOTC];
    }];
    [alertC addAction:alertBuy];
    [self presentViewController:alertC animated:YES completion:nil];
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

- (void)requestTopup_order:(NSString *)txid {
    kWeakSelf(self);
    NSString *account = @"";
    UserModel *userM = [UserModel fetchUserOfLogin];
    if ([UserModel haveLoginAccount]) {
        account = userM.account;
    }
    NSString *p2pId = [UserModel getTopupP2PId];
    NSString *productId = _inputProductM.ID?:@"";
    NSString *areaCode = _inputAreaCode?:@"";
    NSString *phoneNumber = _inputPhoneNumber?:@"";
    NSString *amount = [NSString stringWithFormat:@"%@",_inputProductM.amount];
    NSDictionary *params = @{@"account":account,@"p2pId":p2pId,@"productId":productId,@"areaCode":areaCode,@"phoneNumber":phoneNumber,@"amount":amount,@"txid":txid?:@""};
//    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_order_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            TopupOrderModel *model = [TopupOrderModel getObjectWithKeyValues:responseObject[@"order"]];
            
            if ([model.status isEqualToString:Topup_Order_Status_New]) { // 跳转订单列表
                [weakself jumpToMyTopupOrder];
            } else if ([model.status isEqualToString:Topup_Order_Status_QGAS_PAID]) { // 跳转h5购买
                // @"https://shop.huagaotx.cn/wap/charge_v3.html?sid=8a51FmcnWGH-j2F-g9Ry2KT4FyZ_Rr5xcKdt7i96&trace_id=mm_1000001_998902&package=0&mobile=15989246851"
                NSString *sid = Topup_Pay_H5_sid;
                NSString *trace_id = [NSString stringWithFormat:@"%@_%@_%@",Topup_Pay_H5_trace_id,model.userId?:@"",model.ID?:@""];
                NSString *package = [NSString stringWithFormat:@"%@",weakself.inputProductM.amount];
                NSString *mobile = weakself.inputPhoneNumber;
                NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@?sid=%@&trace_id=%@&package=%@&mobile=%@",Topup_Pay_H5_Url,sid,trace_id,package,mobile];
                [weakself jumpToTopupH5:urlStr];
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
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
//        [kAppD.window makeToastDisappearWithText:kLang(@"balance_is_not_enough")];
        [self showNotEnoughOfBalance];
        return;
    }
    
    // 检查地址有效性
    BOOL validateAddress = [QLCWalletManage.shareInstance walletAddressIsValid:_sendtoAddressTV.text];
    if (!validateAddress) {
        [kAppD.window makeToastDisappearWithText:kLang(@"qlc_wallet_address_is_invalidate")];
        return;
    }
    
    if (![self haveQLCTokenAssetNum:_selectAsset.tokenName]) {
//        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"wallet_have_not_balance_of"),_selectAsset.tokenName]];
        [self showNotEnoughOfBalance];
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

#pragma mark - Transition
- (void)jumpToTopupH5:(NSString *)urlStr {
    TopupWebViewController *vc = [TopupWebViewController new];
    vc.inputUrl = urlStr;
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
//    NSURL *url = [NSURL URLWithString:@"https://shop.huagaotx.cn/wap/charge_v3.html?sid=8a51FmcnWGH-j2F-g9Ry2KT4FyZ_Rr5xcKdt7i96&trace_id=mm_1000001_998902&package=0&mobile=15989246851"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        [self backToRoot];
    }
    
}

- (void)jumpToMyTopupOrder {
    MyTopupOrderViewController *vc = [MyTopupOrderViewController new];
    vc.inputBackToRoot = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
