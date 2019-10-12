//
//  FinanceProductDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FinanceProductDetailViewController.h"
#import "FinanceProductModel.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "MD5Util.h"
#import "NSDate+Category.h"
#import "Qlink-Swift.h"
#import "NeoTransferUtil.h"
#import "NEOAddressInfoModel.h"
#import "NEOWalletUtil.h"
#import "SGQRCodeObtain.h"
#import "RefreshHelper.h"
#import "QlinkTabbarViewController.h"
#import "WalletsViewController.h"
#import "GlobalConstants.h"

@interface FinanceProductDetailViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qrcodeBackHeight; // 278
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBackHeight; // 120
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherMethodHeight; // 60

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *fromQLCLab;
@property (weak, nonatomic) IBOutlet UITextField *qlcTF;
@property (weak, nonatomic) IBOutlet UILabel *sendToAddressLab;
@property (weak, nonatomic) IBOutlet UIImageView *sendToQRImgV;
@property (weak, nonatomic) IBOutlet UIButton *termsAgreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *purchaseDateLab;
@property (weak, nonatomic) IBOutlet UILabel *valueDateLab;
@property (weak, nonatomic) IBOutlet UILabel *maturityDateLab;
@property (weak, nonatomic) IBOutlet UILabel *aprLab; // 收益

@property (nonatomic, strong) FinanceProductModel *requestProductM;
@property (nonatomic, strong) NEOAssetModel *qlcAssetM;

@end

@implementation FinanceProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestProduct_info];
    NSString *addressFrom = [NEOWalletManage.sharedInstance getWalletAddress];
    [self requestNEOAddressInfo:addressFrom showLoad:NO];
}

#pragma mark - Operation
- (void)configInit {
    
    _otherMethodHeight.constant = 0;
    _confirmBtn.layer.cornerRadius = 6;
    _confirmBtn.layer.masksToBounds = YES;
    _qrcodeBackHeight.constant = 0;
    _titleLab.text = _inputM.name;
    _rateLab.text = [NSString stringWithFormat:@"%.2f%%",[_inputM.annualIncomeRate floatValue]*100];
    _timeLab.text = [NSString stringWithFormat:@"%@ Days",_inputM.timeLimit];
    _fromQLCLab.text = [NSString stringWithFormat:@"From %@ QLC",_inputM.leastAmount];
    _qlcTF.placeholder = [NSString stringWithFormat:@"From %@ QLC",_inputM.leastAmount];
    _purchaseDateLab.text = @"Today";
    _valueDateLab.text = [[NSDate getTimeWithFromDate:[NSDate date] addDay:1] substringToIndex:10];
    _maturityDateLab.text = [[NSDate getTimeWithFromDate:[NSDate date] addDay:[_inputM.timeLimit integerValue]+1] substringToIndex:10];
    _aprLab.text = @"";
    
    kWeakSelf(self)
    _mainScroll.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        NSString *addressFrom = [NEOWalletManage.sharedInstance getWalletAddress];
        [weakself requestNEOAddressInfo:addressFrom showLoad:NO];
    }];
    
    NSString *mainAddress = [NeoTransferUtil getShareObject].neoMainAddress;
    _sendToAddressLab.text = mainAddress;
    UIImage *img = [[UIImage imageNamed:@"icon_start_icon"] imgWithBackgroundColor:[UIColor whiteColor]];
    _sendToQRImgV.image = [SGQRCodeObtain generateQRCodeWithData:mainAddress?:@"" size:_sendToQRImgV.width logoImage:img ratio:0.15 logoImageCornerRadius:4.0 logoImageBorderWidth:0.5 logoImageBorderColor:[UIColor whiteColor]];
//    [HMScanner qrImageWithString:mainAddress?:@"" avatar:nil completion:^(UIImage *image) {
//        weakself.sendToQRImgV.image = image;
//    }];
}

- (void)refreshView {
    _titleLab.text = _requestProductM.name;
    _rateLab.text = [NSString stringWithFormat:@"%.2f%%",[_requestProductM.annualIncomeRate floatValue]*100];
    _timeLab.text = [NSString stringWithFormat:@"%@ Days",_requestProductM.timeLimit];
    _fromQLCLab.text = [NSString stringWithFormat:@"From %@ QLC",_requestProductM.leastAmount];
    _qlcTF.placeholder = [NSString stringWithFormat:@"From %@ QLC",_requestProductM.leastAmount];
    _aprLab.text = _requestProductM.pointEn?:@"";
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)allAction:(id)sender {
    if (_qlcAssetM) {
        _qlcTF.text = [NSString stringWithFormat:@"%@",_qlcAssetM.amount];
    } else {
        [kAppD.window makeToastDisappearWithText:@"Please scroll down to refresh Or switch NEO wallet."];
    }
}

- (IBAction)rulesDetailAction:(id)sender {
    
}

- (IBAction)otherMethodAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _qrcodeBackHeight.constant = 278;
        _confirmBackHeight.constant = 0;
    } else {
        _qrcodeBackHeight.constant = 0;
        _confirmBackHeight.constant = 120;
    }
}

