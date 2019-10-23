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
#import <QLCFramework/QLCFramework.h>
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
#import "PairsModel.h"
//#import "GlobalConstants.h"
#import "NewOrderQLCTransferUtil.h"
#import "NewOrderNEOTransferUtil.h"
#import "NewOrderETHTransferUtil.h"
#import "VerifyTipView.h"
#import "VerificationViewController.h"

@interface NewOrderViewController () <UITextFieldDelegate>

// BUY
@property (weak, nonatomic) IBOutlet UITextField *buyPayUnitTF;
@property (weak, nonatomic) IBOutlet UITextField *buyTradeAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *buyVolumeMinAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *buyVolumeMaxAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *buyTradeTF;
@property (weak, nonatomic) IBOutlet UIButton *buyConfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *buySegBtn;
@property (weak, nonatomic) IBOutlet UIImageView *buyTradeWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *buyTradeWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *buyTradeWalletAddressLab;
@property (weak, nonatomic) IBOutlet UIView *buyTradeWalletBack;
@property (weak, nonatomic) IBOutlet UIView *buyPayWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *buyPayWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *buyPayWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *buyPayWalletAddressLab;
@property (weak, nonatomic) IBOutlet UITextField *buyPayTF;
@property (weak, nonatomic) IBOutlet UILabel *buy_buyingLab;
@property (weak, nonatomic) IBOutlet UILabel *buy_buyingQuantityUnitLab;
@property (weak, nonatomic) IBOutlet UILabel *buy_sellingLab;
@property (weak, nonatomic) IBOutlet UILabel *buy_sellingUnitLab;



// SELL
@property (weak, nonatomic) IBOutlet UITextField *sellPayUnitTF;
@property (weak, nonatomic) IBOutlet UITextField *sellTradeAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *sellVolumeMinAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *sellVolumeMaxAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *sellPayAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *sellTradeAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *sellNextBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellSegBtn;
@property (weak, nonatomic) IBOutlet UIView *sellPayWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *sellPayWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *sellPayWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *sellPayWalletAddressLab;
@property (weak, nonatomic) IBOutlet UIView *sellTradeWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *sellTradeWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *sellTradeWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *sellTradeWalletAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *sell_sellingLab;
@property (weak, nonatomic) IBOutlet UILabel *sell_buyingLab;
@property (weak, nonatomic) IBOutlet UILabel *sell_sellingQuantityLab;
@property (weak, nonatomic) IBOutlet UILabel *sell_buyingUnitLab;


@property (weak, nonatomic) IBOutlet UIView *sliderV;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScorll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentWidth;

@property (nonatomic, strong) NSString *sellFromAddress;
@property (nonatomic, strong) NSString *sellTxid;

@property (nonatomic, strong) WalletCommonModel *buy_PayWalletM;
@property (nonatomic, strong) WalletCommonModel *buy_TradeWalletM;
@property (nonatomic, strong) WalletCommonModel *sell_PayWalletM;
@property (nonatomic, strong) WalletCommonModel *sell_TradeWalletM;
@property (nonatomic) BOOL isFirstAppear;
@property (nonatomic, strong) PairsModel *buy_PairsM;
@property (nonatomic, strong) PairsModel *sell_PairsM;

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
    
    _buyTradeWalletBack.hidden = YES;
    _sellPayWalletBack.hidden = YES;
    _sellTradeWalletBack.hidden = YES;
    _buyPayWalletBack.hidden = YES;

    _scrollContentWidth.constant = 2*SCREEN_WIDTH;
    _sliderV.frame = CGRectMake((SCREEN_WIDTH/2.0-57-(_buySegBtn.width+10)/2.0), _buySegBtn.height, _buySegBtn.width+10, 2);
    
    if (_inputPairsArr && _inputPairsArr.count > 0) {
        _buy_PairsM = _inputPairsArr.firstObject;
        [self clearBuyView];
        _sell_PairsM = _inputPairsArr.firstObject;
        [self clearSellView];
    }
}

