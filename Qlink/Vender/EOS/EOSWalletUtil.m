//
//  EOSWalletUtil.m
//  QlinkPodfile
//
//  Created by Jelly Foo on 2018/12/5.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSWalletUtil.h"
#import <eosFramework/AppConstant.h>
#import "RequestUrlConstant.h"
#import <eosFramework/EOS_Key_Encode.h>
//#import "Get_account_permission_service.h"
//#import "BackupEOSAccountService.h"
#import "TransferService.h"
#import "TransferAbi_json_to_bin_request.h"
#import <eosFramework/NSString+Extention.h>
#import <eosFramework/ContractConstant.h>
#import "EOS_BaseResult.h"
#import "MJExtension.h"
#import <eosFramework/StringConstant.h>
#import "GetAccountRequest.h"
#import <eosFramework/EosPrivateKey.h>
#import "CreateAccountService.h"
#import "Approve_Abi_json_to_bin_request.h"
#import "UnstakeEosAbiJsonTobinRequest.h"
#import "EOSResourceService.h"
#import "Buy_ram_abi_json_to_bin_request.h"
#import "Sell_ram_abi_json_to_bin_request.h"
#import <eosFramework/RegularExpression.h>
#import "EOSWalletInfo.h"
#import "EOS_GetAccountResult.h"
#import "EOS_GetAccount.h"
#import "EOSAccountInfoModel.h"
#import "EOSSymbolModel.h"
#import "NSString+RemoveZero.h"
#import "Create_account_abi_json_to_bin_request.h"
#import "CreateAccountTransferService.h"
#import "ReportUtil.h"

@interface EOSWalletUtil () <TransferServiceDelegate,CreateAccountTransferServiceDelegate> {
    // 从网络获取的公钥
    NSString *active_public_key_from_network;
    NSString *owner_public_key_from_network;
    // 在本地根据私钥算出的公钥
    NSString *active_public_key_from_local;
    NSString *owner_public_key_from_local;
    BOOL private_owner_Key_is_validate;
    BOOL private_active_Key_is_validate;
}

// 创建
@property(nonatomic , strong) CreateAccountTransferService *createAccountTransferService;

// 导入
//@property(nonatomic , strong) BackupEOSAccountService *backupEOSAccountService;
//@property(nonatomic , strong) Get_account_permission_service *get_account_permission_service;

// 转账
@property(nonatomic , strong) TransferAbi_json_to_bin_request *transferAbi_json_to_bin_request;
@property(nonatomic, strong) TransferService *mainService;

// 创建
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;
@property(nonatomic, strong) CreateAccountService *createAccountService;
@property(nonatomic, strong) Create_account_abi_json_to_bin_request *create_account_Abi_json_to_bin_request;

// 抵押
@property(nonatomic , strong) Approve_Abi_json_to_bin_request *approve_Abi_json_to_bin_request;
@property(nonatomic , strong) UnstakeEosAbiJsonTobinRequest *unstakeEosAbiJsonTobinRequest;
@property(nonatomic , strong) TransferService *transferService;
@property(nonatomic , strong) EOSResourceService *eosResourceService;

// 交易内存
@property(nonatomic , strong) Buy_ram_abi_json_to_bin_request *buy_ram_abi_json_to_bin_request;
@property(nonatomic , strong) Sell_ram_abi_json_to_bin_request *sell_ram_abi_json_to_bin_request;

@end

@implementation EOSWalletUtil