- (IBAction)termsAgreeAction:(id)sender {
    _termsAgreeBtn.selected = !_termsAgreeBtn.selected;
}

- (IBAction)confirmAction:(id)sender {
    [self.view endEditing:YES];
    if (_termsAgreeBtn.selected == NO) {
        [kAppD.window makeToastDisappearWithText:@"Please agree first"];
        return;
    }
    if (!_qlcTF.text || _qlcTF.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Please input QLC amount"];
        return;
    }
    
    if (!_qlcAssetM) {
        [kAppD.window makeToastDisappearWithText:@"Please scroll down to refresh Or switch NEO wallet."];
        return;
    }
    if ([_qlcAssetM.amount floatValue] < [_qlcTF.text floatValue]) {
        [kAppD.window makeToastDisappearWithText:@"Lack of QLC balance"];
        return;
    }
    [self getNEOTX];
}

#pragma mark - Request
// 产品详情
- (void)requestProduct_info {
    kWeakSelf(self);
    NSDictionary *params = @{@"id":_inputM.ID?:@""};
    [RequestService requestWithUrl5:product_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            weakself.requestProductM = [FinanceProductModel getObjectWithKeyValues:responseObject[Server_Data]];
            [weakself refreshView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

// 购买产品
- (void)requestOrder:(NSString *)tx {
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
    NSString *productId = _inputM.ID?:@"";
    NSString *amount = _qlcTF.text?:@"";
    NSString *addressFrom = [NEOWalletManage.sharedInstance getWalletAddress];
    NSString *addressTo = [NeoTransferUtil getShareObject].neoMainAddress;
    NSString *hex = tx?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"productId":productId,@"amount":amount,@"addressFrom":addressFrom,@"addressTo":addressTo,@"hex":hex};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl6:order_Url params:params timestamp:timestamp httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            [kAppD.window makeToastDisappearWithText:@"Purchase Successful"];
            [weakself backAction:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:@"Purchase Failed"];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

// 获取NEO资产信息
- (void)requestNEOAddressInfo:(NSString *)address showLoad:(BOOL)showLoad {
    // 检查地址有效性
    BOOL validateNEOAddress = [NEOWalletManage.sharedInstance validateNEOAddressWithAddress:address];
    if (!validateNEOAddress) {
        return;
    }
    kWeakSelf(self);
    NSDictionary *params = @{@"address":address};
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
    }
    [RequestService requestWithUrl5:neoAddressInfo_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainScroll.mj_header endRefreshing];
        if (showLoad) {
            [kAppD.window hideToast];
        }
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            NEOAddressInfoModel *neoAddressInfoM = [NEOAddressInfoModel getObjectWithKeyValues:dic];
            [neoAddressInfoM.balance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NEOAssetModel *model = obj;
                if ([model.asset_symbol isEqualToString:@"QLC"]) {
                    weakself.qlcAssetM = model;
                }
            }];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainScroll.mj_header endRefreshing];
        if (showLoad) {
            [kAppD.window hideToast];
        }
    }];
}

- (void)getNEOTX {
    if ([[NeoTransferUtil getShareObject].neoMainAddress isEmptyString]) {
        return;
    }

//    // gas 检查
//    if (([[kAppD.tabbarC.walletsVC getGasAssetBalanceOfNeo] doubleValue] < GAS_Control)) {
//        [kAppD.window showWalletAlertViewWithTitle:NSStringLocalizable(@"prompt") msg:[[NSMutableAttributedString alloc] initWithString:NSStringLocalizable(@"neo_nep5_gas_less")] isShowTwoBtn:NO block:^{
//        }];
//        return;
//    }

    NSInteger decimals = 8;
    NSString *tokenHash = _qlcAssetM.asset_hash;
    NSString *assetName = _qlcAssetM.asset;
    NSString *toAddress = [NeoTransferUtil getShareObject].neoMainAddress;
    NSString *amount = _qlcTF.text?:@"";
    NSString *symbol = _qlcAssetM.asset_symbol;
    NSString *fromAddress = [NEOWalletManage.sharedInstance getWalletAddress];
    NSString *remarkStr = nil;
    NSInteger assetType = 1; // 0:neo、gas  1:代币
    if ([symbol isEqualToString:@"GAS"] || [symbol isEqualToString:@"NEO"]) {
        assetType = 0;
    }
    BOOL isMainNetTransfer = YES;
    double fee = NEO_fee;
    
    kWeakSelf(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [kAppD.window makeToastInView:kAppD.window];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NEOWalletUtil getNEOTXWithTokenHash:tokenHash decimals:decimals assetName:assetName amount:amount toAddress:toAddress fromAddress:fromAddress symbol:symbol assetType:assetType mainNet:isMainNetTransfer remarkStr:remarkStr fee:fee completeBlock:^(NSString *txID ,NSString *txHex) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[NSStringUtil getNotNullValue:txHex] isEmptyString]) {
                        [kAppD.window hideToast];
                        [kAppD.window makeToastDisappearWithText:@"NEO tx error"];
                } else {
                    [weakself requestOrder:txHex];
                }
            });
        }];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