- (void)clearBuyView {
    if (_buy_PairsM) {
        _buy_buyingLab.text = _buy_PairsM.tradeToken;
        _buy_buyingQuantityUnitLab.text = _buy_PairsM.tradeToken;
        _buyTradeAmountTF.text = nil;
        _buyVolumeMinAmountTF.text = nil;
        _buyVolumeMaxAmountTF.text = nil;
        _buyPayWalletBack.hidden = YES;
        _buyPayTF.text = nil;
        _buy_PayWalletM = nil;
        
        _buy_sellingLab.text = [NSString stringWithFormat:@"%@/%@",_buy_PairsM.tradeToken,_buy_PairsM.payToken];
        _buy_sellingUnitLab.text = _buy_PairsM.payToken;
        _buyPayUnitTF.text = nil;
        _buyTradeWalletBack.hidden = YES;
        _buyTradeTF.text = nil;
        _buy_TradeWalletM = nil;
    }
}

- (void)clearSellView {
    if (_sell_PairsM) {
        _sell_sellingLab.text = _sell_PairsM.tradeToken;
        _sell_sellingQuantityLab.text = _sell_PairsM.tradeToken;
        _sellTradeAmountTF.text = nil;
        _sellVolumeMinAmountTF.text = nil;
        _sellVolumeMaxAmountTF.text = nil;
        _sellTradeWalletBack.hidden = YES;
        _sellTradeAddressTF.text = nil;
        _sell_TradeWalletM = nil;
        
        _sell_buyingLab.text = [NSString stringWithFormat:@"%@/%@",_sell_PairsM.tradeToken,_sell_PairsM.payToken];
        _sell_buyingUnitLab.text = _sell_PairsM.payToken;
        _sellPayUnitTF.text = nil;
        _sellPayWalletBack.hidden = YES;
        _sellPayAddressTF.text = nil;
        _sell_PayWalletM = nil;
    }
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

- (void)showPairsSheet {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    [_inputPairsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PairsModel *model = obj;
        NSString *title = [NSString stringWithFormat:@"%@/%@",model.tradeToken,model.payToken];
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (weakself.buySegBtn.selected) { // 买
                weakself.buy_PairsM = model;
                [weakself clearBuyView];
            } else { // 卖
                weakself.sell_PairsM = model;
                [weakself clearSellView];
            }
        }];
        [alertVC addAction:action];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:actionCancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showSelectWallet:(NSString *)tokenChain completeB:(void(^)(WalletCommonModel *model))completeB {
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
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
        if (completeB) {
            completeB(model);
        }
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)sell_transfer:(NSString *)amountStr tokenChain:(NSString *)tokenChain tokenName:(NSString *)tokenName {
    kWeakSelf(self);
    if ([tokenChain isEqualToString:QLC_Chain]) {
        [NewOrderQLCTransferUtil transferQLC:tokenName amountStr:amountStr successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
            [weakself requestEntrustSellOrder];
        }];
    } else if ([tokenChain isEqualToString:NEO_Chain]) {
        [NewOrderNEOTransferUtil transferNEO:tokenName amountStr:amountStr successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
            [weakself requestEntrustSellOrder];
        }];
    } else if ([tokenChain isEqualToString:EOS_Chain]) {
        
    } else if ([tokenChain isEqualToString:ETH_Chain]) {
        [NewOrderETHTransferUtil transferETH:tokenName amountStr:amountStr successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
            [weakself requestEntrustSellOrder];
        }];
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

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showQLCAddressAction:(id)sender {
    if (_buy_PairsM) {
        kWeakSelf(self);
        [self showSelectWallet:_buy_PairsM.tradeTokenChain completeB:^(WalletCommonModel *model) {
            weakself.buyTradeWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
            weakself.buyTradeWalletBack.hidden = NO;
            weakself.buy_TradeWalletM = model;
            weakself.buyTradeWalletNameLab.text = model.name;
            weakself.buyTradeWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
            weakself.buyTradeTF.text = model.address;
        }];
    }
}

- (IBAction)showBuyPayAction:(id)sender {
    if (_buy_PairsM) {
        kWeakSelf(self);
        [self showSelectWallet:_buy_PairsM.payTokenChain completeB:^(WalletCommonModel *model) {
            weakself.buyPayWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
            weakself.buyPayWalletBack.hidden = NO;
            weakself.buy_PayWalletM = model;
            weakself.buyPayWalletNameLab.text = model.name;
            weakself.buyPayWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
            weakself.buyPayTF.text = model.address;
        }];
    }
}

- (IBAction)showETHAddressAction:(id)sender {
    if (_sell_PairsM) {
        kWeakSelf(self);
        [self showSelectWallet:_sell_PairsM.payTokenChain completeB:^(WalletCommonModel *model) {
            weakself.sellPayWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
            weakself.sellPayWalletBack.hidden = NO;
            weakself.sell_PayWalletM = model;
            weakself.sellPayWalletNameLab.text = model.name;
            weakself.sellPayWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
            weakself.sellPayAddressTF.text = model.address;
        }];
    }
}

