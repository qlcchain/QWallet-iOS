//
//  TokenListHelper.h
//  Qlink
//
//  Created by Jelly Foo on 2019/11/27.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ETHAddressInfoModel,EOSAddressInfoModel,NEOAddressInfoModel,QLCAddressInfoModel,NEOAssetModel,Token,QLCTokenModel;

@interface TokenListHelper : NSObject

//+ (void)refreshTokenList;
//+ (ETHAddressInfoModel *)getEthModel;
//+ (EOSAddressInfoModel *)getEosModel;
//+ (NEOAddressInfoModel *)getNeoModel;
//+ (QLCAddressInfoModel *)getQlcModel;

#pragma mark - Request
+ (void)requestETHAddressInfo:(NSString *)address showLoad:(BOOL)showLoad completeBlock:(void(^)(ETHAddressInfoModel *infoM, BOOL success))completeBlock;
+ (void)requestNEOAddressInfo:(NSString *)address showLoad:(BOOL)showLoad completeBlock:(void(^)(NEOAddressInfoModel *infoM, BOOL success))completeBlock;
+ (void)requestEOSTokenList:(NSString *)account_name showLoad:(BOOL)showLoad completeBlock:(void(^)(EOSAddressInfoModel *infoM, BOOL success))completeBlock;
+ (void)requestQLCAddressInfo:(NSString *)address showLoad:(BOOL)showLoad completeBlock:(void(^)(QLCAddressInfoModel *infoM, BOOL success))completeBlock;

#pragma mark - Asset
+ (void)requestNEOAssetWithAddress:(NSString *)address tokenName:(NSString *)tokenName completeBlock:(void(^)(NEOAddressInfoModel *infoM, NEOAssetModel *tokenM, BOOL success))completeBlock;
+ (void)requestETHAssetWithAddress:(NSString *)address tokenName:(NSString *)tokenName completeBlock:(void(^)(ETHAddressInfoModel *infoM, Token *tokenM, Token *ethTokenM, BOOL success))completeBlock;
+ (void)requestQLCAssetWithAddress:(NSString *)address tokenName:(NSString *)tokenName completeBlock:(void(^)(QLCAddressInfoModel *infoM, QLCTokenModel *tokenM, BOOL success))completeBlock;


@end

NS_ASSUME_NONNULL_END
