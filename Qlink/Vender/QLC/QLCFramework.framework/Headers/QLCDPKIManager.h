//
//  DPKIManager.h
//  QLCFramework
//
//  Created by Jelly Foo on 2020/2/3.
//  Copyright © 2020 Jelly Foo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCDPKIManager : NSObject

/// Get all the verifiers
/// Parameters:
///     null
/// Returns:
///     account : verifier account
///     type : verifier type
///     id : verifier address to receive verify request
+ (void)getAllVerifiers:(NSString *)baseUrl successHandler:(void(^_Nonnull)(NSArray * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;


/// Get a publish block to publish a id/publicKey pair
/// Parameters:
///     account : account to publish
///     type : verifier type (email/weChat)
///     id : id address
///     pubKey : public key
///     fee : fee of this publish (5 qgas at least)
///     verifiers : verifiers to verify this id
/// Returns:
///     block : publish block
///     verifiers : verifier info with a random verification code
+ (void)getPublishBlock:(NSString *)baseUrl params:(NSDictionary *)params successHandler:(void(^_Nonnull)(NSDictionary * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;

/// signature
+ (NSString *)qlcSign:(NSString *)messageHex publicKey:(NSString *)publicKey privateKey:(NSString *)privateKey;

/// Check block base info, update chain info for the block, and broadcast block
/// Parameters:
///     block: block
/// Returns:
///     string: hash of the block
+ (void)process:(NSString *)baseUrl params:(NSDictionary *)params successHandler:(void(^_Nonnull)(NSString * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;

/// Get publish info by type and id address
/// Parameters:
///     type : verifier type (email/weChat)
///     id : id address
/// Returns:
///     publishInfo : published infos
+ (void)getPubKeyByTypeAndID:(NSString *)baseUrl type:(NSString *)type ID:(NSString *)ID successHandler:(void(^_Nonnull)(NSArray * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;

/// Get a unpublish block to unpublish a id/publicKey pair
/// Parameters:
///     account : account to publish
///     type : verifier type (email/weChat)
///     id : id address
///     pubKey : public key to unpublish
///     hash : hash returned by dpki_getPublishBlock
/// Returns:
///     block : unpublish block
+ (void)getUnPublishBlock:(NSString *)baseUrl params:(NSDictionary *)params successHandler:(void(^_Nonnull)(NSDictionary * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;

/// Get up to 5 active verifiers of specified type, active means have sent a oracle block in last 24 hours.
/// Parameters:
/// type : verifier type (email/weChat)
/// Returns:
/// account : verifier account
/// type : verifier type
/// id : verifier address to receive verify request
+ (void)getActiveVerifiers:(NSString *)baseUrl type:(NSString *)type successHandler:(void(^_Nonnull)(NSArray * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;

/// Get the recommend public key by type and id, will only return one record.
/// Parameters:
/// type : id type (email/weChat)
/// id : id address
/// Returns:
/// publishInfo : published infos
/// publishHeight : publish time
/// verifiedHeight : the time of this record's state changed from unverified to verified
/// verifiedStatus : verified status(0:unverified 1:verified)
/// oracleAccounts : verifiers that make the proof for this publish
+ (void)getRecommendPubKey:(NSString *)baseUrl type:(NSString *)type ID:(NSString *)ID successHandler:(void(^_Nonnull)(NSArray * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;

/// Get all the specified type of verifiers
/// Parameters:
/// type : verifier type (email/weChat)
/// Returns:
/// account : verifier account
/// type : verifier type
/// id : verifier address to receive verify request
+ (void)getVerifiersByType:(NSString *)baseUrl type:(NSString *)type successHandler:(void(^_Nonnull)(NSArray * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;

/// Return public key for account address
/// Parameters:
/// string : account address
/// Returns:
/// string : public key
+ (void)getAccountPublicKey:(NSString *)baseUrl address:(NSString *)address successHandler:(void(^_Nonnull)(NSString * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;

@end

NS_ASSUME_NONNULL_END