+ (instancetype)shareInstance {
    static EOSWalletUtil *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

#pragma mark - 创建
- (void)createAccountWithAccountName:(NSString *)accountName {
//    if (self.headerView.agreeItemBtn.isSelected) {
//        [TOASTVIEW showWithText:NSLocalizedString(@"请勾选同意条款!", nil)];
//        return;
//    }
//    if (![RegularExpression validateEosAccountName:accountName]) {
//        [kAppD.window makeToastDisappearWithText:@"12位字符，只能由小写字母a~z和数字1~5组成。"];
//        return;
//    }
    [self checkAccountExistWithAccountName:accountName];
}

- (void)checkAccountExistWithAccountName:(NSString *)accountName {
    WS(weakSelf);
    self.getAccountRequest.name = VALIDATE_STRING(accountName) ;
    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
        EOS_GetAccountResult *result = [EOS_GetAccountResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [kAppD.window makeToastDisappearWithText:result.message];
        }else{
            EOS_GetAccount *model = [EOS_GetAccount mj_objectWithKeyValues:result.data];
            if (model.account_name) {
                [kAppD.window makeToastDisappearWithText:@"账号已存在"];
                return ;
            }else{
                [weakSelf createkeysWithAccountName:accountName];
            }
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

/**
 生成注册eos账号需要的所有 key
 account_active_private_key;
 account_active_public_key;
 account_owner_private_key;
 account_owner_public_key;
 */
- (void)createkeysWithAccountName:(NSString *)accountName {
    WS(weakSelf);
    EosPrivateKey *ownerPrivateKey = [[EosPrivateKey alloc] initEosPrivateKey];
    EosPrivateKey *activePrivateKey = [[EosPrivateKey alloc] initEosPrivateKey];
//    if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
//        weakSelf.createAccountService.createEOSAccountRequest.uid = CURRENT_WALLET_UID;
//    }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
//        weakSelf.createAccountService.createEOSAccountRequest.uid = @"6f1a8e0eb24afb7ddc829f96f9f74e9d";
//    }
    weakSelf.createAccountService.createEOSAccountRequest.eosAccountName = accountName;
    weakSelf.createAccountService.createEOSAccountRequest.ownerKey = ownerPrivateKey.eosPublicKey;
    weakSelf.createAccountService.createEOSAccountRequest.activeKey = activePrivateKey.eosPublicKey;
    NSLog(@"{ownerPrivateKey:%@\neosPublicKey:%@\nactivePrivateKey:%@\neosPublicKey:%@\n}", ownerPrivateKey.eosPrivateKey, ownerPrivateKey.eosPublicKey, activePrivateKey.eosPrivateKey, activePrivateKey.eosPublicKey);
    // 创建eos账号
    
    [weakSelf.createAccountService createEOSAccount:^(id service, BOOL isSuccess) {
        
        if (isSuccess) {
            NSNumber *code = service[@"code"];
            if ([code isEqualToNumber:@0]) {
                // 创建账号成功
                NSLog(@"创建账号成功!", nil);
                
                // 本地数据库添加账号
//                AccountInfo *model = [[AccountInfo alloc] init];
//                model.account_name = weakSelf.headerView.accountNameTF.text;
//                model.account_img = ACCOUNT_DEFALUT_AVATAR_IMG_URL_STR;
//                model.account_active_public_key = activePrivateKey.eosPublicKey;
//                model.account_owner_public_key = ownerPrivateKey.eosPublicKey;
//                model.account_active_private_key = [AESCrypt encrypt:activePrivateKey.eosPrivateKey password:weakSelf.loginPasswordView.inputPasswordTF.text];
//                model.account_owner_private_key = [AESCrypt encrypt:ownerPrivateKey.eosPrivateKey password:weakSelf.loginPasswordView.inputPasswordTF.text];
//                model.is_privacy_policy = @"0";
//                [[AccountsTableManager accountTable] addRecord: model];
//                [WalletUtil setMainAccountWithAccountInfoModel:model];
                
                
//                BackupAccountViewController *vc = [[BackupAccountViewController alloc] init];
//                if (weakSelf.createAccountViewControllerFromVC == CreateAccountViewControllerFromCreatePocketVC) {
//                    vc.backupAccountViewControllerFromVC = BackupAccountViewControllerFromCreatePocketVC;
//                }else if(weakSelf.createAccountViewControllerFromVC == CreateAccountViewControllerFromPocketManagementVC){
//                    vc.backupAccountViewControllerFromVC = BackupAccountViewControllerFromPocketManagementVC;
//                }
//                vc.accountName =  weakSelf.headerView.accountNameTF.text ;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//
//                [weakSelf.loginPasswordView removeFromSuperview];
//
            }else{
                NSLog(@"%@",VALIDATE_STRING(service[@"message"]));
            }
        }
    }];
}

- (void)createAccountWithFrom:(NSString *)from to:(NSString *)to ownerPublicKey:(NSString *)ownerPublicKey activePublicKey:(NSString *)activePublicKey buyRamEOSAmount:(NSString *)buyRamEOSAmount stakeCpuAmount:(NSString *)stakeCpuAmount stakeNetAmount:(NSString *)stakeNetAmount {
    
    _operationType = EOSOperationTypeCreateAccount;
    
    self.create_account_Abi_json_to_bin_request.action = @"newaccount";
    self.create_account_Abi_json_to_bin_request.code = ContractName_EOSIO;
    self.create_account_Abi_json_to_bin_request.creator = from;
    self.create_account_Abi_json_to_bin_request.name = to;
    self.create_account_Abi_json_to_bin_request.ownerPublicKey = ownerPublicKey;
    self.create_account_Abi_json_to_bin_request.activePublicKey = activePublicKey;
    
    WS(weakSelf);
    [self.create_account_Abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        //        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        NSString *binargs = data[@"binargs"];
        if (!binargs) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EOS_CreateAccount_Fail_Noti object:nil];
            return ;
        }
        
        [weakSelf createAccount_buyRamWithEosAmount:buyRamEOSAmount from:from to:to stakeCpuAmount:stakeCpuAmount stakeNetAmount:stakeNetAmount newaccount_binargs:binargs ownerPublicKey:ownerPublicKey activePublicKey:activePublicKey]; // buyRam
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)createAccount_buyRamWithEosAmount:(NSString *)eosAmount from:(NSString *)fromName to:(NSString *)toName stakeCpuAmount:(NSString *)stakeCpuAmount stakeNetAmount:(NSString *)stakeNetAmount newaccount_binargs:(NSString *)newaccount_binargs ownerPublicKey:(NSString *)ownerPublicKey activePublicKey:(NSString *)activePublicKey {
    self.buy_ram_abi_json_to_bin_request.action = ContractAction_BUYRAM;
    self.buy_ram_abi_json_to_bin_request.code = ContractName_EOSIO;
    self.buy_ram_abi_json_to_bin_request.payer = fromName;
    self.buy_ram_abi_json_to_bin_request.receiver = toName;
    self.buy_ram_abi_json_to_bin_request.quant = [NSString stringWithFormat:@"%.4f %@",eosAmount.doubleValue, SymbolName_EOS];
    WS(weakSelf);
    [self.buy_ram_abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        //        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"binargs"] );
        NSString *binargs = data[@"binargs"];
        if (!binargs) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EOS_CreateAccount_Fail_Noti object:nil];
            return ;
        }
        
        [weakSelf createAccount_approveWithCpuAmount:stakeCpuAmount netAmount:stakeNetAmount from:fromName to:toName buyram_binargs:binargs newaccount_binargs:newaccount_binargs ownerPublicKey:ownerPublicKey activePublicKey:activePublicKey]; // cpu/net
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)createAccount_approveWithCpuAmount:(NSString *)cpuAmount netAmount:(NSString *)netAmount from:(NSString *)fromName to:(NSString *)toName buyram_binargs:(NSString *)buyram_binargs newaccount_binargs:(NSString *)newaccount_binargs ownerPublicKey:(NSString *)ownerPublicKey activePublicKey:(NSString *)activePublicKey {
    self.approve_Abi_json_to_bin_request.action = ContractAction_DELEGATEBW;
    self.approve_Abi_json_to_bin_request.code = ContractName_EOSIO;
    self.approve_Abi_json_to_bin_request.from = fromName;
    self.approve_Abi_json_to_bin_request.receiver = toName;
    self.approve_Abi_json_to_bin_request.transfer = @"0";
    
    self.approve_Abi_json_to_bin_request.stake_cpu_quantity = [NSString stringWithFormat:@"%.4f EOS", cpuAmount.doubleValue];
    self.approve_Abi_json_to_bin_request.stake_net_quantity = [NSString stringWithFormat:@"%.4f EOS", netAmount.doubleValue];
    
    WS(weakSelf);
    [self.approve_Abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSString *binargs = data[@"binargs"];
        if (!binargs) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EOS_CreateAccount_Fail_Noti object:nil];
            return ;
        }
        
        weakSelf.createAccountTransferService.available_keys = @[VALIDATE_STRING([EOSWalletInfo getOwnerPublicKey:fromName]) , VALIDATE_STRING([EOSWalletInfo getActivePublicKey:fromName])];
        // newaccount
        weakSelf.createAccountTransferService.newaccount_action = @"newaccount";
        weakSelf.createAccountTransferService.newaccount_code = ContractName_EOSIO;
        weakSelf.createAccountTransferService.newaccount_binargs = newaccount_binargs;
        
        // buyram
        weakSelf.createAccountTransferService.buyram_action = ContractAction_BUYRAM;
        weakSelf.createAccountTransferService.buyram_code = ContractName_EOSIO;
        weakSelf.createAccountTransferService.buyram_binargs = buyram_binargs;
        
        // stake
        weakSelf.createAccountTransferService.stake_action = ContractAction_DELEGATEBW;
        weakSelf.createAccountTransferService.stake_code = ContractName_EOSIO;
        weakSelf.createAccountTransferService.stake_binargs = binargs;
        
        weakSelf.createAccountTransferService.sender = fromName;
        weakSelf.createAccountTransferService.pushTransactionType = CreateAccountPushTransactionTypeTransfer;
        weakSelf.createAccountTransferService.operationType = EOSOperationTypeCreateAccount;
//        weakSelf.createAccountTransferService.permission = @"owner";
        [weakSelf.createAccountTransferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}

- (CreateAccountService *)createAccountService{
    if (!_createAccountService) {
        _createAccountService = [[CreateAccountService alloc] init];
    }
    return _createAccountService;
}

- (Create_account_abi_json_to_bin_request *)create_account_Abi_json_to_bin_request{
    if (!_create_account_Abi_json_to_bin_request) {
        _create_account_Abi_json_to_bin_request = [[Create_account_abi_json_to_bin_request alloc] init];
    }
    return _create_account_Abi_json_to_bin_request;
}

-(CreateAccountTransferService *)createAccountTransferService{
    if (!_createAccountTransferService) {
        _createAccountTransferService = [[CreateAccountTransferService alloc] init];
        _createAccountTransferService.delegate = self;
    }
    return _createAccountTransferService;
}

#pragma mark - 导入
- (void)importWithAccountName:(NSString *)accountName private_activeKey:(NSString *)private_activeKey private_ownerKey:(nullable NSString *)private_ownerKey complete:(EOSImportCompleteBlock)block {
    if (private_ownerKey == nil) {
        if (IsStrEmpty(accountName) || IsStrEmpty(private_activeKey)) {
            [kAppD.window makeToastDisappearWithText:@"请保证输入信息的完整~"];
            block(NO);
            return;
        } else {
            [self validateInputFormatWithAccountName:accountName private_activeKey:private_activeKey private_ownerKey:private_ownerKey complete:block];
        }
    } else {
        if (IsStrEmpty(accountName) ||IsStrEmpty(private_activeKey) || IsStrEmpty(private_ownerKey)) {
            [kAppD.window makeToastDisappearWithText:@"请保证输入信息的完整~"];
            block(NO);
            return;
        } else {
            [self validateInputFormatWithAccountName:accountName private_activeKey:private_activeKey private_ownerKey:private_ownerKey complete:block];
        }
    }
}

// 检查输入的格式
- (void)validateInputFormatWithAccountName:(NSString *)accountName private_activeKey:(NSString *)private_activeKey private_ownerKey:(NSString *)private_ownerKey complete:(EOSImportCompleteBlock)block {
    // 验证账号名私钥格式是否正确
    if (![RegularExpression validateEosAccountName:accountName]) {
        [kAppD.window makeToastDisappearWithText:@"12位字符，只能由小写字母a~z和数字1~5组成。"];
        block(NO);
        return;
    }
    
    private_active_Key_is_validate = [EOS_Key_Encode validateWif:private_activeKey];
    private_owner_Key_is_validate = [EOS_Key_Encode validateWif:private_ownerKey];
    
    if (private_ownerKey == nil) {
        if (private_active_Key_is_validate == YES) {
            [self createPublicKeysWithAccountName:accountName private_activeKey:private_activeKey private_ownerKey:private_ownerKey complete:block];
        }else{
            [kAppD.window makeToastDisappearWithText:@"私钥格式有误!"];
            block(NO);
            return ;
        }
    }else{
        if ((private_owner_Key_is_validate == YES) && (private_active_Key_is_validate == YES)) {
            [self createPublicKeysWithAccountName:accountName private_activeKey:private_activeKey private_ownerKey:private_ownerKey complete:block];
        }else{
            [kAppD.window makeToastDisappearWithText:@"私钥格式有误!"];
            block(NO);
            return ;
        }
    }
}


- (void)createPublicKeysWithAccountName:(NSString *)accountName private_activeKey:(NSString *)private_activeKey private_ownerKey:(NSString *)private_ownerKey complete:(EOSImportCompleteBlock)block {
    // 将用户导入的私钥生成公钥
    
    active_public_key_from_local = [EOS_Key_Encode eos_publicKey_with_wif:private_activeKey];
    if (private_ownerKey != nil) {
        owner_public_key_from_local = [EOS_Key_Encode eos_publicKey_with_wif:private_ownerKey];
    }

    kWeakSelf(self);
    NSDictionary *params = @{@"account":accountName?:@""};
    [RequestService requestWithUrl:eosGet_account_info_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data][Server_Data];
            EOSAccountInfoModel *model = [EOSAccountInfoModel getObjectWithKeyValues:dic];
            // 获取active publickey arr
            NSMutableArray *activePublicKeyArray = [NSMutableArray array];
            [model.permissions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Permission *permissionM = obj;
                if ([permissionM.perm_name isEqualToString:@"active"]) {
                    [permissionM.required_auth.keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Key *keyM = obj;
                        [activePublicKeyArray addObject:keyM.key];
                    }];
                }
            }];
            if (private_ownerKey == nil) {
                if ([activePublicKeyArray containsObject:self->active_public_key_from_local]) {
                    // 本地公钥和网络公钥匹配, 允许进行导入本地操作
                    [weakself configAccountInfoWithAccountName:accountName private_activeKey:private_activeKey private_ownerKey:private_ownerKey];
                    block(YES);
                }else{
                    [kAppD.window makeToastDisappearWithText:@"导入的私钥不匹配!"];
                    block(NO);
                }
            } else {
                // 获取owner publickey arr
                NSMutableArray *ownerPublicKeyArray = [NSMutableArray array];
                [model.permissions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Permission *permissionM = obj;
                    if ([permissionM.perm_name isEqualToString:@"owner"]) {
                        [permissionM.required_auth.keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            Key *keyM = obj;
                            [ownerPublicKeyArray addObject:keyM.key];
                        }];
                    }
                }];
                if ([activePublicKeyArray containsObject:self->active_public_key_from_local] && [ownerPublicKeyArray containsObject:self->owner_public_key_from_local]) {
                    // 本地公钥和网络公钥匹配, 允许进行导入本地操作
                    [weakself configAccountInfoWithAccountName:accountName private_activeKey:private_activeKey private_ownerKey:private_ownerKey];
                    block(YES);
                }else{
                    [kAppD.window makeToastDisappearWithText:@"导入的私钥不匹配!"];
                    block(NO);
                }
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

