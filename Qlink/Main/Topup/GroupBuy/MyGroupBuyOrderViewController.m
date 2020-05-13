//
//  MyTopupOrderViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyGroupBuyOrderViewController.h"
//#import "MyTopupOrderCell.h"
#import "MyGroupBuyOrderCell.h"
#import "RefreshHelper.h"
#import "UserModel.h"
#import "TopupOrderModel.h"
#import "TopupConstants.h"
#import "TopupWebViewController.h"
#import "TopupCredentialViewController.h"
#import "HttpRedirect302Helper.h"
#import "TopupPayQLC_DeductionViewController.h"
#import "TopupPayETH_DeductionViewController.h"
#import "ETHWalletManage.h"
#import <QLCFramework/QLCFramework.h>
#import "TopupPayNEO_PayViewController.h"
#import "NSString+RemoveZero.h"

static NSString *const MyTopupOrderNetworkSize = @"20";

@interface MyGroupBuyOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic) NSInteger currentPage;

@end

@implementation MyGroupBuyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
    [self requestTopup_group_item_list];
}

#pragma mark - Operation
- (void)configInit {
    _currentPage = 1;
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:MyGroupBuyOrderCellReuse bundle:nil] forCellReuseIdentifier:MyGroupBuyOrderCellReuse];
    self.baseTable = _mainTable;
    
    kWeakSelf(self)
    _mainTable.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        weakself.currentPage = 1;
        [weakself requestTopup_group_item_list];
    } type:RefreshTypeColor];
    _mainTable.mj_footer = [RefreshHelper footerBackNormalWithRefreshingBlock:^{
        [weakself requestTopup_group_item_list];
    } type:RefreshTypeColor];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)payHandlerCNY:(TopupOrderModel *)model {
    NSString *sid = Topup_Pay_H5_sid;
    NSString *trace_id = [NSString stringWithFormat:@"%@_%@_%@",Topup_Pay_H5_trace_id,model.userId?:@"",model.ID?:@""];
        NSString *package = [NSString stringWithFormat:@"%@",model.originalPrice];
    NSString *mobile = model.phoneNumber;
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@?sid=%@&trace_id=%@&package=%@&mobile=%@",Topup_Pay_H5_Url,sid,trace_id,package,mobile];
    
    
    [self jumpToTopupH5:urlStr];
}

- (void)handlerPayToken:(TopupOrderModel *)model {
    if (model.deductionTokenInTxid == nil || [model.deductionTokenInTxid isEmptyString]) { // 抵扣币未支付
        if ([model.deductionTokenChain isEqualToString:QLC_Chain]) {
            [self jumpToTopupPayQLC_Deduction:model];
        } else if ([model.deductionTokenChain isEqualToString:ETH_Chain]) {
            [self jumpToTopupPayETH_Deduction:model];
        } else if ([model.deductionTokenChain isEqualToString:NEO_Chain]) {
            
        }
    } else {
        if (model.payTokenInTxid == nil || [model.payTokenInTxid isEmptyString]) { // 支付币未支付
            if ([model.status isEqualToString:Topup_Order_Status_DEDUCTION_TOKEN_PAID]) {
                if ([model.payTokenChain isEqualToString:QLC_Chain]) {
                    
                } else if ([model.payTokenChain isEqualToString:ETH_Chain]) {
                    
                } else if ([model.payTokenChain isEqualToString:NEO_Chain]) {
                    [self jumpToTopupPayNEO_Pay:model];
                }
            }
        }
    }
}

- (void)cancelHandler:(TopupOrderModel *)model {

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:kLang(@"_will_be_returned_to_the_payment_address"),model.deductionToken] preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    UIAlertAction *alertBuy = [UIAlertAction actionWithTitle:kLang(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself requestTopup_cancel_order:model.ID?:@""];
    }];
    [alertC addAction:alertBuy];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)credentialHandler:(TopupOrderModel *)model {
    NSURL *url = [NSURL URLWithString:@""];
    if ([model.deductionTokenChain isEqualToString:ETH_Chain]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ETH_Transaction_Url,model.deductionTokenInTxid?:@""]];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else if ([model.deductionTokenChain isEqualToString:QLC_Chain]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QLC_Transaction_Url,model.deductionTokenInTxid?:@""]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

#pragma mark - Request
- (void)requestTopup_group_item_list {
    kWeakSelf(self);
    UserModel *userM = [UserModel fetchUserOfLogin];
    NSString *userId = userM.ID?:@"";
    NSString *page = [NSString stringWithFormat:@"%li",_currentPage];
    NSString *size = MyTopupOrderNetworkSize;
    NSDictionary *params = @{@"page":page,@"size":size,@"userId":userId};
    [RequestService requestWithUrl10:topup_group_item_list_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSArray *arr = [TopupOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"itemList"]];
            if (weakself.currentPage == 1) {
                [weakself.sourceArr removeAllObjects];
            }
            
            [weakself.sourceArr addObjectsFromArray:arr];
            weakself.currentPage += 1;
            
            [weakself.mainTable reloadData];
            
            if (arr.count < [MyTopupOrderNetworkSize integerValue]) {
                [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
                weakself.mainTable.mj_footer.hidden = arr.count<=0?YES:NO;
            } else {
                weakself.mainTable.mj_footer.hidden = NO;
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [weakself.mainTable.mj_header endRefreshing];
        [weakself.mainTable.mj_footer endRefreshing];
    }];
}

