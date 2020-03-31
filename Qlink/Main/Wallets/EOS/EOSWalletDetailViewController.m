//
//  NEOWalletDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSWalletDetailViewController.h"
#import "ETHWalletDetailCell.h"
#import "ExportPrivateKeyView.h"
#import "WalletCommonModel.h"
//#import "Qlink-Swift.h"
//#import "NEOWalletUtil.h"
#import "DeleteWalletConfirmView.h"
#import "EOSResourcesViewController.h"
#import "EOSSymbolModel.h"
#import "EOSWalletInfo.h"
//#import "GlobalConstants.h"

NSString *EOSResources = @"Resources";
NSString *EOSExport_owner_private_key = @"Export owner private key";
NSString *EOSExport_active_private_key = @"Export active private key";

@interface EOSWalletDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation EOSWalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _sourceArr = [NSMutableArray array];
    [_sourceArr addObjectsFromArray:@[EOSResources,EOSExport_owner_private_key,EOSExport_active_private_key]];
    [_mainTable registerNib:[UINib nibWithNibName:ETHWalletDetailCellReuse bundle:nil] forCellReuseIdentifier:ETHWalletDetailCellReuse];
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    _nameLab.text = _inputWalletCommonM.name;
    _addressLab.text = _inputWalletCommonM.account_name;
}

- (void)showExportOwnerPrivateKey {
    ExportPrivateKeyView *view = [ExportPrivateKeyView getInstance];
    NSString *privateKey = [EOSWalletInfo getOwnerPrivateKey:_inputWalletCommonM.account_name?:@""];
    [view showWithPrivateKey:privateKey title:EOSExport_owner_private_key];
}

- (void)showExportActivePrivateKey {
    ExportPrivateKeyView *view = [ExportPrivateKeyView getInstance];
    NSString *privateKey = [EOSWalletInfo getActivePrivateKey:_inputWalletCommonM.account_name?:@""];
    [view showWithPrivateKey:privateKey title:EOSExport_active_private_key];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)deleteWallet {
    BOOL success = [EOSWalletInfo deleteFromKeyChain:_inputWalletCommonM.account_name?:@""];
    if (success) {
        [WalletCommonModel deleteWalletModel:_inputWalletCommonM];
        if (_isDeleteCurrentWallet) { // 如果是当前选择钱包
            [WalletCommonModel removeCurrentSelectWallet];
        }
        [kAppD.window makeToastDisappearWithText:kLang(@"delete_successful")];
        [self backToRoot];
        [[NSNotificationCenter defaultCenter] postNotificationName:Delete_Wallet_Success_Noti object:nil];
    } else {
        [kAppD.window makeToastDisappearWithText:kLang(@"delete_failed")];
    }
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteWalletAction:(id)sender {
    DeleteWalletConfirmView *view = [DeleteWalletConfirmView getInstance];
    kWeakSelf(self);
    view.okBlock = ^{
        [weakself deleteWallet];
    };
    [view show];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ETHWalletDetailCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = _sourceArr[indexPath.row];
    if ([title isEqualToString:EOSResources]) {
        [self jumpToEOSResources];
    } else if ([title isEqualToString:EOSExport_owner_private_key]) {
        [self showExportOwnerPrivateKey];
    } else if ([title isEqualToString:EOSExport_active_private_key]) {
        [self showExportActivePrivateKey];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETHWalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ETHWalletDetailCellReuse];
    
    NSString *title = _sourceArr[indexPath.row];
    [cell configCellWithTitle:title];
    
    return cell;
}

- (void)jumpToEOSResources {
    EOSResourcesViewController *vc = [[EOSResourcesViewController alloc] init];
    vc.inputSymbolM = _inputSymbolM;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
