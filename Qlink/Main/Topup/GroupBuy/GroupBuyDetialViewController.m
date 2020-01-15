//
//  GroupBuyDetialViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import "GroupBuyDetialViewController.h"
#import "OngoingGroupCell.h"
//#import "OngoingGroupViewController.h"
#import "TopupProductModel.h"
#import "TopupCountryModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TopupDeductionTokenModel.h"
#import "RLArithmetic.h"
#import "NSString+RemoveZero.h"
#import "TopupDeductionTokenModel.h"
#import "StartGroupBuyView.h"
#import "GroupBuyListModel.h"
#import "JoinGroupBuyView.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "TopupOrderModel.h"
#import "TopupPayQLC_DeductionViewController.h"
#import "TopupPayETH_DeductionViewController.h"
#import <QLCFramework/QLCFramework.h>
#import "ETHWalletManage.h"

static NSString *const TopupNetworkSize = @"30";

@interface GroupBuyDetialViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UITableView *groupTable;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *productDesLab;
//@property (weak, nonatomic) IBOutlet UILabel *productPhoneNumLab;
@property (weak, nonatomic) IBOutlet UILabel *productRechargeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ongoingEmptyHeight; // 60
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ongoingTableBackHeight; // 0

@property (weak, nonatomic) IBOutlet UIButton *buyAlongBtn;
@property (weak, nonatomic) IBOutlet UIButton *startGroupBuyBtn;

@property (nonatomic) TopupPayType currentPayType;

@property (nonatomic, strong) StartGroupBuyView *startGroupBuyV;
@property (nonatomic, strong) JoinGroupBuyView *joinGroupBuyV;

@end

@implementation GroupBuyDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self configInit];
    [self requestTopup_group_list];
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    [_groupTable registerNib:[UINib nibWithNibName:OngoingGroupCell_Reuse bundle:nil] forCellReuseIdentifier:OngoingGroupCell_Reuse];
    
    _ongoingEmptyHeight.constant = 60;
    _ongoingTableBackHeight.constant = 0;
    
    _productIcon.layer.cornerRadius = 4;
    _productIcon.layer.masksToBounds = YES;
    _buyAlongBtn.layer.cornerRadius = 4;
    _buyAlongBtn.layer.masksToBounds = YES;
    _buyAlongBtn.layer.borderWidth = .5;
    _buyAlongBtn.layer.borderColor = MAIN_BLUE_COLOR.CGColor;
    _startGroupBuyBtn.layer.cornerRadius = 4;
    _startGroupBuyBtn.layer.masksToBounds = YES;
    
    NSString *language = [Language currentLanguageCode];
    NSString *country = @"";
    NSString *province = @"";
    NSString *isp = @"";
    NSString *name = @"";
    NSString *explain = @"";
    NSString *des = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        country = _inputProductM.countryEn;
        province = _inputProductM.provinceEn;
        isp = _inputProductM.ispEn;
        name = _inputProductM.nameEn;
        explain = _inputProductM.explainEn;
        des = _inputProductM.descriptionEn;
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        country = _inputProductM.country;
        province = _inputProductM.province;
        isp = _inputProductM.isp;
        name = _inputProductM.name;
        explain = _inputProductM.explain;
        des = _inputProductM.Description;
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        country = _inputProductM.countryEn;
        province = _inputProductM.provinceEn;
        isp = _inputProductM.ispEn;
        name = _inputProductM.nameEn;
        explain = _inputProductM.explainEn;
        des = _inputProductM.descriptionEn;
    }
    _phoneNumberLab.text = [NSString stringWithFormat:@"%@：%@ %@",kLang(@"phone_number"),_inputCountryM.globalRoaming?:@"",_inputPhoneNum?:@""];
    _countryLab.text = country?:@"";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],_inputProductM.imgPath]];
    [_productIcon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topup_guangdong_mobile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    _productPriceLab.text = [TopupProductModel getAmountShow:_inputProductM tokenM:_inputDeductionTokenM];
    
    _productDesLab.text = [NSString stringWithFormat:@"%@%@%@",country,province,isp];
//    _productPhoneNumLab;
    
    NSString *rmbStr = _inputProductM.localFiat?:@"";
    NSString *amountShowStr  = [NSString stringWithFormat:@"%@ %@",_inputProductM.localFaitMoney,rmbStr];
    _productRechargeLab.text = [NSString stringWithFormat:@"%@：%@",kLang(@"recharge_phone_bill"),amountShowStr];
}

