//
//  MyOrderDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TradeOrderDetailViewController.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "TradeOrderInfoModel.h"
//#import "WalletCommonModel.h"
//#import <ETHFramework/ETHFramework.h>
//#import "ETHTransferConfirmView.h"
//#import "ETHAddressInfoModel.h"
//#import "QlinkTabbarViewController.h"
//#import "WalletsViewController.h"
//#import "ReportUtil.h"
#import "PayReceiveAddressViewController.h"
#import "TradeIDInputView.h"
#import "SuccessTipView.h"
#import "FailTipView.h"
#import "ComplaintSubmitViewController.h"
#import "ComplaintDetailViewController.h"


//#import "GlobalConstants.h"

@interface TradeOrderDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UIView *statusBack;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusSubTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeUnitLab;
@property (weak, nonatomic) IBOutlet UILabel *buyOrSellLab;
@property (weak, nonatomic) IBOutlet UILabel *buyOrSellNameLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *payKeyLab;
@property (weak, nonatomic) IBOutlet UILabel *payValLab;

// Order ID
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderIDHeight; // 56
@property (weak, nonatomic) IBOutlet UILabel *orderIDLab;

// Order Time
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTimeHeight; // 56
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;

// Closing Time
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closingTimeHeight; //56
@property (weak, nonatomic) IBOutlet UILabel *closingTimeLab;

// confirm pay Time
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPayTimeHeight; // 56
@property (weak, nonatomic) IBOutlet UILabel *confirmPayTimeLab;

// appeal Time
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appealTimeHeight; // 56
@property (weak, nonatomic) IBOutlet UILabel *appealTimeLab;

// successful Deal
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *successfulDealHeight; // 56
@property (weak, nonatomic) IBOutlet UILabel *successfulDealLab;

// Order Status
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderStatusHeight; // 56
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;

// address
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoAddressHeight; // 76
@property (weak, nonatomic) IBOutlet UILabel *infoAddressTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *infoAddressLab;

// complaint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *complaintHeight; // 56
@property (weak, nonatomic) IBOutlet UILabel *complaintLab;

// trade ID
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tradeIDHeight; // 76
@property (weak, nonatomic) IBOutlet UILabel *tradeIDLab;


// Bottom
@property (weak, nonatomic) IBOutlet UIButton *revokeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView1Height; // 59
@property (weak, nonatomic) IBOutlet UIView *bottomBack1;
@property (weak, nonatomic) IBOutlet UIButton *iAlreadyPaidBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView2Height; // 59
@property (weak, nonatomic) IBOutlet UIView *bottomBack2;
@property (weak, nonatomic) IBOutlet UIButton *complaintBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmReceiveBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView3Height; // 59
@property (weak, nonatomic) IBOutlet UIView *bottomBack3;
@property (weak, nonatomic) IBOutlet UIButton *viewComplaintBtn;

@property (nonatomic, strong) TradeOrderInfoModel *orderInfoM;
@property (nonatomic, strong) dispatch_source_t countDownTimer;
@property (nonatomic, strong) NSString *serverTime;

// 买单
//@property (nonatomic, strong) Token *usdtAsset;
//@property (nonatomic, strong) NSString *transferUsdtTxid;

// 卖单

@end

@implementation TradeOrderDetailViewController

- (void)dealloc {
    if (_countDownTimer) {
        dispatch_cancel(_countDownTimer);
        _countDownTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestTrade_order_info];
}

#pragma mark - Operation
- (void)configInit {
    _contentBack.hidden = YES;
    _viewComplaintBtn.layer.cornerRadius = 4.0;
    _viewComplaintBtn.layer.masksToBounds = YES;
    _revokeBtn.layer.cornerRadius = 4;
    _revokeBtn.layer.masksToBounds = YES;
    _iAlreadyPaidBtn.layer.cornerRadius = 4;
    _iAlreadyPaidBtn.layer.masksToBounds = YES;
    _payBtn.layer.cornerRadius = 4;
    _payBtn.layer.masksToBounds = YES;
    _complaintBtn.layer.cornerRadius = 4;
    _complaintBtn.layer.masksToBounds = YES;
    _confirmReceiveBtn.layer.cornerRadius = 4;
    _confirmReceiveBtn.layer.masksToBounds = YES;
    
    [_bottomBack1 shadowWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] offset:CGSizeMake(0,-0.5) opacity:1 radius:0];
    [_bottomBack2 shadowWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] offset:CGSizeMake(0,-0.5) opacity:1 radius:0];
    [_bottomBack3 shadowWithColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] offset:CGSizeMake(0,-0.5) opacity:1 radius:0];
}

