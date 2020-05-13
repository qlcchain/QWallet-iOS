//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "StartGroupBuyView.h"
#import "UIView+Visuals.h"
#import "WalletCommonModel.h"
#import "GlobalConstants.h"
#import "StartGroupBuyCell.h"
#import "TopupDeductionTokenModel.h"
#import "TopupProductModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GroupKindModel.h"
#import "UserModel.h"
#import "NSDate+Category.h"
#import "RSAUtil.h"
#import "GroupBuyKnowDelegateView.h"
#import "AgentRewardViewController.h"
#import "QNavigationController.h"
////#import "QlinkTabbarViewController.h"
#import "MainTabbarViewController.h"
#import "AppDelegate.h"
#import "AppJumpHelper.h"
#import "GroupBuyGoStakeView.h"
#import "MyStakingsViewController.h"
#import "UIView+PopAnimate.h"

static NSString *const TopupNetworkSize = @"30";

@interface StartGroupBuyView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (weak, nonatomic) IBOutlet UITableView *groupTypeTable;
@property (weak, nonatomic) IBOutlet UIView *tipBack;

@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLab;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

@property (nonatomic) NSInteger selectIndex;
@property (nonatomic, strong) TopupProductModel *productM;
@property (nonatomic, strong) TopupDeductionTokenModel *deductionTokenM;

@end

@implementation StartGroupBuyView

+ (instancetype)getInstance {
    StartGroupBuyView *view = [[[NSBundle mainBundle] loadNibNamed:@"StartGroupBuyView" owner:self options:nil] lastObject];
    [view configInit];
    [view requestTopup_group_kind_list];
    return view;
    
}

#pragma mark - Operation
- (void)configInit {
    _sourceArr = [NSMutableArray array];
    _groupTypeTable.delegate = self;
    _groupTypeTable.dataSource = self;
    [_groupTypeTable registerNib:[UINib nibWithNibName:StartGroupBuyCell_Reuse bundle:nil] forCellReuseIdentifier:StartGroupBuyCell_Reuse];
    
    _confirmBtn.layer.cornerRadius = 4;
    _confirmBtn.layer.masksToBounds = YES;
    _productIcon.layer.cornerRadius = 4;
    _productIcon.layer.masksToBounds = YES;
    
    _tableHeight.constant = 0;
    _selectIndex = -1;
}

- (void)config:(TopupProductModel *)productM tokenM:(TopupDeductionTokenModel *)tokenM {
    _productM = productM;
    _deductionTokenM = tokenM;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],productM.imgPath]];
    [_productIcon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"topup_guangdong_mobile"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    _productPriceLab.text = [TopupProductModel getAmountShow:_productM tokenM:_deductionTokenM groupDiscount:@"1"];
}

- (void)refreshProductPriceView {
    if (_selectIndex < 0) {
        return;
    }
    GroupKindModel *groupKindM = _sourceArr[_selectIndex];
    _productPriceLab.text = [TopupProductModel getAmountShow:_productM tokenM:_deductionTokenM groupDiscount:groupKindM.discount?:@"1"];
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    [self.tipBack showPopAnimate];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)selectToIndex:(NSInteger)index {
    _selectIndex = index;
    [_groupTypeTable reloadData];
    [self refreshProductPriceView];
}

- (void)showKnowDelegateView {
    GroupBuyKnowDelegateView *view = [GroupBuyKnowDelegateView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
        [weakself jumpToAgentReward];
        [weakself hide];
    };
    [view show];
}

- (void)showGoStakeView {
    GroupBuyGoStakeView *view = [GroupBuyGoStakeView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
//        [AppJumpHelper jumpToWallet];
        [weakself jumpToMyStakings];
        [weakself hide];
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
            [weakself.groupTypeTable reloadData];
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
    NSString *productId = _productM.ID?:@"";
    NSString *localFiatMoney = _productM.localFiatAmount?:@"";
    NSString *deductionTokenId = _deductionTokenM.ID?:@"";
    NSDictionary *params = @{@"account":account,@"token":token,@"groupKindId":groupKindId,@"productId":productId,@"localFiatMoney":localFiatMoney,@"deductionTokenId":deductionTokenId};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_create_group_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            if (weakself.successBlock) {
                weakself.successBlock();
            }
            [weakself hide];
            [kAppD.window makeToastDisappearWithText:kLang(@"success")];
            
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
- (IBAction)okAction:(id)sender {
    if (_okBlock) {
        _okBlock();
    }
    
    if (_selectIndex < 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_select_groupbuy_type")];
        return;
    }
    
    [self requestTopup_create_group];
//    [self hide];
}

- (IBAction)closeAction:(id)sender {
    [self hide];
}

#pragma mark - Transition
- (void)jumpToAgentReward {
    AgentRewardViewController *vc = [AgentRewardViewController new];
    [((QNavigationController *)kAppD.mtabbarC.selectedViewController) pushViewController:vc animated:YES];
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
    [((QNavigationController *)kAppD.mtabbarC.selectedViewController) pushViewController:vc animated:YES];
}

@end