- (void)showStartGroupBuyView {
    _startGroupBuyV = [StartGroupBuyView getInstance];
    [_startGroupBuyV config:_inputProductM tokenM:_inputDeductionTokenM];
    kWeakSelf(self);
    _startGroupBuyV.okBlock = ^{
        
    };
    _startGroupBuyV.successBlock = ^{
        [weakself requestTopup_group_list];
    };
    [_startGroupBuyV show];
}

- (void)showJoinGroupBuyView:(GroupBuyListModel *)joinM {
    _joinGroupBuyV = [JoinGroupBuyView getInstance];
    [_joinGroupBuyV config:_inputProductM tokenM:_inputDeductionTokenM joinM:joinM phoneNum:_inputPhoneNum];
    kWeakSelf(self);
    _joinGroupBuyV.okBlock = ^{
        
    };
    _joinGroupBuyV.successBlock = ^(TopupOrderModel * model) {
        [weakself requestTopup_group_list];
        [weakself handlerGroupBuyPay:model];
    };
    [_joinGroupBuyV show];
}

- (void)handlerGroupBuyPay:(TopupOrderModel *)model {
    if ([model.deductionTokenChain isEqualToString:QLC_Chain]) {
        [self jumpToTopupPayQLC_Deduction:model];
    } else if ([model.deductionTokenChain isEqualToString:ETH_Chain]) {
        [self jumpToTopupPayETH_Deduction:model];
    } else if ([model.deductionTokenChain isEqualToString:NEO_Chain]) {

    }
}