- (void)refreshView {
    if (_orderInfoM) {
        _contentBack.hidden = NO;
        
        _orderIDHeight.constant = 0; // 56
        _orderTimeHeight.constant = 0; // 56
        _closingTimeHeight.constant = 0; //56
        _confirmPayTimeHeight.constant = 0; // 56
        _appealTimeHeight.constant = 0; // 56
        _successfulDealHeight.constant = 0; // 56
        _orderStatusHeight.constant = 0; // 56
        _infoAddressHeight.constant = 0; // 76
        _complaintHeight.constant = 0; // 56
        _tradeIDHeight.constant = 0; // 76
        _bottomView1Height.constant = 0; // 59
        _bottomBack1.hidden = YES;
        _bottomView2Height.constant = 0; // 59
        _bottomBack2.hidden = YES;
        _bottomView3Height.constant = 0; // 59
        _bottomBack3.hidden = YES;
        
        UserModel *loginM = [UserModel fetchUserOfLogin];
        BOOL i_am_Buyer = [loginM.ID isEqualToString:_orderInfoM.buyerId]?YES:NO;
        if ([_orderInfoM.status isEqualToString:ORDER_STATUS_TRADE_TOKEN_PENDING]) { // 已转交易币 等待转成功
            _statusBack.backgroundColor = UIColorFromRGB(0xFF3669);
            _statusTitleLab.text = kLang(@"transaction_pending");
            _statusSubTitleLab.text = kLang(@"please_be_patient_");
                    
            _orderIDHeight.constant = 56;
            _orderIDLab.text = _orderInfoM.number;
            _orderTimeHeight.constant = 56;
            _orderTimeLab.text = _orderInfoM.orderTime;
            _orderStatusHeight.constant = 56;
            _orderStatusLab.text = kLang(@"waiting_for_buyer_payment");
//            if (i_am_Buyer) {
//                _bottomView1Height.constant = 59;
//                _bottomBack1.hidden = NO;
//            }
        } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_QGAS_TO_PLATFORM]) { // 未支付USDT
            _statusBack.backgroundColor = UIColorFromRGB(0xFF3669);
            _statusTitleLab.text = kLang(@"waiting_for_buyer_payment");
            _statusSubTitleLab.text = kLang(@"the_order_will_be_closed_automatically____30");
            
            [self requestGetServerTime];
            
            _orderIDHeight.constant = 56;
            _orderIDLab.text = _orderInfoM.number;
            _orderTimeHeight.constant = 56;
            _orderTimeLab.text = _orderInfoM.orderTime;
            _orderStatusHeight.constant = 56;
            _orderStatusLab.text = kLang(@"waiting_for_buyer_payment");
            if (i_am_Buyer) {
                _bottomView1Height.constant = 59;
                _bottomBack1.hidden = NO;
            }
            
        } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PAID] || [_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PENDING]) { // 买家已付款
            _statusBack.backgroundColor = MAIN_BLUE_COLOR;
            
            if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PENDING]) {
                _statusTitleLab.text = kLang(@"waiting_for_public_Chain_confirmation");
                _statusSubTitleLab.text = kLang(@"waiting_for_public_Chain_confirmation");
            } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PAID]) {
                _statusTitleLab.text = kLang(@"waiting_for_seller_confirmation");
                _statusSubTitleLab.text = kLang(@"waiting_for_seller_confirmation");
            }

            _orderIDHeight.constant = 56;
            _orderIDLab.text = _orderInfoM.number;
            _orderTimeHeight.constant = 56;
            _orderTimeLab.text = _orderInfoM.orderTime;
            _confirmPayTimeHeight.constant = 56;
            _confirmPayTimeLab.text = _orderInfoM.buyerConfirmDate;
            _orderStatusHeight.constant = 56;
            if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PENDING]) {
                _orderStatusLab.text = kLang(@"waiting_for_public_Chain_confirmation");
            } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PAID]) {
                _orderStatusLab.text = kLang(@"waiting_for_seller_confirmation");
            }
            
            _infoAddressHeight.constant = 76;
            if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PENDING]) {
                _infoAddressLab.text = _orderInfoM.usdtToAddress;
            } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PAID]) {
                _infoAddressLab.text = _orderInfoM.usdtFromAddress;
            }
            _tradeIDHeight.constant = 76;
            _tradeIDLab.text = _orderInfoM.txid;
            if (i_am_Buyer) { // 买家
                _bottomView3Height.constant = 59;
                _bottomBack3.hidden = NO;
                if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_NO]) {
                    [_viewComplaintBtn setTitle:kLang(@"title_appeal") forState:UIControlStateNormal];
                } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_YES]) {
                    [_viewComplaintBtn setTitle:kLang(@"title_appeal_details") forState:UIControlStateNormal];
                } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_SUCCESS]) {
                    [_viewComplaintBtn setTitle:kLang(@"title_appeal_result") forState:UIControlStateNormal];
                } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_FAIL]) {
                    [_viewComplaintBtn setTitle:kLang(@"title_appeal_result") forState:UIControlStateNormal];
                }
            } else { // 卖家
                if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PENDING]) {
                    _bottomView3Height.constant = 59;
                    _bottomBack3.hidden = NO;
                    if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_NO]) {
                        [_viewComplaintBtn setTitle:kLang(@"title_appeal") forState:UIControlStateNormal];
                    } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_YES]) {
                        [_viewComplaintBtn setTitle:kLang(@"title_appeal_details") forState:UIControlStateNormal];
                    } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_SUCCESS]) {
                        [_viewComplaintBtn setTitle:kLang(@"title_appeal_result") forState:UIControlStateNormal];
                    } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_FAIL]) {
                        [_viewComplaintBtn setTitle:kLang(@"title_appeal_result") forState:UIControlStateNormal];
                    }
                } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PAID]) {
                    _bottomView2Height.constant = 59;
                    _bottomBack2.hidden = NO;
                    if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_NO]) {
                        [_complaintBtn setTitle:kLang(@"title_appeal") forState:UIControlStateNormal];
                    } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_YES]) {
                        [_complaintBtn setTitle:kLang(@"title_appeal_details") forState:UIControlStateNormal];
                    } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_SUCCESS]) {
                        [_complaintBtn setTitle:kLang(@"title_appeal_result") forState:UIControlStateNormal];
                    } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_FAIL]) {
                        [_complaintBtn setTitle:kLang(@"title_appeal_result") forState:UIControlStateNormal];
                    }
                }
            }
        } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_QGAS_PAID]) { // 订单已完成
            _statusBack.backgroundColor = UIColorFromRGB(0x4ACCAF);
            
            _orderIDHeight.constant = 56;
            _orderIDLab.text = _orderInfoM.number;
            _orderTimeHeight.constant = 56;
            _orderTimeLab.text = _orderInfoM.orderTime;
            _confirmPayTimeHeight.constant = 56;
            _confirmPayTimeLab.text = _orderInfoM.buyerConfirmDate;
            if (![_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_NO]) {
                _appealTimeHeight.constant = 56;
                _appealTimeLab.text = _orderInfoM.appealDate;
            }
            _successfulDealHeight.constant = 56;
            _successfulDealLab.text = _orderInfoM.sellerConfirmDate;
            _orderStatusHeight.constant = 56;
            _orderStatusLab.text = kLang(@"successful_deal");
            _infoAddressHeight.constant = 76;
            _infoAddressLab.text = _orderInfoM.usdtFromAddress;
            if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_YES]) {
                _complaintHeight.constant = 56;
                _complaintLab.text = kLang(@"appeal_processing");
            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_SUCCESS]) {
                _complaintHeight.constant = 56;
                _complaintLab.text = kLang(@"successful_appeal");
            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_SUCCESS]) {
                _complaintHeight.constant = 56;
                _complaintLab.text = kLang(@"fail_appeal");
            }
            _tradeIDHeight.constant = 76;
            _tradeIDLab.text = _orderInfoM.txid;
        
            _statusTitleLab.text = kLang(@"successful_deal");
            _statusSubTitleLab.text = kLang(@"successful_deal");
