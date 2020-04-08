//
//  StartGroupViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import "StartGroupViewController.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"
#import "StartGroupBuyCell.h"
#import "TopupDeductionTokenModel.h"
#import "TopupProductModel.h"
#import <UIImageView+WebCache.h>
#import "GroupKindModel.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"
#import "GroupBuyKnowDelegateView.h"
#import "AgentRewardViewController.h"
#import "QNavigationController.h"
#import "QlinkTabbarViewController.h"
#import "MainTabbarViewController.h"
#import "AppDelegate.h"
#import "AppJumpHelper.h"
#import "GroupBuyGoStakeView.h"
#import "MyStakingsViewController.h"
#import "FirebaseUtil.h"

static NSString *const TopupNetworkSize = @"30";

@interface StartGroupViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *productIspLab;
@property (weak, nonatomic) IBOutlet UILabel *productRegionLab;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

@property (nonatomic) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray *sourceArr;


@end

@implementation StartGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestTopup_group_kind_list];
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [_mainTable registerNib:[UINib nibWithNibName:StartGroupBuyCell_Reuse bundle:nil] forCellReuseIdentifier:StartGroupBuyCell_Reuse];
    self.baseTable = _mainTable;
    
    _confirmBtn.layer.cornerRadius = 4;
    _confirmBtn.layer.masksToBounds = YES;
    _productIcon.layer.cornerRadius = 4;
    _productIcon.layer.masksToBounds = YES;
    
    _tableHeight.constant = 0;
    _selectIndex = -1;

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
    NSString *discountNumStr = @"0";
    NSString *discountShowStr = @"";
    NSString *alreadyStr = @"";
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
    
    _productPriceLab.text = [TopupProductModel getAmountShow:_inputProductM tokenM:_inputDeductionTokenM groupDiscount:@"1"];
}

- (void)refreshProductPriceView {
    if (_selectIndex < 0) {
        return;
    }
    GroupKindModel *groupKindM = _sourceArr[_selectIndex];
    _productPriceLab.text = [TopupProductModel getAmountShow:_inputProductM tokenM:_inputDeductionTokenM groupDiscount:groupKindM.discount?:@"1"];
}

- (void)selectToIndex:(NSInteger)index {
    _selectIndex = index;
    [_mainTable reloadData];
    [self refreshProductPriceView];
}

- (void)showKnowDelegateView {
    GroupBuyKnowDelegateView *view = [GroupBuyKnowDelegateView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
        [weakself jumpToAgentReward];
//        [weakself hide];
    };
    [view show];
}

- (void)showGoStakeView {
    GroupBuyGoStakeView *view = [GroupBuyGoStakeView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
//        [AppJumpHelper jumpToWallet];
        [weakself jumpToMyStakings];
//        [weakself hide];
    };
    [view show];
}

#pragma mark - Request
- (void)requestTopup_group_kind_list {
    kWeakSelf(self);
    NSString *page = @"1";
    NSString *size = TopupNetworkSize;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page,@"size":size}];
    [RequestService requestWithUrl10:topup_group_kind_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            [weakself.sourceArr removeAllObjects];
            NSArray *arr = [GroupKindModel mj_objectArrayWithKeyValuesArray:responseObject[@"groupKindList"]];
            [weakself.sourceArr addObjectsFromArray:arr];
            
            if (weakself.sourceArr.count > 0) {
                weakself.tableHeight.constant = weakself.sourceArr.count*StartGroupBuyCell_Height;
                
                [weakself selectToIndex:0];
            } else {
                weakself.tableHeight.constant = 0;
            }
            [weakself.mainTable reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

- (void)requestTopup_create_group {
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
    
    GroupKindModel *groupKindM = _sourceArr[_selectIndex];
    NSString *groupKindId = groupKindM.ID?:@"";
    NSString *productId = _inputProductM.ID?:@"";
    NSString *localFiatMoney = _inputProductM.localFiatAmount?:@"";
    NSString *deductionTokenId = _inputDeductionTokenM.ID?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"groupKindId":groupKindId,@"productId":productId,@"localFiatMoney":localFiatMoney,@"deductionTokenId":deductionTokenId};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_create_group_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            if (weakself.successBlock) {
                weakself.successBlock();
            }
//            [weakself hide];
            [weakself backAction:nil];
            [kAppD.window makeToastDisappearWithText:kLang(@"success")];
            
            [FirebaseUtil logEventWithItemID:Topup_GroupBuy_StartGroup_Success itemName:Topup_GroupBuy_StartGroup_Success contentType:Topup_GroupBuy_StartGroup_Success];
            
        } else {
            NSString *msg = responseObject[Server_Msg];
            [kAppD.window makeToastDisappearWithText:msg];
            if ([msg containsString:@"The amount of QLC mortgage must be greater than 1500!"]) {
                [weakself showGoStakeView];
            } else if ([msg containsString:@"Please bind qlc chain address!"]) {
                [weakself showKnowDelegateView];
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return StartGroupBuyCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self selectToIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        [FirebaseUtil logEventWithItemID:Topup_GroupPlan_10_off itemName:Topup_GroupPlan_10_off contentType:Topup_GroupPlan_10_off];
    } else if (indexPath.row == 1) {
        [FirebaseUtil logEventWithItemID:Topup_GroupPlan_20_off itemName:Topup_GroupPlan_20_off contentType:Topup_GroupPlan_20_off];
    } else if (indexPath.row == 2) {
       [FirebaseUtil logEventWithItemID:Topup_GroupPlan_30_off itemName:Topup_GroupPlan_30_off contentType:Topup_GroupPlan_30_off];
   }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StartGroupBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:StartGroupBuyCell_Reuse];
    
    if (_selectIndex >= 0) {
        cell.typeBtn.selected = indexPath.row==_selectIndex?YES:NO;
    }
    GroupKindModel *model = _sourceArr[indexPath.row];
    [cell config:model];
        
    return cell;
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(id)sender {
//    if (_okBlock) {
//        _okBlock();
//    }
    if (![UserModel haveLoginAccount]) {
        [kAppD presentLoginNew];
    }
    
    if (_selectIndex < 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_select_groupbuy_type")];
        return;
    }
    
    [self requestTopup_create_group];
//    [self hide];
}

#pragma mark - Transition
- (void)jumpToAgentReward {
    AgentRewardViewController *vc = [AgentRewardViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToMyStakings {
    UserModel *userM = [UserModel fetchUserOfLogin];
    NSString *inputAddress = userM.qlcAddress?:@"";
    if ([inputAddress isEmptyString]) {
        [AppJumpHelper jumpToWallet];
        return;
    }
    MyStakingsViewController *vc = [MyStakingsViewController new];
    vc.inputAddress = inputAddress;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
