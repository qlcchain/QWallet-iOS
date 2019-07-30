//
//  QLCWallet.h
//  Qlink
//
//  Created by Jelly Foo on 2019/5/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLCWallet : NSObject

@property (nonatomic, strong, readonly) NSString *privateKey;
@property (nonatomic, strong, readonly) NSString *publicKey;
@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong, readonly) NSString *seed;

+ (instancetype)create;
+ (instancetype)importWithSeed:(NSString *)seed;
+ (instancetype)importWithMnemonic:(NSString *)mnemonic;
+ (instancetype)switchWalletWithSeed:(NSString *)seed;
+ (NSString *)exportMnemonic:(NSString *)seed;
+ (void)sendAssetWithFrom:(NSString *)from tokenName:(NSString *)tokenName to:(NSString *)to amount:(NSUInteger)amount sender:(nullable NSString *)sender receiver:(nullable NSString *)receiver message:(nullable NSString *)message privateKey:(NSString * _Nonnull)privateKey successHandler:(void(^_Nonnull)(NSString * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;
+ (void)receive_accountsPending:(NSString *)address successHandler:(void(^_Nonnull)(NSArray * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;
+ (void)receive_blocksInfo:(NSString *)blockHash receiveAddress:(NSString *)receiveAddress privateKey:(NSString *)privateKey successHandler:(void(^_Nonnull)(NSString * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;

@end