//            _bottomView3Height.constant = 59;
//            _bottomBack3.hidden = NO;
//            if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_NO]) {
//                [_viewComplaintBtn setTitle:title_appeal forState:UIControlStateNormal];
//            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_YES]) {
//                [_viewComplaintBtn setTitle:title_appeal_details forState:UIControlStateNormal];
//            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_SUCCESS]) {
//                [_viewComplaintBtn setTitle:title_appeal_result forState:UIControlStateNormal];
//            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_FAIL]) {
//                [_viewComplaintBtn setTitle:title_appeal_result forState:UIControlStateNormal];
//            }
            
        } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_CANCEL]) { // 取消
            _statusBack.backgroundColor = UIColorFromRGB(0x999999);
            
            _orderIDHeight.constant = 56;
            _orderIDLab.text = _orderInfoM.number;
            _orderTimeHeight.constant = 56;
            _orderTimeLab.text = _orderInfoM.orderTime;
            if (_orderInfoM.closeDate && _orderInfoM.closeDate.length > 0) {
                _closingTimeHeight.constant = 56;
                _closingTimeLab.text = _orderInfoM.closeDate;
            }
            _orderStatusHeight.constant = 56;
            _orderStatusLab.text = kLang(@"revoked");
            if (_orderInfoM.usdtFromAddress && _orderInfoM.usdtFromAddress.length > 0) {
                _infoAddressHeight.constant = 76;
                _infoAddressLab.text = _orderInfoM.usdtFromAddress;
            }
            if (_orderInfoM.txid && _orderInfoM.txid.length > 0) {
                _tradeIDHeight.constant = 76;
                _tradeIDLab.text = _orderInfoM.txid;
            }
            
            _statusTitleLab.text = kLang(@"closed");
            _statusSubTitleLab.text = kLang(@"closed");
            _bottomView3Height.constant = 59;
            _bottomBack3.hidden = NO;
            if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_NO]) {
                [_viewComplaintBtn setTitle:kLang(@"title_appeal") forState:UIControlStateNormal];
            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_YES]) {
                [_viewComplaintBtn setTitle:kLang(@"title_appeal_details") forState:UIControlStateNormal];
            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_SUCCESS]) {
                [_viewComplaintBtn setTitle:kLang(@"title_appeal_result") forState:UIControlStateNormal];
            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_FAIL]) {
                [_viewComplaintBtn setTitle:kLang(@"title_appeal_result") forState:UIControlStateNormal];
            }
        } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_OVERTIME]) { // 订单已关闭
            _statusBack.backgroundColor = UIColorFromRGB(0x999999);
            
            _orderIDHeight.constant = 56;
            _orderIDLab.text = _orderInfoM.number;
            _orderTimeHeight.constant = 56;
            _orderTimeLab.text = _orderInfoM.orderTime;
            if (_orderInfoM.closeDate && _orderInfoM.closeDate.length > 0) {
                _closingTimeHeight.constant = 56;
                _closingTimeLab.text = _orderInfoM.closeDate;
            }
            _orderStatusHeight.constant = 56;
            _orderStatusLab.text = kLang(@"closed");
            if (_orderInfoM.usdtFromAddress && _orderInfoM.usdtFromAddress.length > 0) {
                _infoAddressHeight.constant = 76;
                _infoAddressLab.text = _orderInfoM.usdtFromAddress;
            }
            if (_orderInfoM.txid && _orderInfoM.txid.length > 0) {
                _tradeIDHeight.constant = 76;
                _tradeIDLab.text = _orderInfoM.txid;
            }
            
            _statusTitleLab.text = kLang(@"closed");
            _statusSubTitleLab.text = kLang(@"closed");
            _bottomView3Height.constant = 59;
            _bottomBack3.hidden = NO;
            if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_NO]) {
                [_viewComplaintBtn setTitle:kLang(@"title_appeal") forState:UIControlStateNormal];
            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_YES]) {
                [_viewComplaintBtn setTitle:kLang(@"title_appeal_details") forState:UIControlStateNormal];
            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_SUCCESS]) {
                [_viewComplaintBtn setTitle:kLang(@"title_appeal_result") forState:UIControlStateNormal];
            } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_FAIL]) {
                [_viewComplaintBtn setTitle:kLang(@"title_appeal_result") forState:UIControlStateNormal];
            }
        }
        
        if (i_am_Buyer) {
            _addressTitleLab.text = kLang(@"receive_from");
            _addressLab.text = _orderInfoM.qgasToAddress;
            _typeLab.text = kLang(@"buy");
            _typeUnitLab.text = _orderInfoM.tradeToken;
            _typeLab.textColor = MAIN_BLUE_COLOR;
            _buyOrSellLab.text = kLang(@"seller");
            _buyOrSellNameLab.text = _orderInfoM.showNickName;
            
        } else {
            _addressTitleLab.text = kLang(@"receive_from");
            _addressLab.text = _orderInfoM.usdtToAddress;
            _typeLab.text = kLang(@"sell");
            _typeUnitLab.text = _orderInfoM.tradeToken;
            _typeLab.textColor = UIColorFromRGB(0xFF3669);
            _buyOrSellLab.text = kLang(@"buyer");
            _buyOrSellNameLab.text = _orderInfoM.showNickName;
//            _payKeyLab.text = @"Amount";
//            _payValLab.text = [NSString stringWithFormat:@"%@ QGAS",_orderInfoM.qgasAmount];
//            _payValLab.textColor = MAIN_BLUE_COLOR;
        }
        _payKeyLab.text = kLang(@"amount_price");
        _payValLab.text = [NSString stringWithFormat:@"%@ %@",_orderInfoM.usdtAmount,_orderInfoM.payToken];
        _payValLab.textColor = UIColorFromRGB(0xFF3669);
        _totalLab.text = [NSString stringWithFormat:@"%@ %@",_orderInfoM.qgasAmount,_orderInfoM.tradeToken];
        _unitPriceLab.text = [NSString stringWithFormat:@"%@ %@",_orderInfoM.unitPrice,_orderInfoM.payToken];
    }
}

