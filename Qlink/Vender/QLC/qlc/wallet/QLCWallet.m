//
//  QLCWallet.m
//  Qlink
//
//  Created by Jelly Foo on 2019/5/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QLCWallet.h"
#import "Qlink-Swift.h"
#import "NSString+HexStr.h"

@interface QLCWallet ()

@property (nonatomic, strong) NSString *seed;
@property (nonatomic, strong, readwrite) NSString *address;
@property (nonatomic, strong, readwrite) NSString *privateKey;
@property (nonatomic, strong, readwrite) NSString *publicKey;

@end

@implementation QLCWallet

+ (instancetype)create {
    QLCWallet *wallet = [QLCWallet new];
    wallet.seed = [QLCUtil generateSeed];
    wallet.privateKey = [QLCUtil seedToPrivateKeyWithSeed:wallet.seed index:0];
    wallet.publicKey = [QLCUtil privateKeyToPublicKeyWithPrivateKey:wallet.privateKey];
    wallet.address = [QLCUtil publicKeyToAddressWithPublicKey:wallet.publicKey];
    if (!wallet.seed || !wallet.privateKey || !wallet.publicKey || !wallet.address) {
        return nil;
    }
    return wallet;
}

+ (instancetype)importWithSeed:(NSString *)seed {
    QLCWallet *wallet = [QLCWallet new];
    wallet.seed = seed;
    wallet.privateKey = [QLCUtil seedToPrivateKeyWithSeed:wallet.seed index:0];
    wallet.publicKey = [QLCUtil privateKeyToPublicKeyWithPrivateKey:wallet.privateKey];
    wallet.address = [QLCUtil publicKeyToAddressWithPublicKey:wallet.publicKey];
    if (!wallet.seed || !wallet.privateKey || !wallet.publicKey || !wallet.address) {
        return nil;
    }
    return wallet;
}

+ (instancetype)importWithMnemonic:(NSString *)mnemonic {
    QLCWallet *wallet = [QLCWallet new];
    wallet.seed = [QLCUtil mnemonicToSeedWithMnemonic:mnemonic];
    wallet.privateKey = [QLCUtil seedToPrivateKeyWithSeed:wallet.seed index:0];
    wallet.publicKey = [QLCUtil privateKeyToPublicKeyWithPrivateKey:wallet.privateKey];
    wallet.address = [QLCUtil publicKeyToAddressWithPublicKey:wallet.publicKey];
    if (!wallet.seed || !wallet.privateKey || !wallet.publicKey || !wallet.address) {
        return nil;
    }
    return wallet;
}

+ (NSString *)exportMnemonic:(NSString *)seed {
    if (![QLCUtil isValidSeedWithSeed:seed]) {
        return @"";
    }
    return [QLCUtil seedToMnemonicWithSeed:seed];
}

+ (instancetype)switchWalletWithSeed:(NSString *)seed {
    return [QLCWallet importWithSeed:seed];
}
    
+ (void)sendAssetWithFrom:(NSString *)from tokenName:(NSString *)tokenName to:(NSString *)to amount:(NSUInteger)amount sender:(nullable NSString *)sender receiver:(nullable NSString *)receiver message:(nullable NSString *)message privateKey:(NSString * _Nonnull)privateKey successHandler:(void(^_Nonnull)(NSString * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler {
    [QLCUtil sendAssetFrom:from tokenName:tokenName to:to amount:amount sender:sender receiver:receiver message:message privateKey:privateKey successHandler:successHandler failureHandler:failureHandler];
}

+ (void)receive_accountsPending:(NSString *)address successHandler:(void(^_Nonnull)(NSArray * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler {
    [QLCUtil receive_accountsPendingWithAddress:address successHandler:successHandler failureHandler:failureHandler];
}

+ (void)receive_blocksInfo:(NSString *)blockHash privateKey:(NSString *)privateKey successHandler:(void(^_Nonnull)(NSString * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler {
    [QLCUtil receive_blocksInfoWithBlockHash:blockHash privateKey:privateKey successHandler:successHandler failureHandler:failureHandler];
}

- (NSString *)address {
    return _address;
}

- (NSString *)privateKey {
    return _privateKey;
}

- (NSString *)publicKey {
    return _publicKey;
}

- (NSString *)seed {
    return _seed;
}


@end