// config account after import
- (void)configAccountInfoWithAccountName:(NSString *)accountName private_activeKey:(NSString *)private_activeKey private_ownerKey:(NSString *)private_ownerKey {
    EOSWalletInfo *walletInfo = [[EOSWalletInfo alloc] init];
    walletInfo.account_name = accountName;
    walletInfo.account_active_public_key = active_public_key_from_local;
    walletInfo.account_active_private_key = private_activeKey;
    if (private_ownerKey == nil) {
        walletInfo.account_owner_public_key = @"";
        walletInfo.account_owner_private_key = @"";
    } else {
        walletInfo.account_owner_public_key = owner_public_key_from_local;
        walletInfo.account_owner_private_key = private_ownerKey;
    }
    // 存储keychain
    [walletInfo saveToKeyChain];
    
    [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"EOS" address:accountName pubKey:walletInfo.account_owner_public_key privateKey:walletInfo.account_owner_private_key]; // 上报钱包创建

//    AccountInfo *accountInfo = [[AccountInfo alloc] init];
//    accountInfo.account_name = self.headerView.accountNameTF.text;
//    accountInfo.account_img = ACCOUNT_DEFALUT_AVATAR_IMG_URL_STR;
//    accountInfo.account_active_public_key = active_public_key_from_local;
//    accountInfo.account_active_private_key = [AESCrypt encrypt:self.headerView.private_activeKey_tf.text password:self.loginPasswordView.inputPasswordTF.text];
//    if (self.headerView.agreeTermBtn.isSelected == YES) {
//        accountInfo.account_owner_public_key = @"";
//        accountInfo.account_owner_private_key = @"";
//    }else{
//        accountInfo.account_owner_public_key = owner_public_key_from_local;
//        accountInfo.account_owner_private_key = [AESCrypt encrypt:self.headerView.private_ownerKey_TF.text password:self.loginPasswordView.inputPasswordTF.text];
//    }
//    accountInfo.is_privacy_policy = @"0";
//
//    NSMutableArray *tmpArr =[[AccountsTableManager accountTable] selectAccountTable];
//    if (tmpArr.count == 0) {
//        [[NSUserDefaults standardUserDefaults] setObject:VALIDATE_STRING(accountInfo.account_name)  forKey:Current_Account_name];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//
//    [[AccountsTableManager accountTable] addRecord:accountInfo];
//    [WalletUtil setMainAccountWithAccountInfoModel:accountInfo];
    
    [kAppD.window makeToastDisappearWithText:@"导入账号成功!"];
    
//    self.backupEOSAccountService.backupEosAccountRequest.uid = CURRENT_WALLET_UID;
//    self.backupEOSAccountService.backupEosAccountRequest.eosAccountName = accountName;
//    [self.backupEOSAccountService backupAccount:^(id service, BOOL isSuccess) {
//        if (isSuccess) {
//            NSLog(@"备份到服务器成功!");
//        }
//    }];
    
//    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window setRootViewController: [[BaseTabBarController alloc] init]];
}