//- (void)payUSDT {
//    // 判断当前钱包
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    if (!currentWalletM || currentWalletM.walletType != WalletTypeETH) {
//        [kAppD.window makeToastDisappearWithText:@"Please switch to ETH Wallet"];
//        return;
//    }
//
//    // 判断ETH钱包的USDT asset
//    _usdtAsset = [kAppD.tabbarC.walletsVC getUSDTAsset];
//    if (!_usdtAsset) {
//        [kAppD.window makeToastDisappearWithText:@"Current QLC Wallet have not USDT"];
//        return;
//    }
//    if ([[_usdtAsset getTokenNum] floatValue] < [_orderInfoM.usdtAmount floatValue]) {
//        [kAppD.window makeToastDisappearWithText:@"Current ETH Wallet have not enough USDT"];
//        return;
//    }
//
//    // 检查地址有效性
//    BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:_orderInfoM.usdtToAddress];
//    if (!isValid) {
//        [kAppD.window makeToastDisappearWithText:@"ETH Wallet Address is invalidate"];
//        return;
//    }
//
//    [self showETHTransferConfirmView];
//}
//
//- (void)showETHTransferConfirmView {
//    NSString *decimals = ETH_Decimals;
//    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
//    CGFloat gasSlider = 6;
//    CGFloat gasLimit = 60000;
//    NSNumber *ethFloatNum = @(gasSlider*gasLimit*[decimalsNum doubleValue]);
//    NSString *gasCostETH = [NSString stringWithFormat:@"%@",ethFloatNum];
//
//    NSString *address = _orderInfoM.usdtToAddress;
//    NSString *amount = [NSString stringWithFormat:@"%@ USDT",_orderInfoM.usdtAmount];
//    NSString *gasfee = [NSString stringWithFormat:@"%@ ETH",gasCostETH];
//    ETHTransferConfirmView *view = [ETHTransferConfirmView getInstance];
//    [view configWithAddress:address amount:amount gasfee:gasfee];
//    kWeakSelf(self);
//    view.confirmBlock = ^{
//        [weakself sendTransferUSDTWithGasPrice:gasSlider gasLimit:gasLimit];
//    };
//    [view show];
//}
//
//- (void)sendTransferUSDTWithGasPrice:(NSInteger)gasPrice gasLimit:(NSInteger)gasLimit {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    NSString *fromAddress = currentWalletM.address;
//    NSString *contractAddress = _usdtAsset.tokenInfo.address;
//    NSString *toAddress = _orderInfoM.usdtToAddress;
//    NSString *name = _usdtAsset.tokenInfo.name;
//    NSString *symbol = _usdtAsset.tokenInfo.symbol;
//    NSString *amount = _orderInfoM.usdtAmount;
//    NSInteger decimals = [_usdtAsset.tokenInfo.decimals integerValue];
//    NSString *value = @"";
//    BOOL isCoin = NO;
//    kWeakSelf(self);
//    [kAppD.window makeToastInView:kAppD.window];
//    [TrustWalletManage.sharedInstance sendFromAddress:fromAddress contractAddress:contractAddress toAddress:toAddress name:name symbol:symbol amount:amount gasLimit:gasLimit gasPrice:gasPrice decimals:decimals value:value isCoin:isCoin :^(BOOL success, NSString *txId) {
//        [kAppD.window hideToast];
//        if (success) {
//            [kAppD.window makeToastDisappearWithText:@"Pay Success"];
//            NSString *blockChain = @"ETH";
//            [ReportUtil requestWalletReportWalletRransferWithAddressFrom:fromAddress addressTo:toAddress blockChain:blockChain symbol:symbol amount:amount txid:txId?:@""]; // 上报钱包转账
//
//            weakself.transferUsdtTxid = txId;
//        } else {
//            [kAppD.window makeToastDisappearWithText:@"Pay Fail"];
//        }
//    }];
//}

- (void)showTradeIDInputView {
    TradeIDInputView *view = [TradeIDInputView getInstance];
    kWeakSelf(self);
    view.confirmBlock = ^(NSString * _Nonnull txid) {
        [weakself requestTrade_buyer_confirm:txid];
    };
    [view show];
}

- (void)showAlreadyPaySuccessView {
    SuccessTipView *view = [SuccessTipView getInstance];
    [view showWithTitle:kLang(@"successful")];
}

- (void)showAlreadyPayFailView:(NSString *)title {
    FailTipView *view = [FailTipView getInstance];
    [view showWithTitle:title];
}

- (void)startCountDown:(NSTimeInterval)timecount {
    kWeakSelf(self);
    __block NSInteger second = timecount;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _countDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(_countDownTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_countDownTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *str_hour = [NSString stringWithFormat:@"%02ld", second / 3600];
            NSString *str_minute = [NSString stringWithFormat:@"%02ld", (second % 3600) / 60];
            NSString *str_second = [NSString stringWithFormat:@"%02ld", second % 60];
            NSString *strTime = [NSString stringWithFormat:@"%@ %@:%@ %@.", kLang(@"the_order_will_be_closed_automatically_if_no_further_confirmation_within"),str_minute, str_second,kLang(@"minutes")];
            weakself.statusSubTitleLab.text = strTime;
            if (second == 0) {
                dispatch_cancel(weakself.countDownTimer);
                weakself.countDownTimer = nil;
            } else {
                second--;
            }
        });
    });
    dispatch_resume(_countDownTimer);
}

