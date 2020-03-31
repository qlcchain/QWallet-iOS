//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "JoinGroupBuyView.h"
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

@interface JoinGroupBuyView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;

@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLab;

@property (weak, nonatomic) IBOutlet UIButton *discountBtn;

@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *remainLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIView *peopleBack;
@property (nonatomic, strong) GroupPeopleView *groupPeopleV;

@property (nonatomic, strong) GroupBuyListModel *joinM;
@property (nonatomic, strong) TopupProductModel *productM;
@property (nonatomic, strong) TopupDeductionTokenModel *deductionTokenM;
@property (nonatomic, strong) NSString *phoneNum;

@end

@implementation JoinGroupBuyView

+ (instancetype)getInstance {
    JoinGroupBuyView *view = [[[NSBundle mainBundle] loadNibNamed:@"JoinGroupBuyView" owner:self options:nil] lastObject];
    [view configInit];
    return view;
}

#pragma mark - Operation
- (void)configInit {
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
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)config:(TopupProductModel *)productM tokenM:(TopupDeductionTokenModel *)tokenM joinM:(GroupBuyListModel *)joinM phoneNum:(NSString *)phoneNum {
    _joinM = joinM;
    _productM = productM;
    _deductionTokenM = tokenM;
    _phoneNum = phoneNum;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],productM.imgPath]];
    [_productIcon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topup_guangdong_mobile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    _productPriceLab.text = [NSString stringWithFormat:@"%@%@+%@%@",_joinM.payTokenAmount_str?:@"0",_joinM.payToken,_joinM.deductionTokenAmount_str?:@"0",_joinM.deductionToken];
        
    NSString *discountNumStr = @"0";
    NSString *language = [Language currentLanguageCode];
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        discountNumStr = @(100).sub(joinM.discount.mul(@(100)));
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        discountNumStr = joinM.discount.mul(@(10));
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        discountNumStr = @(100).sub(joinM.discount.mul(@(100)));
    }
    
    NSString *discountShowStr = @"";
    NSString *remainShowStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        discountShowStr = [NSString stringWithFormat:@"%@%% off, %@ discount partners",discountNumStr,joinM.numberOfPeople];
        remainShowStr = [NSString stringWithFormat:@"%@ more partner needed",joinM.numberOfPeople.sub(joinM.joined?:@"0")];
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        discountShowStr = [NSString stringWithFormat:@"满%@人%@折团",joinM.numberOfPeople,discountNumStr];
        remainShowStr = [NSString stringWithFormat:@"还差%@人",joinM.numberOfPeople.sub(joinM.joined?:@"0")];
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        discountShowStr = [NSString stringWithFormat:@"%@%% off, %@ discount partners",discountNumStr,joinM.numberOfPeople];
        remainShowStr = [NSString stringWithFormat:@"%@ more partner needed",joinM.numberOfPeople.sub(joinM.joined?:@"0")];
    }
    _discountLab.text = discountShowStr;
    NSString *discountShowBtnStr = [NSString stringWithFormat:@"   %@   ",discountShowStr];
    [_discountBtn setTitle:discountShowBtnStr forState:UIControlStateNormal];
    _remainLab.text = remainShowStr;
    _timeLab.text = [NSString stringWithFormat:@"%@:%@",kLang(@"valid_till"),[NSDate getTimeWithFromTime:joinM.createDate addMin:[joinM.duration integerValue]]];
    
    GroupBuyListItemModel *itemM = [GroupBuyListItemModel new];
    itemM.head = joinM.head;
    itemM.nickname = joinM.nickname;
    itemM.isCommander = YES;
    NSMutableArray *itemArr = [NSMutableArray array];
    [itemArr addObjectsFromArray:joinM.items];
    [itemArr addObject:itemM];
    [_groupPeopleV configGroupBuy:itemArr];
}

- (void)handlerGroupBuyPayToken {
    NSString *amountNum = _productM.localFiatAmount;
    NSString *groupDiscount = _joinM.discount?:@"1";
    NSString *fait1Str = _productM.payTokenMoney.mul(groupDiscount);
        NSString *deduction1Str = _productM.payTokenMoney.mul(_productM.qgasDiscount).mul(groupDiscount);
        NSNumber *deductionTokenPrice = @(1);
        if ([_productM.payFiat isEqualToString:@"CNY"]) {
            deductionTokenPrice = _deductionTokenM.price;
        } else if ([_productM.payFiat isEqualToString:@"USD"]) {
            deductionTokenPrice = _deductionTokenM.usdPrice;
        }
        NSString *deductionAmountStr = [deduction1Str.div(deductionTokenPrice) showfloatStr:3];
        NSString *deductionSymbolStr = _deductionTokenM.symbol;
        NSString *addStr = @"+";
        NSString *topupAmountShowStr = @"";
        NSString *payTokenSymbol = @"";
//        if ([_productM.payWay isEqualToString:@"TOKEN"]) {
            payTokenSymbol = _productM.payTokenSymbol?:@"";
            NSNumber *payTokenPrice = [_productM.payFiat isEqualToString:@"CNY"]?_productM.payTokenCnyPrice:[_productM.payFiat isEqualToString:@"USD"]?_productM.payTokenUsdPrice:@(0);
            NSString *payAmountStr = [fait1Str.sub(deduction1Str).div(payTokenPrice) showfloatStr:3];
            topupAmountShowStr = [NSString stringWithFormat:@"%@%@%@%@%@",payAmountStr,payTokenSymbol,addStr,deductionAmountStr,deductionSymbolStr];
//        }
    
    NSString *message = [NSString stringWithFormat:kLang(@"use_to_purchase__yuan_of_phone_charge_for_deduction_1"),amountNum, _productM.localFiat, _joinM.deductionTokenAmount_str?:@"0",_deductionTokenM.symbol,_joinM.payTokenAmount_str?:@"0", _productM.payTokenSymbol];
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
    
    NSString *groupId = _joinM.ID?:@"";
    NSString *phoneNumber = _phoneNum?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"groupId":groupId,@"phoneNumber":phoneNumber};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_join_group_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            TopupOrderModel *model = [TopupOrderModel getObjectWithKeyValues:responseObject[@"item"]];
            if (weakself.successBlock) {
                weakself.successBlock(model);
            }
            [weakself hide];

//            [kAppD.window makeToastDisappearWithText:kLang(@"success")];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

#pragma mark - Action
- (IBAction)okAction:(id)sender {
    if (_okBlock) {
        _okBlock();
    }
    
    [self handlerGroupBuyPayToken];
//    [self requestTopup_join_group];
//    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}


@end