//- (Get_account_permission_service *)get_account_permission_service{
//    if (!_get_account_permission_service) {
//        _get_account_permission_service = [[Get_account_permission_service alloc] init];
//    }
//    return _get_account_permission_service;
//}
//
//- (BackupEOSAccountService *)backupEOSAccountService{
//    if (!_backupEOSAccountService) {
//        _backupEOSAccountService = [[BackupEOSAccountService alloc] init];
//    }
//    return _backupEOSAccountService;
//}


#pragma mark - 转账
- (void)transferWithSymbol:(EOSSymbolModel *)symbolM From:(NSString *)fromName to:(NSString *)toName amount:(NSString *)amount memo:(NSString *)memo {
//    if (IsStrEmpty(toName)) {
//        [kAppD.window makeToastDisappearWithText:@"收币人不能为空"];
//        return;
//    }
//    if (IsStrEmpty(amount)) {
//        [kAppD.window makeToastDisappearWithText:@"请填写金额"];
//        return;
//    }
    
    _operationType = EOSOperationTypeTransfer;
    
    // 验证密码输入是否正确
//    Wallet *current_wallet = CURRENT_WALLET;
//    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
//        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
//        return;
//    }
//    if (IsNilOrNull(self.currentToken)) {
//        NSLog(@"当前账号未添加资产", nil);
//        return;
//    }
//    self.transferAbi_json_to_bin_request.code = self.currentToken.contract_name;
    self.transferAbi_json_to_bin_request.code = symbolM.code;
    
//    NSString *percision = [NSString stringWithFormat:@"%lu", [NSString getDecimalStringPercisionWithDecimalStr:self.currentToken.balance]];
    NSString *decimalBalance = [[NSString stringWithFormat:@"%@",symbolM.balance] removeFloatAllZero];
    NSString *percision = [NSString stringWithFormat:@"%lu", [NSString getDecimalStringPercisionWithDecimalStr:decimalBalance]];
//    self.transferAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:@"%.*f", percision.intValue, amount.doubleValue], self.currentToken.token_symbol];
    self.transferAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:@"%.*f", percision.intValue, amount.doubleValue], symbolM.symbol];
    
    self.transferAbi_json_to_bin_request.action = ContractAction_TRANSFER;
    self.transferAbi_json_to_bin_request.from = fromName;
    self.transferAbi_json_to_bin_request.to = toName;
    self.transferAbi_json_to_bin_request.memo = memo;
    WS(weakSelf);
    [self.transferAbi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        
//        EOS_BaseResult *result = [EOS_BaseResult mj_objectWithKeyValues:data];
        NSString *binargs = data[@"binargs"];
        if (!binargs) {
//            [kAppD.window makeToastDisappearWithText:result.message];
            [[NSNotificationCenter defaultCenter] postNotificationName:EOS_Transfer_Fail_Noti object:nil];
            return ;
        }
//        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",binargs);
//        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:CURRENT_ACCOUNT_NAME];
        
        weakSelf.mainService.available_keys = @[VALIDATE_STRING([EOSWalletInfo getOwnerPublicKey:fromName]) , VALIDATE_STRING([EOSWalletInfo getActivePublicKey:fromName])];

        weakSelf.mainService.action = ContractAction_TRANSFER;
//        weakSelf.mainService.code = weakSelf.currentToken.contract_name;
        weakSelf.mainService.code = symbolM.code;
//        weakSelf.mainService.sender = CURRENT_ACCOUNT_NAME;
        weakSelf.mainService.sender = fromName;
#pragma mark -- [@"data"]
        weakSelf.mainService.binargs = binargs;
        weakSelf.mainService.pushTransactionType = PushTransactionTypeTransfer;
//        weakSelf.mainService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        weakSelf.transferService.operationType = EOSOperationTypeTransfer;
        [weakSelf.mainService pushTransaction];
//        [weakSelf removeLoginPasswordView];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (TransferAbi_json_to_bin_request *)transferAbi_json_to_bin_request{
    if (!_transferAbi_json_to_bin_request) {
        _transferAbi_json_to_bin_request = [[TransferAbi_json_to_bin_request alloc] init];
    }
    return _transferAbi_json_to_bin_request;
}