#pragma mark - Request
- (void)requestTrade_order_info {
    if (_countDownTimer) {
        dispatch_cancel(_countDownTimer);
        _countDownTimer = nil;
    }
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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token,@"tradeOrderId":_inputTradeOrderId?:@""}];
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:trade_order_info_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.orderInfoM = [TradeOrderInfoModel getObjectWithKeyValues:responseObject[@"order"]];
            [weakself refreshView];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
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
            [weakself showAlreadyPaySuccessView];
            [weakself requestTrade_order_info];
        } else {
            [weakself showAlreadyPayFailView:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)requestTrade_seller_confirm {
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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token,@"tradeOrderId":_inputTradeOrderId?:@""}];
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:trade_seller_confirm_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself requestTrade_order_info];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)requestTrade_cancel {
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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token,@"tradeOrderId":_inputTradeOrderId?:@""}];
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:trade_cancel_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself requestTrade_order_info];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)requestGetServerTime {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl5:getServerTime_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.serverTime = responseObject[Server_Data][@"sysTime"];
            
            NSDate *date = [NSDate dateFromTime:weakself.orderInfoM.orderTime];
            NSDate *date30min = [date dateByAddingMinutes:30];
            NSDate *dateNow = [NSDate dateFromTime:weakself.serverTime];
            NSTimeInterval countDownSecond = [date30min timeIntervalSinceDate:dateNow];
            if (countDownSecond >= 0) {
                weakself.statusSubTitleLab.text = kLang(@"the_order_will_be_closed_automatically____30");
                [weakself startCountDown:countDownSecond];
            } else {
                weakself.statusSubTitleLab.text = kLang(@"the_order_will_be_closed_automatically____0");
            }
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)iAlreadyPaidAction:(id)sender {
    [self showTradeIDInputView];
}