- (void)requestTopup_cancel_order:(NSString *)orderId {
    kWeakSelf(self);
    NSString *account = @"";
    UserModel *userM = [UserModel fetchUserOfLogin];
    if ([UserModel haveLoginAccount]) {
        account = userM.account;
    }
    NSString *p2pId = [UserModel getTopupP2PId];
    NSDictionary *params = @{@"account":account,@"p2pId":p2pId,@"orderId":orderId};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:topup_cancel_order_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            TopupOrderModel *model = [TopupOrderModel getObjectWithKeyValues:responseObject[@"order"]];
            
            __block NSInteger cancelIndex = 0;
            __block BOOL isExist = NO;
            [weakself.sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TopupOrderModel *tempM = obj;
                if ([tempM.ID isEqualToString:orderId]) {
                    cancelIndex = idx;
                    isExist = YES;
                    *stop = YES;
                }
            }];
            if (isExist) {
                [weakself.sourceArr replaceObjectAtIndex:cancelIndex withObject:model];
                [weakself.mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cancelIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopupOrderModel *model = _sourceArr[indexPath.row];
    return [MyGroupBuyOrderCell cellHeight:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGroupBuyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyGroupBuyOrderCellReuse];
    
    kWeakSelf(self);
    TopupOrderModel *model = _sourceArr[indexPath.row];
    [cell config:model cancelB:^{
        [weakself cancelHandler:model];
    } payB:^{
//        if ([model.payWay isEqualToString:@"FIAT"]) { // 法币支付
//            if ([model.payFiat isEqualToString:@"CNY"]) {
//                [weakself payHandlerCNY:model];
//            } else if ([model.payFiat isEqualToString:@"USD"]) {
//
//            }
//        } else if ([model.payWay isEqualToString:@"TOKEN"]) { // 代币支付
            [weakself handlerPayToken:model];
//        }
        
    } credentialB:^{
        [weakself credentialHandler:model];
    } credetialDetalB:^{
        [weakself jumpToCredentialDetail:model];
    }];
    
    return cell;
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    if (_inputBackToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Transition
- (void)jumpToTopupH5:(NSString *)urlStr {
    TopupWebViewController *vc = [TopupWebViewController new];
    vc.inputBackToRoot = NO;
    vc.inputUrl = urlStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToCredentialDetail:(TopupOrderModel *)model {
    TopupCredentialViewController *vc = [TopupCredentialViewController new];
    vc.inputCredentailM = model;
    vc.inputPayType = TopupPayTypeGroupBuy;
    [self.navigationController pushViewController:vc animated:YES];
}

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
    vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.deductionTokenAmount_str];
    vc.sendDeductionToAddress = qlcAddress;
    vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.deductionTokenAmount_str?:@""];
    vc.sendPayTokenAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount_str];
    vc.sendPayTokenToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.inputPayToken = orderM.payToken;
    vc.inputDeductionToken = orderM.deductionToken?:@"QGAS";
    vc.inputOrderM = orderM;
    vc.inputPayType = TopupPayTypeGroupBuy;
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
    vc.sendDeductionAmount = [NSString stringWithFormat:@"%@",orderM.deductionTokenAmount_str];
    vc.sendDeductionToAddress = ethAddress;
    vc.sendDeductionMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.deductionTokenAmount_str?:@""];
    vc.sendPayTokenAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount_str];
    vc.sendPayTokenToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.sendPayTokenMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.inputPayToken = orderM.payToken;
    vc.inputDeductionToken = orderM.deductionToken;
    vc.inputOrderM = orderM;
    vc.inputPayType = TopupPayTypeGroupBuy;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToTopupPayNEO_Pay:(TopupOrderModel *)orderM {
    TopupPayNEO_PayViewController *vc = [TopupPayNEO_PayViewController new];
    vc.sendAmount = [NSString stringWithFormat:@"%@",orderM.payTokenAmount_str];
    vc.sendToAddress = [TopupOrderModel getPayTokenChainServerAddress:orderM];
    vc.sendMemo = [NSString stringWithFormat:@"%@_%@_%@",@"topup",orderM.ID?:@"",orderM.payTokenAmount_str?:@""];
    vc.inputPayToken = orderM.payToken;
    vc.inputOrderId = orderM.ID;
    vc.inputPayType = TopupPayTypeGroupBuy;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
