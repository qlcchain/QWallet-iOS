//
//  JoinGroupBuyViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import "JoinGroupBuyViewController.h"
#import <ContactsUI/ContactsUI.h>
#import "ChooseCountryUtil.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"
#import "TopupDeductionTokenModel.h"
#import "TopupProductModel.h"
#import "GroupBuyListModel.h"
#import <UIImageView+WebCache.h>
#import "RLArithmetic.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"
#import "GroupPeopleView.h"
#import "RLArithmetic.h"
#import "NSString+RemoveZero.h"
#import "TopupOrderModel.h"

@interface JoinGroupBuyViewController () <CNContactPickerDelegate> {
    CNContactPickerViewController * _peoplePickVC;
}

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLab;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;

@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *productIspLab;
@property (weak, nonatomic) IBOutlet UILabel *productRegionLab;

@property (weak, nonatomic) IBOutlet UIButton *discountBtn;

@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *remainLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIView *peopleBack;
@property (nonatomic, strong) GroupPeopleView *groupPeopleV;

@property (nonatomic, strong) GroupBuyListModel *joinM;

@end

@implementation JoinGroupBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    _phoneNumberLab.text = kLang(@"phone_number");
    
    _confirmBtn.layer.cornerRadius = 4;
    _confirmBtn.layer.masksToBounds = YES;
    _productIcon.layer.cornerRadius = 4;
    _productIcon.layer.masksToBounds = YES;
    _discountBtn.layer.cornerRadius = 4;
    _discountBtn.layer.masksToBounds = YES;
    
    if (!_groupPeopleV) {
        _groupPeopleV = [GroupPeopleView getInstance];
        [_peopleBack addSubview:_groupPeopleV];
        kWeakSelf(self);
        [_groupPeopleV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(weakself.peopleBack).offset(0);
        }];
    }
    
    [self refreshProductView];
}

- (void)refreshProductView {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],_inputProductM.imgPath]];
    [_productIcon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topup_guangdong_mobile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    NSString *language = [Language currentLanguageCode];
    NSString *countryStr = @"";
    NSString *provinceStr = @"";
    NSString *ispStr = @"";
    NSString *nameStr = @"";
    NSString *explainStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        countryStr = _inputProductM.countryEn;
        provinceStr = _inputProductM.provinceEn;
        ispStr = _inputProductM.ispEn;
        nameStr = _inputProductM.nameEn;
        explainStr = _inputProductM.explainEn;
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        countryStr = _inputProductM.country;
        provinceStr = _inputProductM.province;
        ispStr = _inputProductM.isp;
        nameStr = _inputProductM.name;
        explainStr = _inputProductM.explain;
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        countryStr = _inputProductM.countryEn;
        provinceStr = _inputProductM.provinceEn;
        ispStr = _inputProductM.ispEn;
        nameStr = _inputProductM.nameEn;
        explainStr = _inputProductM.explainEn;
    }
    
//    NSString *desStr = [NSString stringWithFormat:@"%@%@%@",countryStr,provinceStr,ispStr];
    NSString *titleShowStr = [NSString stringWithFormat:@"%@ %@\n%@",countryStr,ispStr,explainStr];
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:titleShowStr];
    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, titleShowStr.length)];
    [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x2B2B2B) range:NSMakeRange(0, titleShowStr.length)];
    [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xF32A40) range:[titleShowStr rangeOfString:countryStr]];
    _productTitleLab.attributedText = titleAtt;
    
    _productIspLab.text = [NSString stringWithFormat:@"%@:%@",kLang(@"isp"),ispStr];
    _productRegionLab.text = [NSString stringWithFormat:@"%@:%@",kLang(@"region"),countryStr];
  
    _productPriceLab.text = [NSString stringWithFormat:@"%@%@+%@%@",_inputGroupBuyListM.payTokenAmount_str?:@"0",_inputGroupBuyListM.payToken,_inputGroupBuyListM.deductionTokenAmount_str?:@"0",_inputGroupBuyListM.deductionToken];
        
    NSString *discountNumStr = @"0";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        discountNumStr = @(100).sub(_inputGroupBuyListM.discount.mul(@(100)));
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        discountNumStr = _inputGroupBuyListM.discount.mul(@(10));
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        discountNumStr = @(100).sub(_inputGroupBuyListM.discount.mul(@(100)));
    }
    
    NSString *discountShowStr = @"";
    NSString *remainShowStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        discountShowStr = [NSString stringWithFormat:@"%@%% off, %@ discount partners",discountNumStr,_inputGroupBuyListM.numberOfPeople];
        remainShowStr = [NSString stringWithFormat:@"%@ more partner needed",_inputGroupBuyListM.numberOfPeople.sub(_inputGroupBuyListM.joined?:@"0")];
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        discountShowStr = [NSString stringWithFormat:@"满%@人%@折团",_inputGroupBuyListM.numberOfPeople,discountNumStr];
        remainShowStr = [NSString stringWithFormat:@"还差%@人",_inputGroupBuyListM.numberOfPeople.sub(_inputGroupBuyListM.joined?:@"0")];
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        discountShowStr = [NSString stringWithFormat:@"%@%% off, %@ discount partners",discountNumStr,_inputGroupBuyListM.numberOfPeople];
        remainShowStr = [NSString stringWithFormat:@"%@ more partner needed",_inputGroupBuyListM.numberOfPeople.sub(_inputGroupBuyListM.joined?:@"0")];
    }
    _discountLab.text = discountShowStr;
    NSString *discountShowBtnStr = [NSString stringWithFormat:@"   %@   ",discountShowStr];
    [_discountBtn setTitle:discountShowBtnStr forState:UIControlStateNormal];
    _remainLab.text = remainShowStr;
    _timeLab.text = [NSString stringWithFormat:@"%@:%@",kLang(@"valid_till"),[NSDate getTimeWithFromTime:_inputGroupBuyListM.createDate addMin:[_inputGroupBuyListM.duration integerValue]]];
    
    GroupBuyListItemModel *itemM = [GroupBuyListItemModel new];
    itemM.head = _inputGroupBuyListM.head;
    itemM.nickname = _inputGroupBuyListM.nickname;
    itemM.isCommander = YES;
    NSMutableArray *itemArr = [NSMutableArray array];
    [itemArr addObjectsFromArray:_inputGroupBuyListM.items];
    [itemArr addObject:itemM];
    [_groupPeopleV configGroupBuy:itemArr];
}