- (IBAction)payAction:(id)sender {
    if ([_orderInfoM.status isEqualToString:ORDER_STATUS_QGAS_TO_PLATFORM]) { // 未支付USDT
        [self jumpToUSDTAddress:_orderInfoM.usdtToAddress];
    }
    
}

- (IBAction)complaintAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:kLang(@"title_appeal")]) { // 申诉
        [self jumpToComplaintSubmit];
    } else if ([sender.currentTitle isEqualToString:kLang(@"title_appeal_details")]) {
        [self jumpToComplaintDetail];
    } else if ([sender.currentTitle isEqualToString:kLang(@"title_appeal_result")]) {
        [self jumpToComplaintDetail];
    }
}

- (IBAction)confirmReceiveAction:(id)sender {
    if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PENDING]) {
        return;
    }
    [self requestTrade_seller_confirm];
}

- (IBAction)viewComplaintAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:kLang(@"title_appeal")]) { // 申诉
        [self jumpToComplaintSubmit];
    } else if ([sender.currentTitle isEqualToString:kLang(@"title_appeal_details")]) {
        [self jumpToComplaintDetail];
    } else if ([sender.currentTitle isEqualToString:kLang(@"title_appeal_result")]) {
        [self jumpToComplaintDetail];
    }
    
}

- (IBAction)addressCopyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _addressLab.text?:@"";
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

- (IBAction)payCopyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _payValLab.text?:@"";
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

- (IBAction)buyerAddressCopyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _infoAddressLab.text?:@"";
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

- (IBAction)txidCopyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _tradeIDLab.text?:@"";
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

- (IBAction)revokeAction:(id)sender {
    [self requestTrade_cancel];
}


#pragma mark - Transition
- (void)jumpToComplaintDetail {
    ComplaintDetailViewController *vc = [ComplaintDetailViewController new];
    vc.inputTradeOrderId = _inputTradeOrderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToUSDTAddress:(NSString *)usdtAddress {
    PayReceiveAddressViewController *vc = [PayReceiveAddressViewController new];
//    vc.inputAddress = usdtAddress;
//    vc.inputAmount = _orderInfoM.usdtAmount;
//    vc.inputAddressType = PayReceiveAddressTypeUSDT;
    vc.transferToTradeDetail = YES;
    vc.tradeM = _orderInfoM;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToComplaintSubmit {
    ComplaintSubmitViewController *vc = [ComplaintSubmitViewController new];
    vc.inputTradeOrderId = _inputTradeOrderId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
