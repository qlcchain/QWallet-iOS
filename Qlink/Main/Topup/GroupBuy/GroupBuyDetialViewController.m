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
//#import "StartGroupBuyView.h"
#import "StartGroupViewController.h"
#import "GroupBuyListModel.h"
//#import "JoinGroupBuyView.h"
#import "JoinGroupBuyViewController.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "TopupOrderModel.h"
#import "TopupPayQLC_DeductionViewController.h"
#import "TopupPayETH_DeductionViewController.h"
#import <QLCFramework/QLCFramework.h>
#import "ETHWalletManage.h"
#import <UIButton+WebCache.h>
#import "ChooseDeductionTokenViewController.h"
#import <ContactsUI/ContactsUI.h>
#import "ChooseCountryUtil.h"
#import "PhoneNumerInputView.h"

static NSString *const TopupNetworkSize = @"30";

@interface GroupBuyDetialViewController () <UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate> {
    CNContactPickerViewController * _peoplePickVC;
}

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UITableView *groupTable;

//@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLab;
//@property (weak, nonatomic) IBOutlet UILabel *countryLab;
//@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
//@property (weak, nonatomic) IBOutlet UILabel *productPriceLab;
//@property (weak, nonatomic) IBOutlet UILabel *productDesLab;
//@property (weak, nonatomic) IBOutlet UILabel *productRechargeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneBackHeight; // 52
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLab;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;


@property (weak, nonatomic) IBOutlet UILabel *productTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *productOriginLab;
@property (weak, nonatomic) IBOutlet UILabel *productAlreadyLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ongoingEmptyHeight; // 60
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ongoingTableBackHeight; // 0

@property (weak, nonatomic) IBOutlet UIButton *buyAlongBtn;
@property (weak, nonatomic) IBOutlet UIButton *startGroupBuyBtn;

@property (weak, nonatomic) IBOutlet UIButton *chooseDeductionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topImg;
@property (weak, nonatomic) IBOutlet UILabel *phonetopupLab;
@property (weak, nonatomic) IBOutlet UILabel *phonetopupValLab;
@property (weak, nonatomic) IBOutlet UILabel *provinceLab;


@property (nonatomic) TopupPayType currentPayType;

//@property (nonatomic, strong) StartGroupBuyView *startGroupBuyV;
//@property (nonatomic, strong) JoinGroupBuyView *joinGroupBuyV;
@property (nonatomic, strong) TopupDeductionTokenModel *selectDeductionTokenM;
@property (nonatomic, strong) NSString *selectPhoneNum;

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
    
    _phoneBackHeight.constant = 0;
    
    _ongoingEmptyHeight.constant = 60;
    _ongoingTableBackHeight.constant = 0;
    
//    _productIcon.layer.cornerRadius = 4;
//    _productIcon.layer.masksToBounds = YES;
    _buyAlongBtn.layer.cornerRadius = 4;
    _buyAlongBtn.layer.masksToBounds = YES;
    _buyAlongBtn.layer.borderWidth = .5;
    _buyAlongBtn.layer.borderColor = MAIN_BLUE_COLOR.CGColor;
    _startGroupBuyBtn.layer.cornerRadius = 4;
    _startGroupBuyBtn.layer.masksToBounds = YES;
    _chooseDeductionBtn.layer.cornerRadius = _chooseDeductionBtn.width/2.0;
    _chooseDeductionBtn.layer.masksToBounds = YES;
    
    _phoneNumberLab.text = kLang(@"phone_number");
    
    _selectDeductionTokenM = _inputDeductionTokenM;
    [self refreshSelectDeductionTokenView];
    
    [self refreshProductView];
}

- (void)refreshProductView {
    BOOL haveGroupBuy = [_inputProductM.haveGroupBuy isEqualToString:@"no"]?NO:YES;
            
    NSString *language = [Language currentLanguageCode];
    NSString *country = @"";
    NSString *province = @"";
    NSString *isp = @"";
    NSString *name = @"";
    NSString *explain = @"";
    NSString *des = @"";
    NSString *alreadyStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        country = _inputProductM.countryEn;
        province = _inputProductM.provinceEn;
        isp = _inputProductM.ispEn;
        name = _inputProductM.nameEn;
        explain = _inputProductM.explainEn;
        des = _inputProductM.descriptionEn;
        if (haveGroupBuy) {
            alreadyStr = [NSString stringWithFormat:@"%@ open",_inputProductM.orderTimes];
        } else {
            alreadyStr = [NSString stringWithFormat:@"%@ sold",_inputProductM.orderTimes];
        }
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        country = _inputProductM.country;
        province = _inputProductM.province;
        isp = _inputProductM.isp;
        name = _inputProductM.name;
        explain = _inputProductM.explain;
        des = _inputProductM.Description;
        if (haveGroupBuy) {
            alreadyStr = [NSString stringWithFormat:@"已拼%@+件",_inputProductM.orderTimes];
        } else {
            alreadyStr = [NSString stringWithFormat:@"已售%@+件",_inputProductM.orderTimes];
        }
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        country = _inputProductM.countryEn;
        province = _inputProductM.provinceEn;
        isp = _inputProductM.ispEn;
        name = _inputProductM.nameEn;
        explain = _inputProductM.explainEn;
        des = _inputProductM.descriptionEn;
        if (haveGroupBuy) {
            alreadyStr = [NSString stringWithFormat:@"%@ open",_inputProductM.orderTimes];
        } else {
            alreadyStr = [NSString stringWithFormat:@"%@ sold",_inputProductM.orderTimes];
        }
    }
