//
//  ETHTransferViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSTransferViewController.h"
#import "EOSTransferConfirmView.h"
#import "UITextView+ZWPlaceHolder.h"
#import "WalletCommonModel.h"
#import "EOSSymbolModel.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import <ETHFramework/ETHFramework.h>
//#import "EOSWalletUtil.h"
#import "WalletQRViewController.h"
#import "Qlink-Swift.h"
#import <eosFramework/RegularExpression.h>
#import "EOSWalletUtil.h"
#import "SuccessTipView.h"

@interface EOSTransferViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *symbolLab;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextView *sendtoAddressTV;
@property (weak, nonatomic) IBOutlet UITextField *memoTF;

@property (nonatomic, strong) NSMutableArray *tokenPriceArr;
@property (nonatomic, strong) EOSSymbolModel *selectSymbol;

@end

@implementation EOSTransferViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferSuccess:) name:EOS_Transfer_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferFail:) name:EOS_Transfer_Fail_Noti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    _selectSymbol = _inputSymbol?:_inputSourceArr?_inputSourceArr.firstObject:nil;
    _tokenPriceArr = [NSMutableArray array];
    
    _sendtoAddressTV.placeholder = @"Please input EOS account name";
    _sendtoAddressTV.text = _inputAccount_name;
    
    _sendBtn.userInteractionEnabled = NO;
    [_amountTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    _sendtoAddressTV.delegate = self;
    
    [self refreshView];
}

- (void)refreshView {
    _symbolLab.text = _selectSymbol.symbol;
    _balanceLab.text = [NSString stringWithFormat:@"Balance: %@ %@",[_selectSymbol getTokenNum],_selectSymbol.symbol];
    [self requestTokenPrice];
}

- (void)showEOSTransferConfirmView {
    NSString *address = _sendtoAddressTV.text;
    NSString *amount = [NSString stringWithFormat:@"%@ %@",_amountTF.text,_selectSymbol.symbol];
    NSString *memo = _memoTF.text?:@"";
    EOSTransferConfirmView *view = [EOSTransferConfirmView getInstance];
    [view configWithAddress:address amount:amount memo:memo];
    kWeakSelf(self);
    view.confirmBlock = ^{
        [weakself sendTransfer];
    };
    [view show];
}

- (void)checkSendBtnEnable {
    if (_sendtoAddressTV.text && _sendtoAddressTV.text.length > 0 && _amountTF.text && _amountTF.text.length > 0) {
        [_sendBtn setBackgroundColor:MAIN_BLUE_COLOR];
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
    NSString *name = _sendtoAddressTV.text;
    NSString *amount = _amountTF.text;
    NSString *memo = _memoTF.text?:@"";
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    [EOSWalletUtil.shareInstance transferWithSymbol:_selectSymbol From:currentWalletM.account_name?:@"" to:name amount:amount memo:memo];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showTransferSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:@"Success"];
}

#pragma mark - Request
- (void)requestTokenPrice {
    kWeakSelf(self);
    NSString *coin = [ConfigUtil getLocalUsingCurrency];
    NSDictionary *params = @{@"symbols":@[_selectSymbol.symbol],@"coin":coin};
    [RequestService requestWithUrl:tokenPrice_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
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

- (IBAction)scanAction:(id)sender {
    kWeakSelf(self);
    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
        weakself.sendtoAddressTV.text = codeValue;
    } needPop:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sendAction:(id)sender {
    if (!_amountTF.text || _amountTF.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Amount is empty"];
        return;
    }
    if (!_sendtoAddressTV.text || _sendtoAddressTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"EOS Account is empty"];
        return;
    }
    if ([_amountTF.text doubleValue] <= 0 || [_amountTF.text doubleValue] > [[_selectSymbol getTokenNum] doubleValue]) {
        [kAppD.window makeToastDisappearWithText:@"Insufficient balance"];
        return;
    }
//    if ([_amountTF.text doubleValue] > [[_selectAsset getTokenNum] doubleValue]) {
//        [kAppD.window makeToastDisappearWithText:@"Balance is not enough"];
//        return;
//    }
    
    // 检查地址有效性
    BOOL validateEOSAccountName = [RegularExpression validateEosAccountName:_sendtoAddressTV.text];
    if (!validateEOSAccountName) {
        [kAppD.window makeToastDisappearWithText:@"EOS Account is invalidate"];
        return;
    }
    
    [self showEOSTransferConfirmView];
}

- (IBAction)showCurrencyAction:(id)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    [_inputSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EOSSymbolModel *model = obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:model.symbol style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.selectSymbol = model;
            [weakself refreshView];
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Noti
- (void)transferSuccess:(NSNotification *)noti {
    [self showTransferSuccessView];
    
    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
}

- (void)transferFail:(NSNotification *)noti {
    
}

@end