- (TransferService *)mainService{
    if (!_mainService) {
        _mainService = [[TransferService alloc] init];
        _mainService.delegate = self;
    }
    return _mainService;
}


#pragma mark - CPU/NET(抵押/赎回)
- (void)stakeWithCpuAmount:(NSString *)cpuAmount netAmount:(NSString *)netAmount from:(NSString *)fromName to:(NSString *)toName operationType:(EOSOperationType)operationType {
//    if (IsStrEmpty(cpuAmount) && IsStrEmpty(netAmount)) {
//        [kAppD.window makeToastDisappearWithText:@"输入不能为空!"];
//        return;
//    }
//
//    if (cpuAmount.doubleValue > self.eosResourceResult.data.core_liquid_balance.doubleValue  || netAmount.doubleValue > self.eosResourceResult.data.core_liquid_balance.doubleValue || (cpuAmount.doubleValue + netAmount.doubleValue)  > self.eosResourceResult.data.core_liquid_balance.doubleValue) {
//        [kAppD.window makeToastDisappearWithText:@"可用余额不足"];
//        return;
//    }
    
    _operationType = operationType;
    
    // 验证密码输入是否正确
//    Wallet *current_wallet = CURRENT_WALLET;
//    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
//        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
//        return;
//    }
    
//    if (self.headerView.cpuNetManageHeaderViewCurrentAction == CpuNetManageHeaderViewCurrentActionApprove) {
        // 质押
//        [self approveWithCpuAmount:cpuAmount netAmount:netAmount];
//    }else if (self.headerView.cpuNetManageHeaderViewCurrentAction == CpuNetManageHeaderViewCurrentActionUnstake) {
        // 赎回
//        [self unStakeWithCpuAmount:cpuAmount netAmount:netAmount];
//    }
//    [self.view addSubview:self.loginPasswordView];
    if (operationType == EOSOperationTypeStake) {
        [self approveWithCpuAmount:cpuAmount netAmount:netAmount from:fromName to:toName];
    } else if (operationType == EOSOperationTypeReclaim) {
        [self unStakeWithCpuAmount:cpuAmount netAmount:netAmount from:fromName to:toName];
    }
}

