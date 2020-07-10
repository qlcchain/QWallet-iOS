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
//#import "QlinkTabbarViewController.h"
#import "MainTabbarViewController.h"
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
#import "RLArithmetic.h"
#import "OTCOrderTodo.h"
#import "NSString+Valid.h"
#import "TxidBackUtil.h"
#import "TokenListHelper.h"
#import "FirebaseUtil.h"
#import "NSString+Trim.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"

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
@property (nonatomic, strong) NSString *buyFromAddress;
@property (nonatomic, strong) NSString *buyTxid;
@property (nonatomic, strong) NSString *gasCostETH;
@property (nonatomic, strong) NSMutableArray *tokenPriceArr;

@property (nonatomic, strong) NSMutableArray *sellTokenPriceArr;
@property (nonatomic, strong) NSString *sellGasCostETH;

@property (nonatomic, strong) WalletCommonModel *buy_PayWalletM;
@property (nonatomic, strong) WalletCommonModel *buy_TradeWalletM;
@property (nonatomic, strong) WalletCommonModel *sell_PayWalletM;
@property (nonatomic, strong) WalletCommonModel *sell_TradeWalletM;
@property (nonatomic) BOOL isFirstAppear;
@property (nonatomic, strong) PairsModel *buy_PairsM;
@property (nonatomic, strong) PairsModel *sell_PairsM;

@property (weak, nonatomic) IBOutlet UILabel *gasLimitLab;
@property (weak, nonatomic) IBOutlet UILabel *gascostLab;
@property (weak, nonatomic) IBOutlet UISlider *gasSlider;
@property (weak, nonatomic) IBOutlet UIButton *gasDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gasDetailHeight; // 143
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gasCostHeight; // 48


@property (weak, nonatomic) IBOutlet UILabel *sellGasLimitLab;
@property (weak, nonatomic) IBOutlet UILabel *sellGascostLab;
@property (weak, nonatomic) IBOutlet UISlider *sellGasSlider;
@property (weak, nonatomic) IBOutlet UIButton *sellGasDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellGasDetailHeight; // 143
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellGasCostHeight; // 48


@property (weak, nonatomic) IBOutlet UILabel *lblBuyDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblSellDesc;


@end

@implementation NewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    _gasCostHeight.constant = 0;
    _gasDetailHeight.constant = 0;
    _tokenPriceArr = [NSMutableArray array];
    
    _sellGasCostHeight.constant = 0;
    _sellGasDetailHeight.constant = 0;
    _sellTokenPriceArr = [NSMutableArray array];
    
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
        
        _lblBuyDesc.text = [NSString stringWithFormat:kLang(@"buying_min_desc"),[NSString doubleToString:_buy_PairsM.minTradeTokenAmount]];
        _lblSellDesc.text = [NSString stringWithFormat:kLang(@"buying_min_desc"),[NSString doubleToString:_sell_PairsM.minTradeTokenAmount]];
       
    }
}

- (void) showBuyingDesc
{
    if (_buySegBtn.isSelected) {
         _lblBuyDesc.text = [NSString stringWithFormat:kLang(@"buying_min_desc"),[NSString doubleToString:_buy_PairsM.minTradeTokenAmount]];
    } else {
         _lblSellDesc.text = [NSString stringWithFormat:kLang(@"buying_min_desc"),[NSString doubleToString:_sell_PairsM.minTradeTokenAmount]];
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
        
        [self clearBuyETHCost];
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
        
        [self clearSellETHCost];
    }
}

- (void) clearBuyETHCost
{
    _gasDetailHeight.constant = 0;
    _gasCostHeight.constant = 0;
    _gasSlider.value = ETH_FeeValue;
    [_tokenPriceArr removeAllObjects];
}