- (void)handlerGroupBuyPayToken {
    NSString *amountNum = _inputProductM.localFiatAmount;
    NSString *groupDiscount = _inputGroupBuyListM.discount?:@"1";
    NSString *fait1Str = _inputProductM.payFiatAmount.mul(groupDiscount);
        NSString *deduction1Str = _inputProductM.payFiatAmount.mul(_inputProductM.qgasDiscount).mul(groupDiscount);
        NSNumber *deductionTokenPrice = @(1);
        if ([_inputProductM.payFiat isEqualToString:@"CNY"]) {
            deductionTokenPrice = _inputDeductionTokenM.price;
        } else if ([_inputProductM.payFiat isEqualToString:@"USD"]) {
            deductionTokenPrice = _inputDeductionTokenM.usdPrice;
        }
        NSString *deductionAmountStr = [deduction1Str.div(deductionTokenPrice) showfloatStr:3];
        NSString *deductionSymbolStr = _inputDeductionTokenM.symbol;
        NSString *addStr = @"+";
        NSString *topupAmountShowStr = @"";
        NSString *payTokenSymbol = @"";
//        if ([_inputProductM.payWay isEqualToString:@"TOKEN"]) {
            payTokenSymbol = _inputProductM.payTokenSymbol?:@"";
            NSNumber *payTokenPrice = [_inputProductM.payFiat isEqualToString:@"CNY"]?_inputProductM.payTokenCnyPrice:[_inputProductM.payFiat isEqualToString:@"USD"]?_inputProductM.payTokenUsdPrice:@(0);
            NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
            topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",payAmountStr,payTokenSymbol,addStr,deductionAmountStr,deductionSymbolStr];
//        }
    
    NSString *message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction_1"),amountNum, _inputProductM.localFiat, _inputGroupBuyListM.deductionTokenAmount_str?:@"0",_inputDeductionTokenM.symbol,_inputGroupBuyListM.payTokenAmount_str?:@"0", _inputProductM.payTokenSymbol];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"purchase") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself requestTopup_join_group];
    }];
    [alertC addAction:alertBuy];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [kAppD.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Request
- (void)requestTopup_join_group {
    kWeakSelf(self);
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSString *groupId = _inputGroupBuyListM.ID?:@"";
    NSString *phoneNumber = _phoneNumberTF.text?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"groupId":groupId,@"phoneNumber":phoneNumber};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_join_group_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            TopupOrderModel *model = [TopupOrderModel getObjectWithKeyValues:responseObject[@"item"]];
            if (weakself.successBlock) {
                weakself.successBlock(model);
            }
//            [weakself hide];
//            [weakself backAction:nil];

//            [kAppD.window makeToastDisappearWithText:kLang(@"success")];
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

- (IBAction)phoneNumberAction:(id)sender {
    _peoplePickVC = [[CNContactPickerViewController alloc] init];
    _peoplePickVC.delegate = self;
    _peoplePickVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_peoplePickVC animated:YES
                     completion:^{
                     }];
}

- (IBAction)confirmAction:(id)sender {
    if (![UserModel haveLoginAccount]) {
        [kAppD presentLoginNew];
    }
    
//    if (_okBlock) {
//        _okBlock();
//    }
    if (_phoneNumberTF.text == nil || [_phoneNumberTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"phone_number_cannot_be_empty")];
        return;
    }
    if ([[_phoneNumberTF.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] length] > 0 || _phoneNumberTF.text.length < 6) { // 大于6位的纯数字
        [kAppD.window makeToastDisappearWithText:kLang(@"please_fill_in_a_valid_phone_number")];
        return;
    }
    
    [self handlerGroupBuyPayToken];
//    [self requestTopup_join_group];
//    [self hide];
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


@end