- (void)approveWithCpuAmount:(NSString *)cpuAmount netAmount:(NSString *)netAmount from:(NSString *)fromName to:(NSString *)toName {
    self.approve_Abi_json_to_bin_request.action = ContractAction_DELEGATEBW;
    self.approve_Abi_json_to_bin_request.code = ContractName_EOSIO;
//    self.approve_Abi_json_to_bin_request.from = self.eosResourceResult.data.account_name;
//    self.approve_Abi_json_to_bin_request.receiver = self.eosResourceResult.data.account_name;
    self.approve_Abi_json_to_bin_request.from = fromName;
    self.approve_Abi_json_to_bin_request.receiver = toName;
    self.approve_Abi_json_to_bin_request.transfer = @"0";
    
    self.approve_Abi_json_to_bin_request.stake_cpu_quantity = [NSString stringWithFormat:@"%.4f EOS", cpuAmount.doubleValue];
    self.approve_Abi_json_to_bin_request.stake_net_quantity = [NSString stringWithFormat:@"%.4f EOS", netAmount.doubleValue];
    
    WS(weakSelf);
    [self.approve_Abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
//        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        NSString *binargs = data[@"binargs"];
        if (!binargs) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EOS_Approve_Fail_Noti object:nil];
            return ;
        }

//        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.available_keys = @[VALIDATE_STRING([EOSWalletInfo getOwnerPublicKey:fromName]) , VALIDATE_STRING([EOSWalletInfo getActivePublicKey:fromName])];
        weakSelf.transferService.action = ContractAction_DELEGATEBW;
        weakSelf.transferService.sender = fromName;
        weakSelf.transferService.code = ContractName_EOSIO;
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = binargs;
        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
//        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        weakSelf.transferService.operationType = EOSOperationTypeStake;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)unStakeWithCpuAmount:(NSString *)cpuAmount netAmount:(NSString *)netAmount from:(NSString *)fromName to:(NSString *)toName {
    self.unstakeEosAbiJsonTobinRequest.action = ContractAction_UNDELEGATEBW;
    self.unstakeEosAbiJsonTobinRequest.code = ContractName_EOSIO;
//    self.unstakeEosAbiJsonTobinRequest.from = self.eosResourceResult.data.account_name;
//    self.unstakeEosAbiJsonTobinRequest.receiver = self.eosResourceResult.data.account_name;
    self.unstakeEosAbiJsonTobinRequest.from = fromName;
    self.unstakeEosAbiJsonTobinRequest.receiver = toName;
    
    self.unstakeEosAbiJsonTobinRequest.unstake_cpu_quantity = [NSString stringWithFormat:@"%.4f EOS", cpuAmount.doubleValue];
    self.unstakeEosAbiJsonTobinRequest.unstake_net_quantity = [NSString stringWithFormat:@"%.4f EOS", netAmount.doubleValue];
    WS(weakSelf);
    [self.unstakeEosAbiJsonTobinRequest postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
//        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        NSString *binargs = data[@"binargs"];
        if (!binargs) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EOS_Unstake_Fail_Noti object:nil];
            return ;
        }
