//
//  ETHTransferViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QLCTransferViewController.h"
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
#import <SwiftTheme/SwiftTheme-Swift.h>

//#import "GlobalConstants.h"

@interface QLCTransferViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *symbolLab;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextView *sendtoAddressTV;
@property (weak, nonatomic) IBOutlet UITextField *memoTF;

@property (nonatomic, strong) NSMutableArray *tokenPriceArr;
@property (nonatomic, strong) QLCTokenModel *selectAsset;

@end

@implementation QLCTransferViewController

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//#pragma mark - Observe
//- (void)addObserve {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferSuccess:) name:NEO_Transfer_Success_Noti object:nil];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self addObserve];
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    [_sendBtn cornerRadius:6];
}

- (void)configInit {
    _selectAsset = _inputAsset?:_inputSourceArr?_inputSourceArr.firstObject:nil;
    _tokenPriceArr = [NSMutableArray array];
    
    _sendtoAddressTV.placeholder = kLang(@"qlc_wallet_address");
    _sendtoAddressTV.text = _inputAddress;
    
    _sendBtn.userInteractionEnabled = NO;
    [_amountTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    _sendtoAddressTV.delegate = self;
    
    [self refreshView];
}

- (void)refreshView {
    _symbolLab.text = _selectAsset.tokenName;
    _balanceLab.text = [NSString stringWithFormat:@"%@: %@ %@",kLang(@"balance"),[_selectAsset getTokenNum],_selectAsset.tokenName];
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
        [kAppD.window hideToast];
        [kAppD.window makeToastDisappearWithText:kLang(@"transfer_successful")];
        [weakself backToRoot];
    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
        [kAppD.window hideToast];
    }];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Request
- (void)requestTokenPrice {
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

- (IBAction)scanAction:(id)sender {
    kWeakSelf(self);
    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
        if (![[QLCWalletManage shareInstance] walletAddressIsValid:codeValue?:@""]) {
            [kAppD.window makeToastDisappearWithText:kLang(@"invalid_address")];
            return;
        }
        weakself.sendtoAddressTV.text = codeValue;
    } needPop:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sendAction:(id)sender {
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
    BOOL validateNEOAddress = [QLCWalletManage.shareInstance walletAddressIsValid:_sendtoAddressTV.text];
    if (!validateNEOAddress) {
        [kAppD.window makeToastDisappearWithText:kLang(@"qlc_wallet_address_is_invalidate")];
        return;
    }
    
    [self showQLCTransferConfirmView];
}

- (IBAction)showCurrencyAction:(id)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    kWeakSelf(self);
    [_inputSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QLCTokenModel *model = obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:model.tokenName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.selectAsset = model;
            [weakself refreshView];
        }];
        [alertC addAction:alert];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

//#pragma mark - Noti
//- (void)transferSuccess:(NSNotification *)noti {
//    [self backToRoot];
//}

@end
