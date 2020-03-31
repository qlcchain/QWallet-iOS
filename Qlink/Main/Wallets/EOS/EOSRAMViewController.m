//
//  EOSRAMViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/5.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSRAMViewController.h"
#import "EOSSymbolModel.h"
#import "WalletCommonModel.h"
#import "EOSAccountResourceInfoModel.h"
#import "TipOKView.h"
#import "PaymentDetailsView.h"
#import "ODRefreshControl.h"
#import "SuccessTipView.h"
#import "EOSResourcePriceModel.h"
#import "EOSWalletUtil.h"
#import <eosFramework/RegularExpression.h>
#import "NSString+RemoveZero.h"

//#import "GlobalConstants.h"

@interface EOSRAMViewController () {
    NSString *buyEosAmount;
    NSString *buyOrSellFrom;
    NSString *buyOrSellTo;
    NSString *SellBytes;
    EOSOperationType buyOrSellOperationType;
}

@property (weak, nonatomic) IBOutlet UILabel *ramAvailableLab;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLab;
@property (weak, nonatomic) IBOutlet UIImageView *buyIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sellIcon;
@property (weak, nonatomic) IBOutlet UILabel *inputKeyLab;
@property (weak, nonatomic) IBOutlet UILabel *eosBalanceLab;
@property (weak, nonatomic) IBOutlet UITextField *inputAmountTF;

@property (weak, nonatomic) IBOutlet UITextField *recipientAccountTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *purchaseTipHeight; // 15
@property (weak, nonatomic) IBOutlet UIButton *doBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) EOSAccountResourceInfoModel *resourceInfoM;
@property (nonatomic, strong) EOSResourcePriceModel *resourcePriceM;
@property (nonatomic) BOOL isBuy;

@end

@implementation EOSRAMViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyRamSuccess:) name:EOS_BuyRam_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyRamFail:) name:EOS_BuyRam_Fail_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sellRamSuccess:) name:EOS_SellRam_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sellRamFail:) name:EOS_SellRam_Fail_Noti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self addObserve];
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    [_doBtn cornerRadius:4];
}

- (void)configInit {
    [self refreshControlInit];
    
    [self buySelectAction:nil];
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    _recipientAccountTF.text = currentWalletM.account_name?:@"";
    
    [self requestRefresh];
}

- (void)requestRefresh {
    [self requestEOSGetAccountResourceInfo];
    
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestEosEos_resource_price]; // 刷新当前价格
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestEOSTokenBalance]; // 刷新当前余额
    });
}

- (void)refreshControlInit {
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_scrollView];
    _refreshControl.tintColor = SRREFRESH_BACK_COLOR;
    //    _refreshControl.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _refreshControl.activityIndicatorViewColor = SRREFRESH_BACK_COLOR;
    [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl {
    [self requestRefresh];
}

- (void)refreshAvailableWithModel:(EOSAccountResourceInfoModel *)model {
    NSNumber *availableNum = @([model.ram.available doubleValue]-[model.ram.used doubleValue]);
    _ramAvailableLab.text = [NSString stringWithFormat:@"%@ %@ / %@ KB",([availableNum doubleValue]>=1024?@([availableNum doubleValue]/1024):availableNum).show4floatStr,[availableNum doubleValue]>=1024?@"KB":@"Bytes",@([model.ram.available doubleValue]/1024).show4floatStr];
}

- (void)refreshCurrenPriceWithModel:(EOSResourcePriceModel *)model {
    _currentPriceLab.text = [NSString stringWithFormat:@"%@ %@",model.ramPrice.show4floatStr,model.ramPriceUnit];
}

- (void)refreshEosBalance {
    if (_isBuy) {
        _eosBalanceLab.text = [NSString stringWithFormat:@"%@:%@ EOS",kLang(@"balance"),_inputSymbolM.balance];
    }
}

- (void)showInsufficientResources {
    TipOKView *view = [TipOKView getInstance];
    view.okBlock = ^{
    };
    [view showWithTitle:kLang(@"insufficient_resources")];
}

- (void)showPayDetailsViewWithPayInfo:(NSString *)payInfo amount:(NSString *)amount key1:(NSString *)key1 val1:(NSString *)val1 key2:(NSString *)key2 val2:(NSString *)val2 {
    PaymentDetailsView *view = [PaymentDetailsView getInstance];
    kWeakSelf(self)
    view.nextBlock = ^{
        [weakself buyOrSellRam];
    };
    [view configWithPayInfo:payInfo amount:amount key1:key1 val1:val1 key2:key2 val2:val2];
    [view show];
}

- (void)buyOrSellRam {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    buyOrSellFrom = currentWalletM.account_name?:@"";
    
    [EOSWalletUtil.shareInstance stakeWithEosAmount:buyEosAmount from:buyOrSellFrom to:buyOrSellTo bytes:SellBytes operationType:buyOrSellOperationType]; // buy/sell ram
}

- (void)showSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:kLang(@"success")];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Request
- (void)requestEOSGetAccountResourceInfo {
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window];
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    NSDictionary *params = @{@"account":currentWalletM.account_name?:@""};
    [RequestService requestWithUrl5:eosGet_account_resource_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data][Server_Data];
            weakself.resourceInfoM = [EOSAccountResourceInfoModel getObjectWithKeyValues:dic];
            [weakself refreshAvailableWithModel:weakself.resourceInfoM];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