//        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.available_keys = @[VALIDATE_STRING([EOSWalletInfo getOwnerPublicKey:fromName]) , VALIDATE_STRING([EOSWalletInfo getActivePublicKey:fromName])];
        weakSelf.transferService.action = ContractAction_UNDELEGATEBW;
        weakSelf.transferService.sender = fromName;
        weakSelf.transferService.code = ContractName_EOSIO;
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = binargs;
        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
//        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        weakSelf.transferService.operationType = EOSOperationTypeReclaim;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)buildDataSource{
    WS(weakSelf);
    self.eosResourceService.getAccountRequest.name = self.eosResourceResult.data.account_name;
    [self.eosResourceService get_account:^(EOSResourceResult *result, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.eosResourceResult = result;
//            [weakSelf.headerView updateViewWithEOSResourceResult:weakSelf.eosResourceResult];
        }
    }];
}

- (Approve_Abi_json_to_bin_request *)approve_Abi_json_to_bin_request{
    if (!_approve_Abi_json_to_bin_request) {
        _approve_Abi_json_to_bin_request = [[Approve_Abi_json_to_bin_request alloc] init];
    }
    return _approve_Abi_json_to_bin_request;
}

- (UnstakeEosAbiJsonTobinRequest *)unstakeEosAbiJsonTobinRequest{
    if (!_unstakeEosAbiJsonTobinRequest) {
        _unstakeEosAbiJsonTobinRequest = [[UnstakeEosAbiJsonTobinRequest alloc] init];
    }
    return _unstakeEosAbiJsonTobinRequest;
}

-(TransferService *)transferService{
    if (!_transferService) {
        _transferService = [[TransferService alloc] init];
        _transferService.delegate = self;
    }
    return _transferService;
}


#pragma mark - RAM(内存管理)
- (void)stakeWithEosAmount:(NSString *)eosAmount from:(NSString *)fromName to:(NSString *)toName bytes:(NSString *)bytes operationType:(EOSOperationType)operationType {
//    if (IsStrEmpty(eosAmount)) {
//        [kAppD.window makeToastDisappearWithText:@"输入不能为空!"];
//        return;
//    }
    
//    if (self.headerView.ramManageHeaderViewCurrentAction == RamManageHeaderViewCurrentActionBuyRam) {
//        if (eosAmount.doubleValue > self.eosResourceResult.data.core_liquid_balance.doubleValue ) {
//            [kAppD.window makeToastDisappearWithText:@"可用余额不足"];
//            return;
//        }
//    }
    
    
    // 验证密码输入是否正确
//    Wallet *current_wallet = CURRENT_WALLET;
//    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
//        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
//        return;
//    }
    
    _operationType = operationType;
    
    [self tradeRamWithEosAmount:eosAmount from:fromName to:toName bytes:bytes operationType:operationType];
//    [self.view addSubview:self.loginPasswordView];
}

- (void)tradeRamWithEosAmount:(NSString *)eosAmount from:(NSString *)fromName to:(NSString *)toName bytes:(NSString *)bytes operationType:(EOSOperationType)operationType {
//    if (self.headerView.ramManageHeaderViewCurrentAction == RamManageHeaderViewCurrentActionBuyRam) {
//        [self buyRamWithEosAmount:eosAmount];
//    }else if (self.headerView.ramManageHeaderViewCurrentAction == RamManageHeaderViewCurrentActionSellRam){
//        [self sellRamWithEosAmount:eosAmount];
//    }
    if (operationType == EOSOperationTypeBuyRam) {
        [self buyRamWithEosAmount:eosAmount from:fromName to:toName];
    } else if (operationType == EOSOperationTypeSellRam) {
        [self sellRamWithBytes:bytes from:fromName];
    }
}

- (void)buyRamWithEosAmount:(NSString *)eosAmount from:(NSString *)fromName to:(NSString *)toName {
    self.buy_ram_abi_json_to_bin_request.action = ContractAction_BUYRAM;
    self.buy_ram_abi_json_to_bin_request.code = ContractName_EOSIO;
//    self.buy_ram_abi_json_to_bin_request.payer = self.eosResourceResult.data.account_name;
    self.buy_ram_abi_json_to_bin_request.payer = fromName;
//    self.buy_ram_abi_json_to_bin_request.receiver = self.eosResourceResult.data.account_name;
    self.buy_ram_abi_json_to_bin_request.receiver = toName;
    self.buy_ram_abi_json_to_bin_request.quant = [NSString stringWithFormat:@"%.4f %@",eosAmount.doubleValue, SymbolName_EOS];
    WS(weakSelf);
    [self.buy_ram_abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
//        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"binargs"] );
        NSString *binargs = data[@"binargs"];
        if (!binargs) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EOS_BuyRam_Fail_Noti object:nil];
            return ;
        }

        weakSelf.transferService.available_keys = @[VALIDATE_STRING([EOSWalletInfo getOwnerPublicKey:fromName]) , VALIDATE_STRING([EOSWalletInfo getActivePublicKey:fromName])];
