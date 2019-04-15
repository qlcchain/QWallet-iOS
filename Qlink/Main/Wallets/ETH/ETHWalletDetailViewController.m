//
//  ETHWalletDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/26.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHWalletDetailViewController.h"
#import "ETHWalletDetailCell.h"
#import "ExportPrivateKeyView.h"
//#import "ETHExportKeystoreViewController.h"
#import "WalletCommonModel.h"
#import <ETHFramework/ETHFramework.h>
#import "ETHVerifyPWViewController.h"
#import "DeleteWalletConfirmView.h"
#import "ETHWalletInfo.h"
#import "ETHExportMnemonicViewController.h"
#import "FingerprintVerificationUtil.h"
#import "ETHExportKeystorePWViewController.h"

@interface ETHWalletDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation ETHWalletDetailViewController

NSString *exportMnemonicPhrase = @"Export Mnemonic Phrase";
NSString *exportKeystore = @"Export Keystore";
NSString *exportPrivateKey = @"Export private key";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _sourceArr = [NSMutableArray array];
    [_sourceArr addObjectsFromArray:@[exportMnemonicPhrase,exportKeystore,exportPrivateKey]];
    [_mainTable registerNib:[UINib nibWithNibName:ETHWalletDetailCellReuse bundle:nil] forCellReuseIdentifier:ETHWalletDetailCellReuse];
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    _nameLab.text = _inputWalletCommonM.name;
    _addressLab.text = [NSString stringWithFormat:@"%@...%@",[_inputWalletCommonM.address substringToIndex:8],[_inputWalletCommonM.address substringWithRange:NSMakeRange(_inputWalletCommonM.address.length - 8, 8)]];
}

- (void)showExportPrivateKey {
    ExportPrivateKeyView *view = [ExportPrivateKeyView getInstance];
//    kWeakSelf(self);
    [TrustWalletManage.sharedInstance exportPrivateKeyWithAddress:_inputWalletCommonM.address?:@"" :^(NSString * privateKey) {
        [view showWithPrivateKey:privateKey title:@"Export Private Key"];
    }];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)deleteWallet {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    [TrustWalletManage.sharedInstance deleteWithAddress:_inputWalletCommonM.address :^(BOOL success) {
        if (success) {
            [ETHWalletInfo deleteFromKeyChain:_inputWalletCommonM.address]; // 从keychain删除
            [WalletCommonModel deleteWalletModel:_inputWalletCommonM];
            if (_isDeleteCurrentWallet) { // 如果是当前选择钱包
                [WalletCommonModel removeCurrentSelectWallet];
            }
            [kAppD.window makeToastDisappearWithText:@"Delete Successful"];
            [self backToRoot];
            [[NSNotificationCenter defaultCenter] postNotificationName:Delete_Wallet_Success_Noti object:nil];
        } else {
            [kAppD.window makeToastDisappearWithText:@"Delete Failed"];
        }
    }];
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
    if ([title isEqualToString:exportMnemonicPhrase]) {
        kWeakSelf(self);
        if ([ConfigUtil getLocalTouch]) {
            [FingerprintVerificationUtil show:^(BOOL success) {
                if (success) {
                    [weakself jumpToETHExportMnemonic];
                }
            }];
        } else {
            [self jumpToETHExportMnemonic];
        }
//        [self jumpToETHVerifyPW];
    } else if ([title isEqualToString:exportKeystore]) {
        [self jumpToExportKeystorePW];
    } else if ([title isEqualToString:exportPrivateKey]) {
        [self showExportPrivateKey];
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

#pragma mark - Transition
- (void)jumpToExportKeystorePW {
    ETHExportKeystorePWViewController *vc = [[ETHExportKeystorePWViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)jumpToETHVerifyPW {
//    ETHVerifyPWViewController *vc = [[ETHVerifyPWViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)jumpToETHExportMnemonic {
    ETHExportMnemonicViewController *vc = [[ETHExportMnemonicViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
