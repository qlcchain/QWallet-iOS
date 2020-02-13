//
//  TopupProductSubViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import "TopupProductSubViewController.h"
#import "TopupProductSubCell.h"
#import "TopupProductModel.h"
#import "TopupDeductionTokenModel.h"
#import "WalletCommonModel.h"
#import "PhoneNumerInputView.h"
#import "ChooseWalletViewController.h"
#import "GroupBuyUtil.h"
#import "TopupPayHelper.h"
#import "GroupBuyDetialViewController.h"
#import "ChooseTopupPlanViewController.h"

static NSString *TopupNetworkSize = @"30";

@interface TopupProductSubViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) CGFloat tableHeight;
@property (nonatomic, strong) TopupDeductionTokenModel *selectDeductionTokenM;

@end

@implementation TopupProductSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_BLUE_COLOR;
    
    [self configInit];
    [self requestTopup_product_list_v3];
}

#pragma mark - Operation
- (void)configInit {
    _tableHeight = 0;
    _currentPage = 1;
    _selectDeductionTokenM = _inputDeductionTokenM;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:TopupProductSubCell_Reuse bundle:nil] forCellReuseIdentifier:TopupProductSubCell_Reuse];
}

- (void)pullRefresh {
    [self requestTopup_product_list_v3];
}

- (CGFloat)getTableHeight {
    return _tableHeight;
}



#pragma mark - Request
- (void)requestTopup_product_list_v3 {
    kWeakSelf(self);
//    NSString *phoneNumber = @"";
    NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = TopupNetworkSize;
    NSString *deductionTokenId = _selectDeductionTokenM?_selectDeductionTokenM.ID:@"";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page,@"size":size, @"deductionTokenId":deductionTokenId}];
    if (_inputGlobalRoaming != nil && ![_inputGlobalRoaming isEmptyString]) {
        [params setObject:_inputGlobalRoaming forKey:@"globalRoaming"];
    }
    [RequestService requestWithUrl10:topup_product_list_v3_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [weakself.mainScroll.mj_header endRefreshing];
//        [weakself.mainScroll.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TopupProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"productList"]];
//            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
//            }
//
            [weakself.sourceArr addObjectsFromArray:arr];
//            weakself.currentPage += 1;

            weakself.tableHeight = weakself.sourceArr.count*TopupProductSubCell_Height;
            [weakself.mainTable reloadData];
            
            if (weakself.updateTableHeightBlock) {
                weakself.updateTableHeightBlock(weakself.tableHeight);
            }
            
//            CGFloat line = ceil(weakself.sourceArr.count/2.0);
//            weakself.mainCollectionHeight.constant = line*TopupMobilePlanCell_Height+(line-1)*miniSpacingDistance;
//            [weakself.mainCollection reloadData];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [weakself.mainScroll.mj_header endRefreshing];
//        [weakself.mainScroll.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TopupProductSubCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 抵扣币
    if ([_selectDeductionTokenM.chain isEqualToString:ETH_Chain]) {
        if (![WalletCommonModel haveETHWallet]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:kLang(@"you_do_not_have_wallet_created_immediately"),@"ETH"] preferredStyle:UIAlertControllerStyleAlert];
            kWeakSelf(self);
            UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertC addAction:alertCancel];
            UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"create") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself jumpToChooseWallet:YES];
            }];
            [alertC addAction:alertBuy];
            alertC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:alertC animated:YES completion:nil];
            
            return;
        }
    } else if ([_selectDeductionTokenM.chain isEqualToString:QLC_Chain]) {
        if (![WalletCommonModel haveQLCWallet]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:kLang(@"you_do_not_have_wallet_created_immediately"),@"QLC"] preferredStyle:UIAlertControllerStyleAlert];
            kWeakSelf(self);
            UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertC addAction:alertCancel];
            UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"create") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself jumpToChooseWallet:YES];
            }];
            [alertC addAction:alertBuy];
            alertC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:alertC animated:YES completion:nil];
            
            return;
        }
    }
    
    TopupProductModel *model = _sourceArr[indexPath.row];
    if (model.stock && [model.stock doubleValue] == 0) { // 售罄
        return;
    }
    
    BOOL haveGroupBuy = NO;
    if ([model.payWay isEqualToString:@"FIAT"]) { // 法币支付
        if ([model.payFiat isEqualToString:@"CNY"]) {

        } else if ([model.payFiat isEqualToString:@"USD"]) {

        }
    } else if ([model.payWay isEqualToString:@"TOKEN"]) { // 代币支付
        if (![model.haveGroupBuy isEqualToString:@"no"]) {
            haveGroupBuy = YES;
        }
    }

    if (haveGroupBuy) {
        [self jumpToGroupBuyDetial:model];
    } else {
        [self jumpToChooseTopupPlan];
    }
    
    