- (IBAction)showSellSendQGasAction:(id)sender {
    if (_sell_PairsM) {
        kWeakSelf(self);
        [self showSelectWallet:_sell_PairsM.tradeTokenChain completeB:^(WalletCommonModel *model) {
            weakself.sellTradeWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
            weakself.sellTradeWalletBack.hidden = NO;
            weakself.sell_TradeWalletM = model;
            weakself.sellTradeWalletNameLab.text = model.name;
            weakself.sellTradeWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
            weakself.sellTradeAddressTF.text = model.address;
            [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
        }];
    }
}

- (IBAction)buySegAction:(id)sender {
    [self refreshSelect:sender];
    [_mainScorll setContentOffset:CGPointMake(SCREEN_WIDTH*0, 0) animated:YES];
}

- (IBAction)sellSegAction:(id)sender {
    [self refreshSelect:sender];
    [_mainScorll setContentOffset:CGPointMake(SCREEN_WIDTH*1, 0) animated:YES];
}

//- (IBAction)createOneNowAction:(id)sender {
//    [self jumpToChooseWallet];
//}

- (IBAction)buyConfirmAction:(id)sender {
    if ([_buyPayUnitTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"unit_price_is_empty")];
        return;
    }
    if ([_buyPayUnitTF.text doubleValue] <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"unit_price_needs_greater_than_0")];
        return;
    }
    if ([_buyTradeAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_empty")];
        return;
    }
    if ([_buyVolumeMinAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"min_amount_is_empty")];
        return;
    }
    if ([_buyVolumeMaxAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"max_amount_is_empty")];
        return;
    }
    if ([_buyTradeTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
        return;
    }
//    if ([_buyPayTF.text isEmptyString]) {
//        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
//        return;
//    }
    
    // 检查地址有效性
    BOOL validReceiveAddress = [WalletCommonModel validAddress:_buyTradeTF.text tokenChain:_buy_PairsM.tradeTokenChain];
    if (!validReceiveAddress) {
        [kAppD.window makeToastDisappearWithText:kLang(@"wallet_address_is_invalidate")];
        return;
    }
    
    if ([_buy_PairsM.tradeToken isEqualToString:@"QGAS"] && [_buyTradeAmountTF.text doubleValue] > 1000) { // QGAS总额大于1000的挂单需要进行kyc验证
        UserModel *userM = [UserModel fetchUserOfLogin];
        if (![userM.vStatus isEqualToString:kyc_success]) {
            [self showVerifyTipView];
            return;
        }
    }
    
    // 下买单
    [self requestEntrustBuyOrder];
}