- (void)handlerPayToken:(TopupProductModel *)model {
    NSString *amountNum = model.localFaitMoney;
    NSString *fait1Str = model.discount.mul(model.payTokenMoney);
//    NSString *faitMoneyStr = [model.discount.mul(model.payTokenMoney) showfloatStr:4];
    NSString *deduction1Str = model.payTokenMoney.mul(model.qgasDiscount);
    NSNumber *deductionTokenPrice = @(1);
    if ([model.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = _inputDeductionTokenM.price;
    } else if ([model.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = _inputDeductionTokenM.usdPrice;
    }
    NSString *deductionAmountStr = [model.payTokenMoney.mul(model.qgasDiscount).div(deductionTokenPrice) showfloatStr:3];
    NSNumber *payTokenPrice = [model.payFiat isEqualToString:@"CNY"]?model.payTokenCnyPrice:[model.payFiat isEqualToString:@"USD"]?model.payTokenUsdPrice:@(0);
    NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
    // Top-up value %@ %@\npay %@ %@ and %@ %@
    // localFaitMoney  lacalFait    qgasStr        payTokenAmount
    NSString *message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction_1"),amountNum, model.localFiat, deductionAmountStr,_inputDeductionTokenM.symbol,payAmountStr, model.payTokenSymbol];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"purchase") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself requestTopup_order:model];
    }];
    [alertC addAction:alertBuy];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Request
- (void)requestTopup_group_list {
    kWeakSelf(self);
    NSString *page = @"1";
    NSString *size = TopupNetworkSize;
    NSString *productId = _inputProductM.ID?:@"";
    NSString *localFiatMoney = _inputProductM.localFaitMoney?:@"";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page,@"size":size,@"productId":productId, @"localFiatMoney":localFiatMoney}];
    [RequestService requestWithUrl10:topup_group_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself.sourceArr removeAllObjects];
            NSArray *arr = [GroupBuyListModel mj_objectArrayWithKeyValuesArray:responseObject[@"groupList"]];
            [weakself.sourceArr addObjectsFromArray:arr];
            
            if (weakself.sourceArr.count > 0) {
                weakself.ongoingTableBackHeight.constant = weakself.sourceArr.count*OngoingGroupCell_Height;
                weakself.ongoingEmptyHeight.constant = 0;
            } else {
                weakself.ongoingTableBackHeight.constant = 0;
                weakself.ongoingEmptyHeight.constant = 60;
            }
            [weakself.groupTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestTopup_order:(TopupProductModel *)model {
    kWeakSelf(self);
    NSString *account = @"";
    UserModel *userM = [UserModel fetchUserOfLogin];
    if ([UserModel haveLoginAccount]) {
        account = userM.account;
    }
    NSString *p2pId = [UserModel getTopupP2PId];
    NSString *productId = model.ID?:@"";
    NSString *phoneNumber = _inputPhoneNum?:@"";
    NSString *localFiatAmount = [NSString stringWithFormat:@"%@",model.localFaitMoney];
    NSString *deductionTokenId = _inputDeductionTokenM.ID?:@"";
    NSDictionary *params = @{@"account":account,@"p2pId":p2pId,@"productId":productId,@"phoneNumber":phoneNumber,@"localFiatAmount":localFiatAmount,@"deductionTokenId":deductionTokenId?:@""};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_order_v2_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            
            TopupOrderModel *orderM = [TopupOrderModel getObjectWithKeyValues:responseObject[@"order"]];
            
            if ([weakself.inputDeductionTokenM.chain isEqualToString:ETH_Chain]) {
                [weakself jumpToTopupPayETH_Deduction:orderM];
            } else if ([weakself.inputDeductionTokenM.chain isEqualToString:QLC_Chain]) {
                [weakself jumpToTopupPayQLC_Deduction:orderM];
            }
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
//        [weakself hidePayLoadView];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OngoingGroupCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OngoingGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:OngoingGroupCell_Reuse];
    
    GroupBuyListModel *model = _sourceArr[indexPath.row];
    kWeakSelf(self);
    [cell config:model joinB:^(GroupBuyListModel * _Nonnull joinM) {
        weakself.currentPayType = TopupPayTypeGroupBuy;
        [weakself showJoinGroupBuyView:joinM];
    }];
    
    return cell;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)ongoingCheckAllAction:(id)sender {
//    [self jumpToOngoingGroup];
//}

- (IBAction)buyAlongAction:(id)sender {
    _currentPayType = TopupPayTypeNormal;
    [self handlerPayToken:_inputProductM];
}

- (IBAction)startGroupBuyAction:(id)sender {
    _currentPayType = TopupPayTypeGroupBuy;
    [self showStartGroupBuyView];
}


#pragma mark - Transition
//- (void)jumpToOngoingGroup {
//    OngoingGroupViewController *vc = [OngoingGroupViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)jumpToTopupPayQLC_Deduction:(TopupOrderModel *)orderM {
    // 检查平台地址
    NSString *qlcAddress = [QLCWalletManage shareInstance].qlcMainAddress;
    if ([qlcAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    if ([TopupOrderModel checkPayTokenChainServerAddressIsEmpty:orderM]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    TopupPayQLC_DeductionViewController *vc = [TopupPayQLC_DeductionViewController new];
    vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.qgasAmount];
    vc.sendDeductionToAddress = qlcAddress;
    vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount?:@""];
    vc.sendPayTokenAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount];
    vc.sendPayTokenToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.qgasAmount?:@""];
    vc.inputPayToken = orderM.payTokenSymbol;
    vc.inputDeductionToken = _inputDeductionTokenM.symbol?:@"QGAS";
    vc.inputOrderM = orderM;
    vc.inputPayType = _currentPayType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToTopupPayETH_Deduction:(TopupOrderModel *)orderM {
    // 检查平台地址
    NSString *ethAddress = [ETHWalletManage shareInstance].ethMainAddress;
    if ([ethAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    if ([TopupOrderModel checkPayTokenChainServerAddressIsEmpty:orderM]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    TopupPayETH_DeductionViewController *vc = [TopupPayETH_DeductionViewController new];
    vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.qgasAmount];
    vc.sendDeductionToAddress = ethAddress;
    vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.qgasAmount?:@""];
    vc.sendPayTokenAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount];
    vc.sendPayTokenToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount?:@""];
    vc.inputPayToken = orderM.payTokenSymbol;
    vc.inputDeductionToken = _inputDeductionTokenM.symbol?:@"OKB";
    vc.inputOrderM = orderM;
    vc.inputPayType = _currentPayType;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
