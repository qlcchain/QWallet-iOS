//
//  QLCWalletManage.m
//  Qlink
//
//  Created by Jelly Foo on 2019/5/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QLCWalletManage.h"
#import "QLCWallet.h"
#import "Qlink-Swift.h"
#import "QLCAccountPendingModel.h"

@interface QLCWalletManage ()

@property (nonatomic, strong) QLCWallet *wallet;
@property (nonatomic, strong) NSMutableArray *accountPendingArr;

@end

@implementation QLCWalletManage

+ (instancetype)shareInstance {
    static id shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
        [shareObject addObserve];
    });
    return shareObject;
}

- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(walletChange:) name:Wallet_Change_Noti object:nil];
}

- (BOOL)createWallet {
    _wallet = [QLCWallet create];
    return _wallet!=nil?YES:NO;
}

- (BOOL)importWalletWithSeed:(NSString *)seed {
    _wallet = [QLCWallet importWithSeed:seed];
    return _wallet!=nil?YES:NO;
}

- (BOOL)importWalletWithMnemonic:(NSString *)mnemonic {
    _wallet = [QLCWallet importWithMnemonic:mnemonic];
    return _wallet!=nil?YES:NO;
}

- (NSString *)exportMnemonicWithSeed:(NSString *)seed {
    NSString *mnemonic = [QLCWallet exportMnemonic:seed];
    return mnemonic;
}

- (BOOL)walletSeedIsValid:(NSString *)seed {
    return [QLCUtil isValidSeedWithSeed:seed];
}

- (BOOL)walletMnemonicIsValid:(NSString *)mnemonic {
    return [QLCUtil isValidMnemonicWithMnemonic:mnemonic];
}

- (BOOL)walletAddressIsValid:(NSString *)address {
    return [QLCUtil isValidAddressWithAddress:address];
}

- (BOOL)switchWalletWithSeed:(NSString *)seed {
    _wallet = [QLCWallet switchWalletWithSeed:seed];
    return _wallet!=nil?YES:NO;
}

- (void)sendAssetWithTokenName:(NSString *)tokenName to:(NSString *)to amount:(NSUInteger)amount sender:(nullable NSString *)sender receiver:(nullable NSString *)receiver message:(nullable NSString *)message successHandler:(void(^_Nonnull)(NSString * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler {
    NSString *from = _wallet.address;
    NSString *privateKey = _wallet.privateKey;
    [QLCWallet sendAssetWithFrom:from tokenName:tokenName to:to amount:amount sender:sender receiver:receiver message:message privateKey:privateKey successHandler:successHandler failureHandler:failureHandler];
}

- (void)receive_accountsPending:(NSString *)address {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![self walletAddressIsValid:address]) {
            return;
        }
        kWeakSelf(self);
        [QLCWallet receive_accountsPending:address successHandler:^(NSArray * _Nullable responseObj) {
            weakself.accountPendingArr = [NSMutableArray arrayWithArray:[QLCAccountPendingModel mj_objectArrayWithKeyValuesArray:responseObj]];
            [weakself receiveAsset];
        } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
            
        }];
}

- (void)receiveAsset {
    if (_accountPendingArr && _accountPendingArr.count > 0) {
        QLCAccountPendingModel *firstM = _accountPendingArr.firstObject;
        NSString *privateKey = _wallet.privateKey;
        kWeakSelf(self)
        NSString *showText = [NSString stringWithFormat:@"Account Pending %@",@(_accountPendingArr.count)];
        NSString *receiveAddress = _wallet.address;
        [kAppD.window makeToastInView:kAppD.window text:showText userInteractionEnabled:NO hideTime:0];
        [QLCWallet receive_blocksInfo:firstM.Hash receiveAddress:receiveAddress privateKey:privateKey successHandler:^(NSString * _Nullable responseObj) {
            [kAppD.window hideToast];
            // 成功
            if (weakself.accountPendingArr && weakself.accountPendingArr.count > 0) {
                [weakself.accountPendingArr removeObjectAtIndex:0];
            }
            [weakself receiveAsset];
            if (weakself.accountPendingArr.count <= 0) { // account pending结束
                [[NSNotificationCenter defaultCenter] postNotificationName:QLC_AccountPending_Done_Noti object:nil];
            }
        } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
            [kAppD.window hideToast];
            // 失败（下次打开app会重新进行操作，所以直接删除进行下一个）
            if (weakself.accountPendingArr && weakself.accountPendingArr.count > 0) {
                [weakself.accountPendingArr removeObjectAtIndex:0];
            }
            [weakself receiveAsset];
        }];
    }
}

- (NSString *)walletAddress {
    if (_wallet) {
        return _wallet.address;
    }
    return nil;
}

- (NSString *)walletPrivateKeyStr {
    if (_wallet) {
        return _wallet.privateKey;
    }
    return nil;
}

- (NSString *)walletPublicKeyStr {
    if (_wallet) {
        return _wallet.publicKey;
    }
    return nil;
}

- (NSString *)walletSeed {
    if (_wallet) {
        return _wallet.seed;
    }
    return nil;
}

#pragma mark - Noti
- (void)walletChange:(NSNotification *)noti {
    NSString *address = noti.object;
    [self receive_accountsPending:address];
    
}

@end