- (void) clearSellETHCost
{
    _sellGasCostHeight.constant = 0;
    _sellGasDetailHeight.constant = 0;
    _sellGasSlider.value = ETH_FeeValue;
    [_sellTokenPriceArr removeAllObjects];
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
            [weakself showBuyingDesc];
        }];
        [alertVC addAction:action];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:actionCancel];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
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
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)buy_transfer:(NSString *)fromAddress amountStr:(NSString *)amountStr tokenChain:(NSString *)tokenChain tokenName:(NSString *)tokenName memo:(NSString *)memo {
    kWeakSelf(self);
    if ([tokenChain isEqualToString:QLC_Chain]) {
        [NewOrderQLCTransferUtil transferQLC:fromAddress tokenName:tokenName amountStr:amountStr memo:memo successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下买单
            weakself.buyFromAddress = sendAddress;
            weakself.buyTxid = txid;
            [weakself requestEntrustBuyOrderWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
        }];
    } else if ([tokenChain isEqualToString:NEO_Chain]) {
        [NewOrderNEOTransferUtil transferNEO:fromAddress tokenName:tokenName amountStr:amountStr successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下买单
            weakself.buyFromAddress = sendAddress;
            weakself.buyTxid = txid;
            [weakself requestEntrustBuyOrderWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
        }];
    } else if ([tokenChain isEqualToString:EOS_Chain]) {
        
    } else if ([tokenChain isEqualToString:ETH_Chain]) {
        [NewOrderETHTransferUtil transferETH:fromAddress tokenName:tokenName amountStr:amountStr ethFee:_gasSlider.value successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下买单
            weakself.buyFromAddress = sendAddress;
            weakself.buyTxid = txid;
            [weakself requestEntrustBuyOrderWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
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
            [weakself requestEntrustSellOrderWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
        }];
    } else if ([tokenChain isEqualToString:NEO_Chain]) {
        [NewOrderNEOTransferUtil transferNEO:fromAddress tokenName:tokenName amountStr:amountStr successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
            [weakself requestEntrustSellOrderWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
        }];
    } else if ([tokenChain isEqualToString:EOS_Chain]) {
        
    } else if ([tokenChain isEqualToString:ETH_Chain]) {
        [NewOrderETHTransferUtil transferETH:fromAddress tokenName:tokenName amountStr:amountStr ethFee:_sellGasSlider.value successB:^(NSString * _Nonnull sendAddress, NSString * _Nonnull txid) {
            // 下卖单
            weakself.sellFromAddress = sendAddress;
            weakself.sellTxid = txid;
            [weakself requestEntrustSellOrderWithTokenChain:tokenChain tokenName:tokenName tokenAmount:amountStr];
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

- (void)refreshGasCost {
    NSString *decimals = ETH_Decimals;
    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
//    NSNumber *ethFloatNum = @(_gasSlider.value*[_gasLimitLab.text doubleValue]*[decimalsNum doubleValue]);
    if (_buySegBtn.isSelected) {
        NSString *ethFloatStr = @(_gasSlider.value).mul(_gasLimitLab.text).mul(decimalsNum);
            _gasCostETH = [NSString stringWithFormat:@"%@",ethFloatStr];
            __block NSString *price = @"";
            [_tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = obj;
                if ([model.symbol isEqualToString:@"ETH"]) {
        //            NSNumber *priceNum = @([_gasCostETH doubleValue]*[model.price doubleValue]);
        //            price = [NSString stringWithFormat:@"%@",priceNum];
                    price = _gasCostETH.mul(model.price);
                    *stop = YES;
                }
            }];
            _gascostLab.text = [NSString stringWithFormat:@"%@ ETH ≈ %@%@",_gasCostETH,[ConfigUtil getLocalUsingCurrencySymbol],price];
    } else {
        NSString *ethFloatStr = @(_sellGasSlider.value).mul(_sellGasLimitLab.text).mul(decimalsNum);
            _sellGasCostETH = [NSString stringWithFormat:@"%@",ethFloatStr];
            __block NSString *price = @"";
            [_sellTokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = obj;
                if ([model.symbol isEqualToString:@"ETH"]) {
        //            NSNumber *priceNum = @([_gasCostETH doubleValue]*[model.price doubleValue]);
        //            price = [NSString stringWithFormat:@"%@",priceNum];
                    price = _sellGasCostETH.mul(model.price);
                    *stop = YES;
                }
            }];
            _sellGascostLab.text = [NSString stringWithFormat:@"%@ ETH ≈ %@%@",_sellGasCostETH,[ConfigUtil getLocalUsingCurrencySymbol],price];
    }
    
}

#pragma mark - Action
- (IBAction)gasDetailAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender == _gasDetailBtn) {
        _gasDetailHeight.constant = sender.selected?143:0;
    } else {
        _sellGasDetailHeight.constant = sender.selected?143:0;
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sliderAction:(UISlider *)sender {
    [self refreshGasCost];
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
            
            // 显示手续费
            if ([_buy_PairsM.payTokenChain isEqualToString:ETH_Chain]) {
                
                [weakself refreshGasCost];
                [weakself requestTokenPrice];
                weakself.gasCostHeight.constant = 48;
            }
            
            

            
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
//            [WalletCommonModel setCurrentSelectWallet:model]; // 切换钱包
            
            // 显示手续费
            if ([_sell_PairsM.tradeTokenChain isEqualToString:ETH_Chain]) {
                [weakself refreshGasCost];
                [weakself requestTokenPrice];
                weakself.sellGasCostHeight.constant = 48;
            }
            
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
    if ([_buyPayUnitTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"unit_price_is_empty")];
        return;
    }
    if ([_buyPayUnitTF.text.trim_whitespace doubleValue] <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"unit_price_needs_greater_than_0")];
        return;
    }
    if ([_buyTradeAmountTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_empty")];
        return;
    }
    if ([_buyVolumeMinAmountTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"min_amount_is_empty")];
        return;
    }
    if ([_buyVolumeMaxAmountTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"max_amount_is_empty")];
        return;
    }
    if ([_buyVolumeMinAmountTF.text.trim_whitespace doubleValue] > [_buyTradeAmountTF.text.trim_whitespace doubleValue]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"buying_amount_need_greater_than_or_equal_to_min_amount")];
        return;
    }
    if ([_buyVolumeMinAmountTF.text.trim_whitespace doubleValue] > [_buyVolumeMaxAmountTF.text.trim_whitespace doubleValue]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"max_amount_need_greater_than_or_equal_to_min_amount")];
        return;
    }
    if ([_buyVolumeMinAmountTF.text.trim_whitespace doubleValue] == 0) {
        
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:kLang(@"the_min_amount_should_be_equal_or_greater_than_1"),_buy_PairsM.minTradeTokenAmount]];
        return;
    }
    if ([_buyTradeTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
        return;
    }
    if ([_buyPayTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
        return;
    }
    if ([_buyVolumeMinAmountTF.text.trim_whitespace doubleValue]*[_buyPayUnitTF.text.trim_whitespace doubleValue] < _buy_PairsM.minPayTokenAmount) {
        [kAppD.window makeToastDisappearWithText:kLang(@"insufficient_amoun")];
        return;
    }
    
    
    // 检查地址有效性
    BOOL validReceiveAddress = [WalletCommonModel validAddress:_buyTradeTF.text.trim_whitespace tokenChain:_buy_PairsM.tradeTokenChain];
    if (!validReceiveAddress) {
        [kAppD.window makeToastDisappearWithText:kLang(@"wallet_address_is_invalidate")];
        return;
    }
    
    if ([_buy_PairsM.tradeToken isEqualToString:@"QGAS"] && [_buyTradeAmountTF.text.trim_whitespace doubleValue] > 1000) { // QGAS总额大于1000的挂单需要进行kyc验证
        UserModel *userM = [UserModel fetchUserOfLogin];
        if (![userM.vStatus isEqualToString:kyc_success]) {
            [self showVerifyTipView];
            return;
        }
    }
    
    NSString *transferAmount = _buyTradeAmountTF.text.trim_whitespace.mul(_buyPayUnitTF.text.trim_whitespace);
    NSString *fromAddress = _buyPayTF.text.trim_whitespace?:@"";
    NSString *memo = [NSString stringWithFormat:@"%@_%@_%@",@"otc",@"entrust",@"buy"];
    [self buy_transfer:fromAddress amountStr:transferAmount tokenChain:_buy_PairsM.payTokenChain tokenName:_buy_PairsM.payToken memo:memo];
//    // 下买单
//    [self requestEntrustBuyOrder];
    
    
    [FirebaseUtil logEventWithItemID:OTC_NewOrder_BUY_Confirm itemName:OTC_NewOrder_BUY_Confirm contentType:OTC_NewOrder_BUY_Confirm];
}

- (IBAction)sellNextAction:(id)sender {
    if ([_sellPayUnitTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"unit_price_is_empty")];
        return;
    }
    if ([_sellPayUnitTF.text.trim_whitespace doubleValue] <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"unit_price_needs_greater_than_0")];
        return;
    }
    if ([_sellTradeAmountTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_empty")];
        return;
    }
    if ([_sellVolumeMinAmountTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"min_amount_is_empty")];
        return;
    }
    if ([_sellVolumeMaxAmountTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"max_amount_is_empty")];
        return;
    }
    if ([_sellVolumeMinAmountTF.text.trim_whitespace doubleValue] > [_sellTradeAmountTF.text.trim_whitespace doubleValue]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"selling_amount_need_greater_than_or_equal_to_min_amount")];
        return;
    }
    if ([_sellVolumeMinAmountTF.text.trim_whitespace doubleValue] > [_sellVolumeMaxAmountTF.text.trim_whitespace doubleValue]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"max_amount_need_greater_than_or_equal_to_min_amount")];
        return;
    }
    if ([_sellVolumeMinAmountTF.text.trim_whitespace doubleValue] == 0) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:kLang(@"the_min_amount_should_be_equal_or_greater_than_1"),_sell_PairsM.minTradeTokenAmount]];
        return;
    }
    if ([_sellTradeAmountTF.text.trim_whitespace doubleValue] < [_sellVolumeMaxAmountTF.text.trim_whitespace doubleValue]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_need_greater_than_or_equal_to_max_amount")];
        return;
    }
    if ([_sellPayAddressTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
        return;
    }
    if ([_sellTradeAddressTF.text.trim_whitespace isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"address_is_empty")];
        return;
    }
    if ([_sellVolumeMinAmountTF.text.trim_whitespace doubleValue]*[_sellPayUnitTF.text.trim_whitespace doubleValue] < _sell_PairsM.minPayTokenAmount) {
        [kAppD.window makeToastDisappearWithText:kLang(@"insufficient_amoun")];
        return;
    }
    
    // 检查地址有效性
    BOOL isValid = [WalletCommonModel validAddress:_sellPayAddressTF.text.trim_whitespace tokenChain:_sell_PairsM.payTokenChain];
    if (!isValid) {
        [kAppD.window makeToastDisappearWithText:kLang(@"eth_wallet_address_is_invalidate")];
        return;
    }
    
    if ([_sell_PairsM.tradeToken isEqualToString:@"QGAS"] && [_sellTradeAmountTF.text.trim_whitespace doubleValue] > 1000) { // QGAS总额大于1000的挂单需要进行kyc验证
        UserModel *userM = [UserModel fetchUserOfLogin];
        if (![userM.vStatus isEqualToString:kyc_success]) {
            [self showVerifyTipView];
            return;
        }
    }
    
    NSString *fromAddress = _sellTradeAddressTF.text.trim_whitespace?:@"";
    NSString *memo = [NSString stringWithFormat:@"%@_%@_%@",@"otc",@"entrust",@"sell"];
    [self sell_transfer:fromAddress amountStr:_sellTradeAmountTF.text.trim_whitespace tokenChain:_sell_PairsM.tradeTokenChain tokenName:_sell_PairsM.tradeToken memo:memo];
    
    
    [FirebaseUtil logEventWithItemID:OTC_NewOrder_SELL_Confirm itemName:OTC_NewOrder_SELL_Confirm contentType:OTC_NewOrder_SELL_Confirm];
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
    
    [self clearBuyETHCost];
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
    
    [self clearSellETHCost];
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
//    if (textField == _buyTradeAmountTF || textField == _buyVolumeMinAmountTF || textField == _buyVolumeMaxAmountTF || textField == _sellTradeAmountTF || textField == _sellVolumeMinAmountTF || textField == _sellVolumeMaxAmountTF) {
//        if (textField.text.length == 0 && [string isEqualToString:@"0"]) { // 首位不为0
//            return NO;
//        }
//
//        return [string isNumber]; // 限制为数字
//    }
    
    if (textField == _buyTradeAmountTF || textField == _buyVolumeMinAmountTF || textField == _buyVolumeMaxAmountTF || textField == _sellTradeAmountTF || textField == _sellVolumeMinAmountTF || textField == _sellVolumeMaxAmountTF || textField == _buyPayUnitTF || textField == _sellPayUnitTF) {
        if (string.length == 0) {
            return YES;
        }
        NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //正则表达式（只支持3位小数）
        NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,3})?$";
       
        if (textField == _buyPayUnitTF) {
            regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,8})?$";
        }
   
        if (textField == _sellPayUnitTF) {
            regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,8})?$";
        }
        
        return [self isValid:checkStr withRegex:regex];
    }
    
    return YES;
}

- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex {
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_buySegBtn.isSelected) {
        if (_buyVolumeMinAmountTF.text.length > 0){
            if ( [_buyVolumeMinAmountTF.text doubleValue] < _buy_PairsM.minTradeTokenAmount) {
                _buyVolumeMinAmountTF.text = [NSString doubleToString:_buy_PairsM.minTradeTokenAmount];
            }
        }
    } else {
        if (_sellVolumeMinAmountTF.text.length > 0){
            if ( [_sellVolumeMinAmountTF.text doubleValue] < _sell_PairsM.minTradeTokenAmount) {
                _sellVolumeMinAmountTF.text = [NSString doubleToString:_sell_PairsM.minTradeTokenAmount];
            }
        }
    }
}


#pragma mark - Request
- (void)requestEntrustBuyOrderWithTokenChain:(NSString *)tokenChain tokenName:(NSString *)tokenName tokenAmount:(NSString *)tokenAmount {
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
    
    NSString *unitPrice = _buyPayUnitTF.text.trim_whitespace?:@"";
    NSString *totalAmount = _buyTradeAmountTF.text.trim_whitespace?:@"";
    NSString *minAmount = _buyVolumeMinAmountTF.text.trim_whitespace?:@"";
    NSString *maxAmount = _buyVolumeMaxAmountTF.text.trim_whitespace?:@"";
    NSString *qgasAddress = _buyTradeTF.text.trim_whitespace?:@"";
    NSString *fromAddress = _buyFromAddress?:@"";
    NSString *txid = _buyTxid?:@"";
    NSString *pairsId = _buy_PairsM.ID?:@"";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"account":account,@"token":token,@"type":@"BUY",@"unitPrice":unitPrice,@"totalAmount":totalAmount,@"minAmount":minAmount,@"maxAmount":maxAmount,@"pairsId":pairsId}];
    [params setObject:qgasAddress forKey:@"qgasAddress"];
    [params setObject:fromAddress forKey:@"fromAddress"];
    [params setObject:txid forKey:@"txid"];
    
    OTCOrder_Entrust_Buy_ParamsModel *paramsM = [OTCOrder_Entrust_Buy_ParamsModel getObjectWithKeyValues:params];
    paramsM.timestamp = timestamp;
    [[OTCOrderTodo shareInstance] savePayOrder_Entrust_Buy:paramsM];
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:entrust_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [[OTCOrderTodo shareInstance] handlerPayOrder_Entrust_Buy_Success:paramsM];
            
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
//            [weakself showSubmitSuccess];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
            
            [FirebaseUtil logEventWithItemID:OTC_Entrust_BUY_Submit_Success itemName:OTC_Entrust_BUY_Submit_Success contentType:OTC_Entrust_BUY_Submit_Success];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
            
            // 上传txid备份
            TxidBackModel *txidBackM = [TxidBackModel new];
            txidBackM.txid = params[@"txid"];
            txidBackM.type = Txid_Backup_Type_ENTRUST_ORDER;
            txidBackM.platform = Platform_iOS;
            txidBackM.chain = tokenChain?:@"";
            txidBackM.tokenName = tokenName?:@"";
            txidBackM.amount = tokenAmount?:@"";
            [TxidBackUtil requestSys_txid_backup:txidBackM completeBlock:^(BOOL success, NSString *msg) {
                if (success) {
                    [[OTCOrderTodo shareInstance] handlerPayOrder_Entrust_Buy_Success:paramsM];
                }
            }];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:error.localizedDescription];
    }];
}



