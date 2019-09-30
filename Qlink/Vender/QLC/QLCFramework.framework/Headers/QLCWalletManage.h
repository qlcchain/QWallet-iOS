//
//  QLCWalletManage.h
//  Qlink
//
//  Created by Jelly Foo on 2019/5/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern  NSString * _Nonnull const QLC_AccountPending_Done_Noti;

@interface QLCWalletManage : NSObject

@property (nonatomic, strong) NSString *qlcMainAddress;

+ (instancetype)shareInstance;
- (BOOL)createWallet;
- (BOOL)importWalletWithSeed:(NSString *)seed;
- (BOOL)importWalletWithMnemonic:(NSString *)mnemonic;
- (BOOL)walletSeedIsValid:(NSString *)seed;
- (BOOL)walletMnemonicIsValid:(NSString *)mnemonic;
- (NSString *)exportMnemonicWithSeed:(NSString *)seed;
- (NSString *)walletAddress;
- (NSString *)walletPrivateKeyStr;
- (NSString *)walletPublicKeyStr;
- (NSString *)walletSeed;
- (BOOL)walletAddressIsValid:(NSString *)address;
- (BOOL)switchWalletWithSeed:(NSString *)seed;
- (void)sendAssetWithTokenName:(NSString *)tokenName to:(NSString *)to amount:(NSUInteger)amount sender:(nullable NSString *)sender receiver:(nullable NSString *)receiver message:(nullable NSString *)message isMainNetwork:(BOOL)isMainNetwork workInLocal:(BOOL)workInLocal successHandler:(void(^_Nonnull)(NSString * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;
- (void)receive_accountsPending:(NSString *)address isMainNetwork:(BOOL)isMainNetwork;

+ (void)signAndWork:(NSDictionary *)dic publicKey:(NSString *)publicKey privateKey:(NSString *)privateKey resultHandler:(void(^_Nonnull)(NSDictionary * _Nullable responseDic))resultHandler;

@end