- (IBAction)sellNextAction:(id)sender {
    if ([_sellPayUnitTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"unit_price_is_empty")];
        return;
    }
    if ([_sellPayUnitTF.text doubleValue] <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"unit_price_needs_greater_than_0")];
        return;
    }
    if ([_sellTradeAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_empty")];
        return;
    }
    if ([_sellVolumeMinAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"min_amount_is_empty")];
        return;
    }
    if ([_sellVolumeMaxAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"max_amount_is_empty")];
        return;
    }
    if ([_sellTradeAmountTF.text doubleValue] < [_sellVolumeMaxAmountTF.text doubleValue]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_need_greater_than_or_equal_to_max_amount")];
        return;
    }
    if ([_sellPayAddressTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
        return;
    }
    if ([_sellTradeAddressTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
        return;
    }
    
    // 检查地址有效性
    BOOL isValid = [WalletCommonModel validAddress:_sellPayAddressTF.text tokenChain:_sell_PairsM.payTokenChain];
    if (!isValid) {
        [kAppD.window makeToastDisappearWithText:kLang(@"eth_wallet_address_is_invalidate")];
        return;
    }
    
    if ([_sell_PairsM.tradeToken isEqualToString:@"QGAS"] && [_sellTradeAmountTF.text doubleValue] > 1000) { // QGAS总额大于1000的挂单需要进行kyc验证
        UserModel *userM = [UserModel fetchUserOfLogin];
        if (![userM.vStatus isEqualToString:kyc_success]) {
            [self showVerifyTipView];
            return;
        }
    }
    
    [self sell_transfer:_sellTradeAmountTF.text tokenChain:_sell_PairsM.tradeTokenChain tokenName:_sell_PairsM.tradeToken];
}

- (IBAction)buyReceiveQgasWalletCloseAction:(id)sender {
    _buy_TradeWalletM = nil;
    _buyTradeWalletBack.hidden = YES;
    _buyTradeTF.text = nil;
}

- (IBAction)buyPayWalletCloseAction:(id)sender {
    _buy_PayWalletM = nil;
    _buyPayWalletBack.hidden = YES;
    _buyPayTF.text = nil;
}

- (IBAction)sellReceiveUsdtWalletCloseAction:(id)sender {
    _sell_PayWalletM = nil;
    _sellPayWalletBack.hidden = YES;
    _sellPayAddressTF.text = nil;
}

- (IBAction)sellSendQgasWalletCloseAction:(id)sender {
    _sell_TradeWalletM = nil;
    _sellTradeWalletBack.hidden = YES;
    _sellTradeAddressTF.text = nil;
}

- (IBAction)buy_buyingAction:(id)sender {
    [self showPairsSheet];
}

//- (IBAction)buy_showSendToWalletAction:(id)sender {
//    if (_buy_PairsM) {
//        kWeakSelf(self);
//        [self showSelectWallet:_buy_PairsM.tradeTokenChain completeB:^(WalletCommonModel *model) {
//            weakself.buy_sendToWalletBack.hidden = NO;
//            weakself.buy_sendToWalletM = model;
//            weakself.buy_sendToWalletNameLab.text = model.name;
//            weakself.buy_sendToWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
//            weakself.buy_sendToWalletTF.text = model.address;
//        }];
//    }
//}
//
//- (IBAction)buy_closeSendToWalletAction:(id)sender {
//    _buy_sendToWalletM = nil;
//    _buy_sendToWalletBack.hidden = YES;
//    _buy_sendToWalletTF.text = nil;
//}

- (IBAction)buy_sellingAction:(id)sender {
    [self showPairsSheet];
}

- (IBAction)sell_sellingAction:(id)sender {
    [self showPairsSheet];
}

- (IBAction)sell_buyingAction:(id)sender {
    [self showPairsSheet];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _buyPayUnitTF || textField == _sellPayUnitTF) {
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
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *unitPrice = _buyPayUnitTF.text?:@"";
    NSString *totalAmount = _buyTradeAmountTF.text?:@"";
    NSString *minAmount = _buyVolumeMinAmountTF.text?:@"";
    NSString *maxAmount = _buyVolumeMaxAmountTF.text?:@"";
    NSString *qgasAddress = _buyTradeTF.text?:@"";
    NSString *pairsId = _buy_PairsM.ID?:@"";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"account":account,@"token":token,@"type":@"BUY",@"unitPrice":unitPrice,@"totalAmount":totalAmount,@"minAmount":minAmount,@"maxAmount":maxAmount,@"pairsId":pairsId}];
    [params setObject:qgasAddress forKey:@"qgasAddress"];
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:entrust_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
//            [weakself showSubmitSuccess];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
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
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *unitPrice = _sellPayUnitTF.text?:@"";
    NSString *totalAmount = _sellTradeAmountTF.text?:@"";
    NSString *minAmount = _sellVolumeMinAmountTF.text?:@"";
    NSString *maxAmount = _sellVolumeMaxAmountTF.text?:@"";
    NSString *usdtAddress = _sellPayAddressTF.text?:@"";
    NSString *fromAddress = _sellFromAddress?:@"";
    NSString *txid = _sellTxid?:@"";
    NSString *pairsId = _sell_PairsM.ID?:@"";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"account":account,@"token":token,@"type":@"SELL",@"unitPrice":unitPrice,@"totalAmount":totalAmount,@"minAmount":minAmount,@"maxAmount":maxAmount,@"pairsId":pairsId}];
    [params setObject:usdtAddress forKey:@"usdtAddress"];
    [params setObject:fromAddress forKey:@"fromAddress"];
    [params setObject:txid forKey:@"txid"];
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:entrust_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            
//            [weakself showSubmitSuccess];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

//- (void)requestQLCTokens {
//    [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
//    [QLCLedgerRpc tokensWithSuccessHandler:^(id _Nullable responseObject) {
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

- (void)jumpToVerification {
    VerificationViewController *vc = [VerificationViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