- (void)requestEntrustSellOrderWithTokenChain:(NSString *)tokenChain tokenName:(NSString *)tokenName tokenAmount:(NSString *)tokenAmount {
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
    
    NSString *unitPrice = _sellPayUnitTF.text.trim_whitespace?:@"";
    NSString *totalAmount = _sellTradeAmountTF.text.trim_whitespace?:@"";
    NSString *minAmount = _sellVolumeMinAmountTF.text.trim_whitespace?:@"";
    NSString *maxAmount = _sellVolumeMaxAmountTF.text.trim_whitespace?:@"";
    NSString *usdtAddress = _sellPayAddressTF.text.trim_whitespace?:@"";
    NSString *fromAddress = _sellFromAddress?:@"";
    NSString *txid = _sellTxid?:@"";
    NSString *pairsId = _sell_PairsM.ID?:@"";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"account":account,@"token":token,@"type":@"SELL",@"unitPrice":unitPrice,@"totalAmount":totalAmount,@"minAmount":minAmount,@"maxAmount":maxAmount,@"pairsId":pairsId}];
    [params setObject:usdtAddress forKey:@"usdtAddress"];
    [params setObject:fromAddress forKey:@"fromAddress"];
    [params setObject:txid forKey:@"txid"];
    
    OTCOrder_Entrust_Sell_ParamsModel *paramsM = [OTCOrder_Entrust_Sell_ParamsModel getObjectWithKeyValues:params];
    paramsM.timestamp = timestamp;
    [[OTCOrderTodo shareInstance] savePayOrder_Entrust_Sell:paramsM];
    
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:entrust_order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [[OTCOrderTodo shareInstance] handlerPayOrder_Entrust_Sell_Success:paramsM];
            
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            
//            [weakself showSubmitSuccess];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
            
            [FirebaseUtil logEventWithItemID:OTC_Entrust_SELL_Submit_Success itemName:OTC_Entrust_SELL_Submit_Success contentType:OTC_Entrust_SELL_Submit_Success];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
            
            // 上传txid备份
            TxidBackModel *txidBackM = [TxidBackModel new];
            txidBackM.txid = params[@"txid"];
            txidBackM.type = Txid_Backup_Type_ENTRUST_ORDER;
            txidBackM.platform = Platform_iOS;
            txidBackM.chain = tokenChain?:@"";
            txidBackM.tokenName = tokenName?:@"";
            txidBackM.amount = tokenAmount?:@"";
            [TxidBackUtil requestSys_txid_backup:txidBackM completeBlock:^(BOOL success, NSString *msg) {
                if (success) {
                    [[OTCOrderTodo shareInstance] handlerPayOrder_Entrust_Sell_Success:paramsM];
                }
            }];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)requestTokenPrice {
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency];
    NSDictionary *params = @{@"symbols":@[@"ETH"],@"coin":coin};
    [RequestService requestWithUrl5:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            if (weakself.buySegBtn.isSelected) {
                [weakself.tokenPriceArr removeAllObjects];
            } else {
                [weakself.sellTokenPriceArr removeAllObjects];
            }
            
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TokenPriceModel *model = [TokenPriceModel getObjectWithKeyValues:obj];
                model.coin = coin;
                if (weakself.buySegBtn.isSelected) {
                    [weakself.tokenPriceArr addObject:model];
                } else {
                    [weakself.sellTokenPriceArr addObject:model];
                }
                
            }];
            [self refreshGasCost];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
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