//    if ([model.payWay isEqualToString:@"FIAT"]) { // 法币支付
//        if ([model.payFiat isEqualToString:@"CNY"]) {
//            kWeakSelf(self);
//            PhoneNumerInputView *inputV = [PhoneNumerInputView getInstance];
//            __weak typeof(inputV) weakInput = inputV;
//            inputV.confirmBlock = ^(NSString * _Nonnull phoneNum) {
//                [weakself.view endEditing:YES];
//                if (phoneNum == nil || [phoneNum isEmptyString]) {
//                    [kAppD.window makeToastDisappearWithText:kLang(@"phone_number_cannot_be_empty")];
//                    return;
//                }
//                if ([[phoneNum stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] length] > 0 || phoneNum.length < 6) { // 大于6位的纯数字
//                    [kAppD.window makeToastDisappearWithText:kLang(@"please_fill_in_a_valid_phone_number")];
//                    return;
//                }
//                [weakInput hide];
//
//                [TopupPayHelper shareInstance].selectPhoneNum = phoneNum;
//                [TopupPayHelper shareInstance].selectDeductionTokenM = weakself.selectDeductionTokenM;
//                [[TopupPayHelper shareInstance] handlerPayCNY:model];
//            };
//            [inputV show];
//
//        } else if ([model.payFiat isEqualToString:@"USD"]) {
//
//        }
//    } else if ([model.payWay isEqualToString:@"TOKEN"]) { // 代币支付
//
//        kWeakSelf(self);
//        [GroupBuyUtil requestHaveGroupBuyActiviy:^(BOOL haveGroupBuyActivity) {
//            if (haveGroupBuyActivity) {
//                [weakself jumpToGroupBuyDetial:model];
//            } else {
//
//                kWeakSelf(self);
//                PhoneNumerInputView *inputV = [PhoneNumerInputView getInstance];
//                __weak typeof(inputV) weakInput = inputV;
//                inputV.confirmBlock = ^(NSString * _Nonnull phoneNum) {
//                    [weakself.view endEditing:YES];
//                    if (phoneNum == nil || [phoneNum isEmptyString]) {
//                        [kAppD.window makeToastDisappearWithText:kLang(@"phone_number_cannot_be_empty")];
//                        return;
//                    }
//                    if ([[phoneNum stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] length] > 0 || phoneNum.length < 6) { // 大于6位的纯数字
//                        [kAppD.window makeToastDisappearWithText:kLang(@"please_fill_in_a_valid_phone_number")];
//                        return;
//                    }
//                    [weakInput hide];
//
//                    [TopupPayHelper shareInstance].selectPhoneNum = phoneNum;
//                    [TopupPayHelper shareInstance].selectDeductionTokenM = weakself.selectDeductionTokenM;
//                    [[TopupPayHelper shareInstance] handlerPayToken:model];
//                };
//                [inputV show];
//
//            }
//        }];
//
//    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopupProductSubCell *cell = [tableView dequeueReusableCellWithIdentifier:TopupProductSubCell_Reuse];
    
    TopupProductModel *model = _sourceArr[indexPath.row];
    [cell config:model token:_selectDeductionTokenM];
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToChooseWallet:(BOOL)showBack {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = showBack;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToGroupBuyDetial:(TopupProductModel *)model {
    GroupBuyDetialViewController *vc = [GroupBuyDetialViewController new];
    vc.inputProductM = model;
//    vc.inputCountryM = _inputCountryM;
//    vc.inputPhoneNum = _phoneTF.text?:@"";
    vc.inputDeductionTokenM = _selectDeductionTokenM;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToChooseTopupPlan {
    ChooseTopupPlanViewController *vc = [ChooseTopupPlanViewController new];
    vc.inputCountryM = _inputCountryM;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
