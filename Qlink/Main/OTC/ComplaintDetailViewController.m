//
//  MyOrderDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ComplaintDetailViewController.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "TradeOrderInfoModel.h"
#import "PayReceiveAddressViewController.h"
#import "TradeIDInputView.h"
#import "SuccessTipView.h"
#import "FailTipView.h"
#import "ComplaintInfoViewController.h"

@interface ComplaintDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UIView *statusBack;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusSubTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *buyOrSellLab;
@property (weak, nonatomic) IBOutlet UILabel *buyOrSellNameLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *payKeyLab;
@property (weak, nonatomic) IBOutlet UILabel *payValLab;

// Complaint
@property (weak, nonatomic) IBOutlet UILabel *complaintPeopleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *complaintResultHeight; // 64
@property (weak, nonatomic) IBOutlet UILabel *complaintResultLab;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *complaintTipHeight; // 38
//@property (weak, nonatomic) IBOutlet UILabel *complaintTipLab;


// Order ID
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderIDHeight; // 56
@property (weak, nonatomic) IBOutlet UILabel *orderIDLab;

// Order Time
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTimeHeight; // 56
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;

// Order Status
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderStatusHeight; // 56
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;

// address
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoAddressHeight; // 76
@property (weak, nonatomic) IBOutlet UILabel *infoAddressTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *infoAddressLab;

// trade ID
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tradeIDHeight; // 76
@property (weak, nonatomic) IBOutlet UILabel *tradeIDLab;

@property (nonatomic, strong) TradeOrderInfoModel *orderInfoM;

@end

@implementation ComplaintDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestTrade_order_info];
}

#pragma mark - Operation
- (void)configInit {
    _contentBack.hidden = YES;
}

- (void)refreshView {
    if (_orderInfoM) {
        _contentBack.hidden = NO;
        
        _orderIDHeight.constant = 0; // 56
        _orderTimeHeight.constant = 0; // 56
        _orderStatusHeight.constant = 0; // 56
        _infoAddressHeight.constant = 0; // 76
        _tradeIDHeight.constant = 0; // 76
        
        _statusBack.backgroundColor = UIColorFromRGB(0xFF3669);
        _complaintPeopleLab.text = _orderInfoM.buyerConfirmDate.length>0?[NSString stringWithFormat:@"Appeallant：Buyer"]:[NSString stringWithFormat:@"Appeallant：Seller"];
        _complaintResultLab.text = [NSString stringWithFormat:@"Appeal Result：%@",_orderInfoM.auditFeedback?:@""];
        _complaintResultHeight.constant = 64; // 64
        _orderIDHeight.constant = 56;
        _orderIDLab.text = _orderInfoM.number;
        _orderTimeHeight.constant = 56;
        _orderTimeLab.text = _orderInfoM.orderTime;
        _orderStatusHeight.constant = 56;
        _infoAddressHeight.constant = 76;
        _infoAddressLab.text = _orderInfoM.usdtFromAddress;
        _tradeIDHeight.constant = 76;
        _tradeIDLab.text = _orderInfoM.txid;
        if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_NO]) { // 无申诉
            _contentBack.hidden = YES;
        } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_YES]) { // 申诉中
            _statusTitleLab.text = @"Waiting for Appeal Result";
            _statusSubTitleLab.text = _orderInfoM.appealDate;
            
            _complaintResultHeight.constant = 0;
        } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_SUCCESS]) {
            _statusTitleLab.text = @"Successful Appeal";
            _statusSubTitleLab.text = _orderInfoM.appealDate;
            
        } else if ([_orderInfoM.appealStatus isEqualToString:APPEAL_STATUS_FAIL]) {
            _statusTitleLab.text = @"Appeal Failed";
            _statusSubTitleLab.text = _orderInfoM.appealDate;
            
        }
        
        if ([_orderInfoM.status isEqualToString:ORDER_STATUS_QGAS_TO_PLATFORM]) { // 未支付USDT
            _orderStatusLab.text = @"Waiting for Buyer's payment";
        } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PAID] || [_orderInfoM.status isEqualToString:ORDER_STATUS_USDT_PENDING]) { // 买家已付款
            _orderStatusLab.text = @"Waiting for Seller's confirmation";
        } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_QGAS_PAID]) { // 完成
            _orderStatusLab.text = @"Successful Deal";
        } else if ([_orderInfoM.status isEqualToString:ORDER_STATUS_OVERTIME]) { // 超时
            _orderStatusLab.text = @"Closed";
        }
        
        UserModel *loginM = [UserModel fetchUserOfLogin];
        BOOL i_am_buyer = [loginM.ID isEqualToString:_orderInfoM.buyerId];
        if (i_am_buyer) {
            _typeLab.text = @"BUY";
            _buyOrSellLab.text = @"Seller";
            _buyOrSellNameLab.text = _orderInfoM.nickname;
        } else {
            _typeLab.text = @"SELL";
            _buyOrSellLab.text = @"Buyer";
            _buyOrSellNameLab.text = _orderInfoM.nickname;
//            _payKeyLab.text = @"Amount";
//            _payValLab.text = [NSString stringWithFormat:@"%@ QGAS",_orderInfoM.qgasAmount];
//            _payValLab.textColor = MAIN_BLUE_COLOR;
        }
        _payKeyLab.text = @"Amount";
        _payValLab.text = [NSString stringWithFormat:@"%@ USDT",_orderInfoM.usdtAmount];
        _payValLab.textColor = UIColorFromRGB(0xFF3669);
        _totalLab.text = [NSString stringWithFormat:@"%@ QGAS",_orderInfoM.qgasAmount];
        _unitPriceLab.text = [NSString stringWithFormat:@"%@ USDT",_orderInfoM.unitPrice];
    }
}

#pragma mark - Request
- (void)requestTrade_order_info {
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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token,@"tradeOrderId":_inputTradeOrderId?:@""}];
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl:trade_order_info_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
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


#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)payCopyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _payValLab.text?:@"";
    [kAppD.window makeToastDisappearWithText:@"Copied"];
}

- (IBAction)complaintInfoAction:(id)sender {
    [self jumpToComplaintInfo];
}

#pragma mark - Transition
- (void)jumpToComplaintInfo {
    ComplaintInfoViewController *vc = [ComplaintInfoViewController new];
    vc.orderInfoM = _orderInfoM;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