- (void)requestEosEos_resource_price {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [RequestService requestWithUrl5:eosEos_resource_price_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data];
            weakself.resourcePriceM = [EOSResourcePriceModel getObjectWithKeyValues:dic];
            [weakself refreshCurrenPriceWithModel:weakself.resourcePriceM];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestEOSTokenBalance {
    kWeakSelf(self);
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    NSDictionary *params = @{@"account":currentWalletM.account_name?:@"", @"symbol":@"EOS"};
    [RequestService requestWithUrl5:eosGet_token_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data][Server_Data];
            NSArray *symbol_list = dic[@"symbol_list"];
            __block NSNumber *eosBalance = @(0);
            NSMutableArray *symbolListArr = [NSMutableArray array];
            [symbol_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EOSSymbolModel *model = [EOSSymbolModel getObjectWithKeyValues:obj];
                [symbolListArr addObject:model];
                if ([model.symbol isEqualToString:@"EOS"]) { // 赋值EOS余额
                    eosBalance = model.balance;
                }
            }];
            weakself.inputSymbolM.balance = eosBalance;
            [weakself refreshEosBalance];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buySelectAction:(id)sender {
    _isBuy = YES;
    [_doBtn setTitle:@"Buy" forState:UIControlStateNormal];
    _buyIcon.image = [UIImage imageNamed:@"icon_selected_purple"];
    _sellIcon.image = [UIImage imageNamed:@"icon_unselected_purple"];
    _purchaseTipHeight.constant = 15;
    _inputKeyLab.text = @"Purchase Amount";
    _inputAmountTF.placeholder = @"Input EOS Amount";
    _eosBalanceLab.text = [NSString stringWithFormat:@"%@:%@ EOS",kLang(@"balance"),_inputSymbolM.balance];
}

- (IBAction)sellSelectAction:(id)sender {
    _isBuy = NO;
    [_doBtn setTitle:@"Sell" forState:UIControlStateNormal];
    _buyIcon.image = [UIImage imageNamed:@"icon_unselected_purple"];
    _sellIcon.image = [UIImage imageNamed:@"icon_selected_purple"];
    _purchaseTipHeight.constant = 0;
    _inputKeyLab.text = @"Sell Amount(Bytes)";
    _inputAmountTF.placeholder = @"Input RAM Amount";
    NSNumber *availableNum = @([_resourceInfoM.ram.available doubleValue]-[_resourceInfoM.ram.used doubleValue]);
    _eosBalanceLab.text = [NSString stringWithFormat:@"%@:%@ Bytes",kLang(@"balance"),availableNum.show4floatStr];
}

- (IBAction)doAction:(id)sender {
    NSString *payInfo = nil;
    NSString *showAmount = nil;
    NSString *key2 = nil;
    NSString *val2 = nil;
    if (_isBuy == YES) { // 买 （amount from to type）
        if (!_inputAmountTF.text || _inputAmountTF.text.length <= 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"input_eos_amount")];
            return;
        }
        if ([_inputAmountTF.text doubleValue] > [_inputSymbolM.balance doubleValue]) { // 余额不足
            [kAppD.window makeToastDisappearWithText:kLang(@"insufficient_balance")];
            return;
        }
        if (!_recipientAccountTF.text || _recipientAccountTF.text.length <= 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"input_recipient_account")];
            return;
        }
        
        payInfo = @"Purchase RAM";
        buyEosAmount = _inputAmountTF.text?:@"";
        buyOrSellTo = _recipientAccountTF.text?:@"";
        buyOrSellOperationType = EOSOperationTypeBuyRam;
        showAmount = [NSString stringWithFormat:@"%@ EOS",buyEosAmount];
        key2 = @"Estimated Bytes";
        val2 = [NSString stringWithFormat:@"%@ Bytes",@([buyEosAmount doubleValue]/[self.resourcePriceM.ramPrice doubleValue]*1024)];
    } else { // 卖 （bytes from type）
        if (!_inputAmountTF.text || _inputAmountTF.text.length <= 0) {
            [kAppD.window makeToastDisappearWithText:kLang(@"input_ram_amount")];
            return;
        }
        if ([_inputAmountTF.text doubleValue] > [_resourceInfoM.ram.available doubleValue]-[_resourceInfoM.ram.used doubleValue]) { // 余额不足
            [kAppD.window makeToastDisappearWithText:kLang(@"insufficient_balance")];
            return;
        }
        
        payInfo = @"Sell RAM";
        SellBytes = _inputAmountTF.text?:@"";
        buyOrSellTo = _recipientAccountTF.text?:@"";
        buyOrSellOperationType = EOSOperationTypeSellRam;
        showAmount = [NSString stringWithFormat:@"%@ Bytes",SellBytes];
        key2 = @"Estimated Amount";
        val2 = [NSString stringWithFormat:@"%@ EOS",@([SellBytes doubleValue]/1024*[self.resourcePriceM.ramPrice doubleValue])];
    }
    
    [self showPayDetailsViewWithPayInfo:payInfo amount:showAmount key1:@"To" val1:buyOrSellTo key2:key2 val2:val2];
}

#pragma mark - Noti
- (void)buyRamSuccess:(NSNotification *)noti {
    [self showSuccessView];
    
    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
}

- (void)buyRamFail:(NSNotification *)noti {
    
}

- (void)sellRamSuccess:(NSNotification *)noti {
    [self showSuccessView];
    
    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
}

- (void)sellRamFail:(NSNotification *)noti {
    
}


@end