//    _phoneNumberLab.text = [NSString stringWithFormat:@"%@：%@ %@",kLang(@"phone_number"),_inputCountryM.globalRoaming?:@"",_inputPhoneNum?:@""];
//    _countryLab.text = country?:@"";
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],_inputProductM.imgPath]];
//    [_productIcon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topup_guangdong_mobile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//    }];
    
//    _productPriceLab.text = [TopupProductModel getAmountShow:_inputProductM tokenM:_selectDeductionTokenM];
    
//    _productDesLab.text = [NSString stringWithFormat:@"%@%@%@",country,province,isp];
//    _productPhoneNumLab;
    
//    NSString *localFiatStr = _inputProductM.localFiat?:@"";
//    NSString *amountShowStr  = [NSString stringWithFormat:@"%@ %@",_inputProductM.localFaitMoney,localFiatStr];
//    _productRechargeLab.text = [NSString stringWithFormat:@"%@：%@",kLang(@"recharge_phone_bill"),amountShowStr];
    
    
    NSString *localFiatStr = _inputProductM.localFiat?:@"";
    NSString *amountShowStr  = [NSString stringWithFormat:@"%@ %@",_inputProductM.localFiatAmount,localFiatStr];
    //中划线
    NSDictionary *amountAttribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *amountAttribtStr = [[NSMutableAttributedString alloc]initWithString:amountShowStr attributes:amountAttribtDic];
    _productOriginLab.attributedText = amountAttribtStr;
    
//    NSString *desStr = [NSString stringWithFormat:@"%@%@%@",countryStr,provinceStr,ispStr];
    NSString *titleShowStr = [NSString stringWithFormat:@"%@ %@ %@\n%@",country,isp,amountShowStr,explain];
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:titleShowStr];
    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, titleShowStr.length)];
//    [discountAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIDisplay-Semibold" size:14] range:[discountShowStr rangeOfString:discountStr]];
    [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x2B2B2B) range:NSMakeRange(0, titleShowStr.length)];
    [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xF32A40) range:[titleShowStr rangeOfString:country]];
    _productTitleLab.attributedText = titleAtt;
    
    _productAlreadyLab.text = alreadyStr;
    
    _productPriceLab.text = [TopupProductModel getAmountShow:_inputProductM tokenM:_selectDeductionTokenM];
    
    _phonetopupLab.text = kLang(@"recharge_phone_bill");
    _phonetopupValLab.text = amountShowStr;
    _provinceLab.text = [NSString stringWithFormat:@"%@ %@",province,isp];
    
    NSString *topImgStr = @"";
    if ([country containsString:@"中国"]) {
        if ([isp containsString:@"通用"]) {
            topImgStr = @"ch_quanguo";
        } else {
            topImgStr = @"ch_yd";
        }
    } else if ([country containsString:@"Indonesia"]) {
        topImgStr = @"indonesia_telkom";
    } else if ([country containsString:@"Singapore"]) {
        if ([isp containsString:@"Starhub"]) {
            topImgStr = @"singapore_starhub";
        } else if ([isp containsString:@"M1"]) {
            topImgStr = @"singapore_m1";
        } else if ([isp containsString:@"Singtel"]) {
           topImgStr = @"singapore_singtel";
       }
    }
    _topImg.image = [UIImage imageNamed:topImgStr];
}

- (void)refreshSelectDeductionTokenView {
    if (_selectDeductionTokenM) {
        kWeakSelf(self);
        NSURL *url = [NSURL URLWithString:_selectDeductionTokenM.logoPng];
        [_chooseDeductionBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[_selectDeductionTokenM getDeductionTokenImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *img = [image sd_resizedImageWithSize:CGSizeMake(28, 28) scaleMode:SDImageScaleModeAspectFit];
            if (image) {
                [weakself.chooseDeductionBtn setImage:img forState:UIControlStateNormal];
            }
        }];
    }
}

