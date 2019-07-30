//
//  WalletsSwitchViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "WalletSelectViewController.h"
#import "WalletCommonModel.h"
#import "WalletsSwitchCell.h"
#import "ChooseWalletViewController.h"
#import <ETHFramework/ETHFramework.h>
#import "Qlink-Swift.h"
#import "EOSRegisterAccountViewController.h"
#import "EOSAccountInfoModel.h"
#import "EOSWalletInfo.h"
#import "ReportUtil.h"

@interface WalletSelectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, copy) WalletSelectBlock selectB;

@end

@implementation WalletSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _sourceArr = [NSMutableArray array];
    [_mainTable registerNib:[UINib nibWithNibName:WalletsSwitchCellReuse bundle:nil] forCellReuseIdentifier:WalletsSwitchCellReuse];
    [self renderView];
    [self configInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshData];
}

#pragma mark - Operation
- (void)renderView {
//    UIColor *shadowColor = [UIColorFromRGB(0x34547A) colorWithAlphaComponent:0.11];
//    [_bottomBack addShadowWithOpacity:1 shadowColor:shadowColor shadowOffset:CGSizeMake(0,-1) shadowRadius:22 andCornerRadius:0];
}

- (void)configInit {
    [self refreshData];
    
//    [self checkEOS_Share_Register_Account_Is_Active];
}

- (void)configSelectBlock:(WalletSelectBlock)block {
    _selectB = block;
}

- (void)refreshData {
    [_sourceArr removeAllObjects];
    if (_inputWalletType == WalletTypeAll) {
        NSArray *arr = [WalletCommonModel getAllWalletModel];
        [_sourceArr addObjectsFromArray:arr];
    } else if (_inputWalletType == WalletTypeEOS) {
        NSArray *arr = [WalletCommonModel getWalletModelWithType:WalletTypeEOS];
        [_sourceArr addObjectsFromArray:arr];
    } else if (_inputWalletType == WalletTypeETH) {
        NSArray *arr = [WalletCommonModel getWalletModelWithType:WalletTypeETH];
        [_sourceArr addObjectsFromArray:arr];
    } else if (_inputWalletType == WalletTypeNEO) {
        NSArray *arr = [WalletCommonModel getWalletModelWithType:WalletTypeNEO];
        [_sourceArr addObjectsFromArray:arr];
    } else if (_inputWalletType == WalletTypeQLC) {
        NSArray *arr = [WalletCommonModel getWalletModelWithType:WalletTypeQLC];
        [_sourceArr addObjectsFromArray:arr];
    }
    
}

//- (void)checkEOS_Share_Register_Account_Is_Active { // 检查本地 需要注册的EOS账号是否激活了
////    EOS_CreateSource_InKeychain
//    NSString *eosSourceStr = [KeychainUtil getKeyValueWithKeyName:EOS_CreateSource_InKeychain];
//    if (eosSourceStr != nil && eosSourceStr.length > 0) {
//        NSDictionary *eosSourceDic = [eosSourceStr mj_JSONObject];
//        EOSCreateSourceModel *eosCreateSourceM = [EOSCreateSourceModel getObjectWithKeyValues:eosSourceDic];
//        kWeakSelf(self);
//        NSDictionary *params = @{@"account":eosCreateSourceM.accountName?:@""};
//        [RequestService requestWithUrl:eosGet_account_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//            if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//                NSDictionary *dic = responseObject[Server_Data][Server_Data];
//                EOSAccountInfoModel *model = [EOSAccountInfoModel getObjectWithKeyValues:dic];
//                if (model.creator.length > 0) { // 已激活
//                    EOSWalletInfo *walletInfo = [[EOSWalletInfo alloc] init];
//                    walletInfo.account_name = eosCreateSourceM.accountName;
//                    walletInfo.account_active_public_key = eosCreateSourceM.activePublicKey;
//                    walletInfo.account_active_private_key = eosCreateSourceM.activePrivateKey;
//                    walletInfo.account_owner_public_key = eosCreateSourceM.ownerPublicKey;
//                    walletInfo.account_owner_private_key = eosCreateSourceM.ownerPrivateKey;
//                    // 存储keychain
//                    [walletInfo saveToKeyChain];
//
//                    [KeychainUtil removeKeyWithKeyName:EOS_CreateSource_InKeychain]; // 删除本地临时注册EOS资源
//
//                    [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"EOS" address:walletInfo.account_name pubKey:walletInfo.account_owner_public_key privateKey:walletInfo.account_owner_private_key]; // 上报钱包创建
//                    [[NSNotificationCenter defaultCenter] postNotificationName:Add_EOS_Wallet_Noti object:nil];
//
//                    [weakself refreshData];
//                }
//            }
//        } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        }];
//    }
//}

#pragma mark - Action

- (IBAction)closeAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addAction:(id)sender {
    [self jumpToChooseWallet];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WalletsSwitchCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WalletCommonModel *commonM = _sourceArr[indexPath.row];
    _showSelectWalletM = commonM;
    [_mainTable reloadData];
    
    if (_selectB) {
        _selectB(commonM);
    }
    
    [self closeAction:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletsSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:WalletsSwitchCellReuse];
    
    WalletCommonModel *commonM = _sourceArr[indexPath.row];
    [cell configCellWithModel:commonM selectM:_showSelectWalletM];
    
    return cell;
}

#pragma mark - Transition
- (void)jumpToChooseWallet {
    ChooseWalletViewController *vc = [[ChooseWalletViewController alloc] init];
    vc.showBack = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