//        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.action = ContractAction_BUYRAM;
        weakSelf.transferService.sender = fromName;
        weakSelf.transferService.code = ContractName_EOSIO;
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = binargs;
        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
//        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        weakSelf.transferService.operationType = EOSOperationTypeBuyRam;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)sellRamWithBytes:(NSString *)bytes from:(NSString *)fromName {
    self.sell_ram_abi_json_to_bin_request.action = ContractAction_SELLRAM;
    self.sell_ram_abi_json_to_bin_request.code = ContractName_EOSIO;
//    self.sell_ram_abi_json_to_bin_request.account = self.eosResourceResult.data.account_name;
    self.sell_ram_abi_json_to_bin_request.account = fromName;
//    NSNumber *bytes = @(eosAmount.doubleValue * 1024);
    self.sell_ram_abi_json_to_bin_request.bytes = @([bytes doubleValue]);
    WS(weakSelf);
    [self.sell_ram_abi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
//        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"binargs"] );
        NSString *binargs = data[@"binargs"];
        if (!binargs) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EOS_SellRam_Fail_Noti object:nil];
            return ;
        }

//        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
        weakSelf.transferService.available_keys = @[VALIDATE_STRING([EOSWalletInfo getOwnerPublicKey:fromName]) , VALIDATE_STRING([EOSWalletInfo getActivePublicKey:fromName])];
        weakSelf.transferService.action = ContractAction_SELLRAM;
        weakSelf.transferService.sender = fromName;
        weakSelf.transferService.code = ContractName_EOSIO;
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = binargs;
        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
//        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        weakSelf.transferService.operationType = EOSOperationTypeSellRam;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}


// TransferServiceDelegate
extern NSString *TradeRamDidSuccessNotification;
//- (void)pushTransactionDidFinish:(EOSResourceResult *)result{
//    if ([result.code isEqualToNumber:@0]) {
//        [kAppD.window makeToastDisappearWithText:@"交易成功!"];
//    }else{
//        [kAppD.window makeToastDisappearWithText:result.message];
////        [TOASTVIEW showWithText: result.message];
//    }
////    [self removeLoginPasswordView];
//    [self loadNewData];
////    self.headerView.eosAmountTF.text = nil;
//}

- (void)loadNewData{
    WS(weakSelf);
    self.eosResourceService.getAccountRequest.name = self.eosResourceResult.data.account_name;
    [self.eosResourceService get_account:^(EOSResourceResult *result, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.eosResourceResult = result;
//            [weakSelf.headerView updateViewWithEOSResourceResult:weakSelf.eosResourceResult];
        }
    }];
}


- (Sell_ram_abi_json_to_bin_request *)sell_ram_abi_json_to_bin_request{
    if (!_sell_ram_abi_json_to_bin_request) {
        _sell_ram_abi_json_to_bin_request = [[Sell_ram_abi_json_to_bin_request alloc] init];
    }
    return _sell_ram_abi_json_to_bin_request;
}

- (Buy_ram_abi_json_to_bin_request *)buy_ram_abi_json_to_bin_request{
    if (!_buy_ram_abi_json_to_bin_request) {
        _buy_ram_abi_json_to_bin_request = [[Buy_ram_abi_json_to_bin_request alloc] init];
    }
    return _buy_ram_abi_json_to_bin_request;
}

#pragma mark - TransferServiceDelegate (转账回调)
extern NSString *TradeBandwidthDidSuccessNotification;
-(void)pushTransactionDidFinish:(EOS_TransactionResult *)result{
    DDLogDebug(@"pushTransactionDidFinish:%@",result);
    if (_operationType == EOSOperationTypeTransfer) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EOS_Transfer_Success_Noti object:@(_operationType)];
    } else if (_operationType == EOSOperationTypeStake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EOS_Approve_Success_Noti object:@(_operationType)];
    } else if (_operationType == EOSOperationTypeReclaim) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EOS_Unstake_Success_Noti object:@(_operationType)];
    } else if (_operationType == EOSOperationTypeBuyRam) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EOS_BuyRam_Success_Noti object:@(_operationType)];
    } else if (_operationType == EOSOperationTypeSellRam) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EOS_SellRam_Success_Noti object:@(_operationType)];
    } else if (_operationType == EOSOperationTypeCreateAccount) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EOS_CreateAccount_Success_Noti object:@(_operationType)];
    }
    
    //    if ([result.code isEqualToNumber:@0 ]) {
    //
    ////        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }else{
    //        [kAppD.window makeToastDisappearWithText:result.message];
    ////        [TOASTVIEW showWithText: result.message];
    //    }
}

- (void)answerQuestionDidFinish:(EOS_TransactionResult *)result {
    DDLogDebug(@"answerQuestionDidFinish:%@",result);
}


- (void)approveDidFinish:(EOS_TransactionResult *)result {
    DDLogDebug(@"approveDidFinish:%@",result);
}


- (void)askQuestionDidFinish:(EOS_TransactionResult *)result {
    DDLogDebug(@"askQuestionDidFinish:%@",result);
}


- (void)registeToVoteSystemQuestionDidFinish:(EOS_TransactionResult *)result {
    DDLogDebug(@"registeToVoteSystemQuestionDidFinish:%@",result);
}

@end