//- (void)showStartGroupBuyView {
//    _startGroupBuyV = [StartGroupBuyView getInstance];
//    [_startGroupBuyV config:_inputProductM tokenM:_selectDeductionTokenM];
//    kWeakSelf(self);
//    _startGroupBuyV.okBlock = ^{
//
//    };
//    _startGroupBuyV.successBlock = ^{
//        [weakself requestTopup_group_list];
//    };
//    [_startGroupBuyV show];
//}

//- (void)showJoinGroupBuyView:(GroupBuyListModel *)joinM {
//    _joinGroupBuyV = [JoinGroupBuyView getInstance];
//    NSString *phoneNum = _selectPhoneNum?:@"";
//    [_joinGroupBuyV config:_inputProductM tokenM:_selectDeductionTokenM joinM:joinM phoneNum:phoneNum];
//    kWeakSelf(self);
//    _joinGroupBuyV.okBlock = ^{
//
//    };
//    _joinGroupBuyV.successBlock = ^(TopupOrderModel * model) {
//        [weakself requestTopup_group_list];
//        [weakself handlerGroupBuyPay:model];
//    };
//    [_joinGroupBuyV show];
//}

- (void)handlerGroupBuyPay:(TopupOrderModel *)model {
    if ([model.deductionTokenChain isEqualToString:QLC_Chain]) {
        [self jumpToTopupPayQLC_Deduction:model];
    } else if ([model.deductionTokenChain isEqualToString:ETH_Chain]) {
        [self jumpToTopupPayETH_Deduction:model];
    } else if ([model.deductionTokenChain isEqualToString:NEO_Chain]) {

    }
}

- (void)handlerPayToken:(TopupProductModel *)model {
    NSString *amountNum = model.localFiatAmount;
    NSString *fait1Str = model.discount.mul(model.payFiatAmount);
//    NSString *faitMoneyStr = [model.discount.mul(model.payFiatAmount) showfloatStr:4];
    NSString *deduction1Str = model.payFiatAmount.mul(model.qgasDiscount);
    NSNumber *deductionTokenPrice = @(1);
    if ([model.payFiat isEqualToString:@"CNY"]) {
        deductionTokenPrice = _selectDeductionTokenM.price;
    } else if ([model.payFiat isEqualToString:@"USD"]) {
        deductionTokenPrice = _selectDeductionTokenM.usdPrice;
    }
    NSString *deductionAmountStr = [model.payFiatAmount.mul(model.qgasDiscount).div(deductionTokenPrice) showfloatStr:3];
    NSNumber *payTokenPrice = [model.payFiat isEqualToString:@"CNY"]?model.payTokenCnyPrice:[model.payFiat isEqualToString:@"USD"]?model.payTokenUsdPrice:@(0);
    NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
    // Top-up value %@ %@\npay %@ %@ and %@ %@
    // localFaitMoney  lacalFait    qgasStr        payTokenAmount
    NSString *message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction_1"),amountNum, model.localFiat, deductionAmountStr,_selectDeductionTokenM.symbol,payAmountStr, model.payTokenSymbol];
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
//    NSString *page = @"1";
//    NSString *size = TopupNetworkSize;
    NSString *productId = _inputProductM.ID?:@"";
    NSString *localFiatMoney = _inputProductM.localFiatAmount?:@"";
    NSString *status = @"PROCESSING";
    NSString *deductionTokenId = _selectDeductionTokenM.ID?:@"";
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page,@"size":size,@"productId":productId, @"localFiatMoney":localFiatMoney,@"status":status,@"deductionTokenId":deductionTokenId}];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"productId":productId, @"localFiatMoney":localFiatMoney,@"status":status,@"deductionTokenId":deductionTokenId}];
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
    NSString *phoneNumber = _selectPhoneNum?:@"";
    NSString *localFiatAmount = [NSString stringWithFormat:@"%@",model.localFiatAmount];
    NSString *deductionTokenId = _selectDeductionTokenM.ID?:@"";
    NSDictionary *params = @{@"account":account,@"p2pId":p2pId,@"productId":productId,@"phoneNumber":phoneNumber,@"localFiatAmount":localFiatAmount,@"deductionTokenId":deductionTokenId?:@""};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_order_v2_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            
            TopupOrderModel *orderM = [TopupOrderModel getObjectWithKeyValues:responseObject[@"order"]];
            
            if ([weakself.selectDeductionTokenM.chain isEqualToString:ETH_Chain]) {
                [weakself jumpToTopupPayETH_Deduction:orderM];
            } else if ([weakself.selectDeductionTokenM.chain isEqualToString:QLC_Chain]) {
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
        [weakself jumpToJoinGroupBuy:joinM];
//        [weakself showJoinGroupBuyView:joinM];
    }];
    
    return cell;
}

