//
//  NEOWalletDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NEOWalletDetailViewController.h"
#import "ETHWalletDetailCell.h"
#import "ExportPrivateKeyView.h"
#import "WalletCommonModel.h"
//#import "Qlink-Swift.h"
#import "NEOWalletUtil.h"
#import "DeleteWalletConfirmView.h"
//#import "GlobalConstants.h"
#import "NEOWalletInfo.h"

NSString *exportEncryptedKeyWIF = @"Export Encrypted Key(WIF)";
NSString *exportPrivateKeyWIF = @"Export Private Key(WIF)";

@interface NEOWalletDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *sourceArr;

@end

@implementation NEOWalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    _sourceArr = [NSMutableArray array];
    [_sourceArr addObjectsFromArray:@[exportEncryptedKeyWIF,exportPrivateKeyWIF]];
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
    NSString *privateKey = [NEOWalletInfo getNEOPrivateKeyWithAddress:_inputWalletCommonM.address];
    NSString *publickKey = [NEOWalletInfo getNEOPublicKeyWithAddress:_inputWalletCommonM.address];
    // AU8T3i1jP8fMQmYHM4XvanoK1hEQnCDeEf
    // 
    [view showWithPrivateKey:privateKey title:kLang(@"export_private_key")];
}

- (void)showExportEncyptedKey {
    ExportPrivateKeyView *view = [ExportPrivateKeyView getInstance];
    NSString *encryptedKey = [NEOWalletInfo getNEOEncryptedKeyWithAddress:_inputWalletCommonM.address];
    [view showWithPrivateKey:encryptedKey title:kLang(@"export_encrypted_key")];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)deleteWallet {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    BOOL success = [NEOWalletInfo deleteFromKeyChain:_inputWalletCommonM.address];
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
    if ([title isEqualToString:exportEncryptedKeyWIF]) {
        [self showExportEncyptedKey];
    } else if ([title isEqualToString:exportPrivateKeyWIF]) {
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

@end