#pragma mark - CNContactPickerDelegate
// 获取指定电话
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    //姓名
    NSString * firstName = contactProperty.contact.familyName;
    NSString * lastName = contactProperty.contact.givenName;
    //电话
    NSString * phoneNum = [contactProperty.value stringValue];
    DDLogDebug(@"姓名：%@%@ 电话：%@", firstName, lastName, phoneNum);
    NSString *num = [ChooseCountryUtil removeCodeContain:phoneNum];
    _phoneNumberTF.text = num;
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    DDLogDebug(@"contactPickerDidCancel");
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)ongoingCheckAllAction:(id)sender {
//    [self jumpToOngoingGroup];
//}

- (IBAction)buyAlongAction:(id)sender {
    kWeakSelf(self);
    PhoneNumerInputView *inputV = [PhoneNumerInputView getInstance];
    __weak typeof(inputV) weakInput = inputV;
    inputV.confirmBlock = ^(NSString * _Nonnull phoneNum) {
        [weakself.view endEditing:YES];
        if (phoneNum == nil || [phoneNum isEmptyString]) {
//            _phoneBackHeight.constant = 52;
            [kAppD.window makeToastDisappearWithText:kLang(@"phone_number_cannot_be_empty")];
            return;
        }
        if ([[phoneNum stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] length] > 0 || phoneNum.length < 6) { // 大于6位的纯数字
            [kAppD.window makeToastDisappearWithText:kLang(@"please_fill_in_a_valid_phone_number")];
            return;
        }
        [weakInput hide];

        weakself.selectPhoneNum = phoneNum;
        weakself.currentPayType = TopupPayTypeNormal;
        [weakself handlerPayToken:_inputProductM];
    };
    [inputV show];
}

- (IBAction)startGroupBuyAction:(id)sender {
    _currentPayType = TopupPayTypeGroupBuy;
//    [self showStartGroupBuyView];
    [self jumpToStartGroupBuy];
}

- (IBAction)chooseTokenAction:(id)sender {
    [self jumpToChooseDeductionToken];
}

- (IBAction)phoneNumberAction:(id)sender {
    _peoplePickVC = [[CNContactPickerViewController alloc] init];
    _peoplePickVC.delegate = self;
    _peoplePickVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_peoplePickVC animated:YES
                     completion:^{
                     }];
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
    if (_currentPayType == TopupPayTypeNormal) {
        vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.qgasAmount];
        vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.qgasAmount?:@""];
        vc.inputPayToken = orderM.payTokenSymbol;
    } else if (_currentPayType == TopupPayTypeGroupBuy) {
        vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.deductionTokenAmount_str];
        vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.deductionTokenAmount_str?:@""];
        vc.inputPayToken = orderM.payToken;
    }
    vc.sendDeductionToAddress = qlcAddress;
    vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.sendPayTokenAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount_str];
    vc.sendPayTokenToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.inputDeductionToken = _selectDeductionTokenM.symbol?:@"QGAS";
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
    if (_currentPayType == TopupPayTypeNormal) {
        vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.qgasAmount];
        vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.qgasAmount?:@""];
        
        vc.inputPayToken = orderM.payTokenSymbol;
    } else if (_currentPayType == TopupPayTypeGroupBuy) {
        vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.deductionTokenAmount_str];
        vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.deductionTokenAmount_str?:@""];
        vc.inputPayToken = orderM.payToken;
    }
    vc.sendDeductionToAddress = ethAddress;
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.sendPayTokenAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount_str];
    vc.sendPayTokenToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.inputDeductionToken = _selectDeductionTokenM.symbol?:@"OKB";
    vc.inputOrderM = orderM;
    vc.inputPayType = _currentPayType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChooseDeductionToken {
    ChooseDeductionTokenViewController *vc = [ChooseDeductionTokenViewController new];
    kWeakSelf(self);
    vc.completeBlock = ^(TopupDeductionTokenModel * _Nonnull model) {
        weakself.selectDeductionTokenM = model;
        [weakself refreshSelectDeductionTokenView];
        [weakself refreshProductView];
        [weakself requestTopup_group_list];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToStartGroupBuy {
    kWeakSelf(self);
    StartGroupViewController *vc = [StartGroupViewController new];
    vc.inputProductM = _inputProductM;
    vc.inputDeductionTokenM = _selectDeductionTokenM;
    vc.successBlock = ^{
        [weakself requestTopup_group_list];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToJoinGroupBuy:(GroupBuyListModel *)groupBuyListM {
    kWeakSelf(self);
    JoinGroupBuyViewController *vc = [JoinGroupBuyViewController new];
    vc.inputProductM = _inputProductM;
    vc.inputDeductionTokenM = _selectDeductionTokenM;
    vc.inputGroupBuyListM = groupBuyListM;
    vc.successBlock = ^(TopupOrderModel * _Nonnull model) {
        [weakself requestTopup_group_list];
        [weakself handlerGroupBuyPay:model];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
