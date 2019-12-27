//
//  TokenListHelper.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/27.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TokenListHelper.h"
#import "WalletCommonModel.h"
#import <ETHFramework/ETHFramework.h>
#import <QLCFramework/QLCFramework.h>
#import <eosFramework/eosFramework.h>
#import "Qlink-Swift.h"
#import "GlobalConstants.h"
#import "ETHAddressInfoModel.h"
#import "NEOAddressInfoModel.h"
#import "EOSAddressInfoModel.h"
#import "QLCAddressInfoModel.h"
#import "QLCTokenInfoModel.h"

@interface TokenListHelper ()

//@property (nonatomic, strong) ETHAddressInfoModel *ethM;
//@property (nonatomic, strong) NEOAddressInfoModel *neoM;
//@property (nonatomic, strong) EOSAddressInfoModel *eosM;
//@property (nonatomic, strong) QLCAddressInfoModel *qlcM;

@end

@implementation TokenListHelper

//+ (instancetype)shareInstance {
//    static id shareObject = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        shareObject = [[self alloc] init];
//    });
//    return shareObject;
//}

//+ (ETHAddressInfoModel *)getEthModel {
//    return [TokenListHelper shareInstance].ethM;
//}
//
//+ (EOSAddressInfoModel *)getEosModel {
//    return [TokenListHelper shareInstance].eosM;
//}
//
//+ (NEOAddressInfoModel *)getNeoModel {
//    return [TokenListHelper shareInstance].neoM;
//}
//
//+ (QLCAddressInfoModel *)getQlcModel {
//    return [TokenListHelper shareInstance].qlcM;
//}

//+ (void)refreshTokenList {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    switch (currentWalletM.walletType) {
//        case WalletTypeETH:
//        {
//            [TokenListHelper requestETHAddressInfo:currentWalletM.address?:@"" showLoad:NO completeBlock:^(ETHAddressInfoModel *tokenM, BOOL success) {
//                [TokenListHelper shareInstance].ethM = tokenM;
//            }];
//        }
//            break;
//        case WalletTypeEOS:
//        {
//            [TokenListHelper requestEOSTokenList:currentWalletM.account_name?:@"" showLoad:NO completeBlock:^(EOSAddressInfoModel *tokenM, BOOL success) {
//                [TokenListHelper shareInstance].eosM = tokenM;
//            }];
//        }
//            break;
//        case WalletTypeNEO:
//        {
//            [TokenListHelper requestNEOAddressInfo:currentWalletM.address?:@"" showLoad:NO completeBlock:^(NEOAddressInfoModel *tokenM, BOOL success) {
//                [TokenListHelper shareInstance].neoM = tokenM;
//            }];
//        }
//            break;
//        case WalletTypeQLC:
//        {
//            [TokenListHelper requestQLCAddressInfo:currentWalletM.address?:@"" showLoad:NO completeBlock:^(QLCAddressInfoModel *tokenM, BOOL success) {
//                [TokenListHelper shareInstance].qlcM = tokenM;
//            }];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

#pragma mark - Request
+ (void)requestETHAddressInfo:(NSString *)address showLoad:(BOOL)showLoad completeBlock:(void(^)(ETHAddressInfoModel *infoM, BOOL success))completeBlock {
    // 检查地址有效性
    BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:address];
    if (!isValid) {
        if (completeBlock) {
            completeBlock(nil,NO);
        }
        return;
    }
//    kWeakSelf(self);
    NSDictionary *params = @{@"address":address,@"token":@""}; // @"0x980e7917c610e2c2d4e669c920980cb1b915bbc7"
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
    }
    [RequestService requestWithUrl5:ethAddressInfo_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            ETHAddressInfoModel *infoM = [ETHAddressInfoModel getObjectWithKeyValues:dic];
            
            NSMutableArray *tokenArr = [NSMutableArray array];
            // 自动添加ETH
            TokenInfo *tokenInfo = [[TokenInfo alloc] init];
            tokenInfo.address = infoM.address;
            tokenInfo.decimals = @"0";
            tokenInfo.name = @"ETH";
            tokenInfo.symbol = @"ETH";
            Token *token = [[Token alloc] init];
            token.balance = infoM.ETH.balance;
            token.tokenInfo = tokenInfo;
            [tokenArr addObject:token];
            [tokenArr addObjectsFromArray:infoM.tokens];
            infoM.tokens = tokenArr;
            
            if (completeBlock) {
                completeBlock(infoM,YES);
            }
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:Update_ETH_Wallet_Token_Noti object:nil];
        } else {
            if (completeBlock) {
                completeBlock(nil,NO);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        if (completeBlock) {
            completeBlock(nil,NO);
        }
    }];
}

+ (void)requestNEOAddressInfo:(NSString *)address showLoad:(BOOL)showLoad completeBlock:(void(^)(NEOAddressInfoModel *infoM, BOOL success))completeBlock {
    // 检查地址有效性
    BOOL validateNEOAddress = [NEOWalletManage.sharedInstance validateNEOAddressWithAddress:address];
    if (!validateNEOAddress) {
        if (completeBlock) {
            completeBlock(nil,NO);
        }
        return;
    }
//    kWeakSelf(self);
    NSDictionary *params = @{@"address":address};
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
    }
    [RequestService requestWithUrl10:neoAddressInfo_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeRelease successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            NEOAddressInfoModel *infoM = [NEOAddressInfoModel getObjectWithKeyValues:dic];
            if (completeBlock) {
                completeBlock(infoM,YES);
            }
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:Update_NEO_Wallet_Token_Noti object:nil];
        } else {
            if (completeBlock) {
                completeBlock(nil,NO);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        
        if (completeBlock) {
            completeBlock(nil,NO);
        }
    }];
}

+ (void)requestEOSTokenList:(NSString *)account_name showLoad:(BOOL)showLoad completeBlock:(void(^)(EOSAddressInfoModel *infoM, BOOL success))completeBlock {
    // 检查地址有效性
    BOOL validateEOSAccountName = [RegularExpression validateEosAccountName:account_name];
    if (!validateEOSAccountName) {
        if (completeBlock) {
            completeBlock(nil,NO);
        }
        return;
    }
//    kWeakSelf(self);
    NSDictionary *params = @{@"account":account_name, @"symbol":@""};
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
    }
    [RequestService requestWithUrl5:eosGet_token_list_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data][Server_Data];
            EOSAddressInfoModel *infoM = [EOSAddressInfoModel getObjectWithKeyValues:dic];
//            NSArray *symbol_list = dic[@"symbol_list"];
            if (completeBlock) {
                completeBlock(infoM,YES);
            }
        } else {
            if (completeBlock) {
                completeBlock(nil,NO);
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        
        if (completeBlock) {
            completeBlock(nil,NO);
        }
    }];
}

+ (void)requestQLCAddressInfo:(NSString *)address showLoad:(BOOL)showLoad completeBlock:(void(^)(QLCAddressInfoModel *infoM, BOOL success))completeBlock {
    // 检查地址有效性
    BOOL validateQLCAddress = [QLCWalletManage.shareInstance walletAddressIsValid:address];
    if (!validateQLCAddress) {
        if (completeBlock) {
            completeBlock(nil,NO);
        }
        return;
    }
//    kWeakSelf(self);
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
    }
    BOOL isMainNetwork = [ConfigUtil isMainNetOfChainNetwork];
    [QLCLedgerRpc accountInfoWithAddress:address isMainNetwork:isMainNetwork successHandler:^(NSDictionary<NSString * ,id> * _Nonnull responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        
        if (responseObject != nil) {
            QLCAddressInfoModel *infoM = [QLCAddressInfoModel getObjectWithKeyValues:responseObject];
            [TokenListHelper requestQLCTokensWithModel:infoM showLoad:NO completeBlock:completeBlock]; // 请求tokens

        } else {
            if (completeBlock) {
                completeBlock(nil,NO);
            }
        }
        
    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        if ([message isEqualToString:@"account not found"]) { // 找不到账户做特殊处理（先显示出来）
            QLCAddressInfoModel *infoM = [QLCAddressInfoModel new];
            infoM.account = address;
            infoM.coinBalance = @(0);
            [TokenListHelper requestQLCTokensWithModel:infoM showLoad:NO completeBlock:completeBlock]; // 请求tokens
            
        } else {
            [kAppD.window makeToastDisappearWithText:message];
            if (completeBlock) {
                completeBlock(nil,NO);
            }
        }
    }];
}

+ (void)requestQLCTokensWithModel:(QLCAddressInfoModel *)infoM showLoad:(BOOL)showLoad completeBlock:(void(^)(QLCAddressInfoModel *tokenM, BOOL success))completeBlock {
//    kWeakSelf(self);
    if (showLoad) {
        [kAppD.window makeToastInView:kAppD.window userInteractionEnabled:NO hideTime:0];
    }
    BOOL isMainNetwork = [ConfigUtil isMainNetOfChainNetwork];
    [QLCLedgerRpc tokensWithIsMainNetwork:isMainNetwork successHandler:^(id _Nullable responseObject) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        
        if (responseObject != nil) {
            NSArray *tokenArr = [QLCTokenInfoModel mj_objectArrayWithKeyValuesArray:responseObject];
            [infoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                QLCTokenModel *tokenM = obj;
                [tokenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    QLCTokenInfoModel *tokenInfoM = obj;
                    if ([tokenM.tokenName isEqualToString:tokenInfoM.tokenName]) {
                        tokenM.tokenInfoM = tokenInfoM;
                        *stop = YES;
                    }
                }];
            }];
            if (completeBlock) {
                completeBlock(infoM,YES);
            }
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:Update_QLC_Wallet_Token_Noti object:nil];
        } else {
            if (completeBlock) {
                completeBlock(nil,NO);
            }
        }
        
    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
        if (showLoad) {
            [kAppD.window hideToast];
        }
        [kAppD.window makeToastDisappearWithText:message];
        if (completeBlock) {
            completeBlock(nil,NO);
        }
    }];
}

#pragma mark - Asset
+ (void)requestNEOAssetWithAddress:(NSString *)address tokenName:(NSString *)tokenName completeBlock:(void(^)(NEOAddressInfoModel *infoM, NEOAssetModel *tokenM, BOOL success))completeBlock {
    
    [TokenListHelper requestNEOAddressInfo:address showLoad:NO completeBlock:^(NEOAddressInfoModel * _Nonnull infoM, BOOL success) {
        if (success) {
            __block NEOAssetModel *tokenM = nil;
            [infoM.balance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NEOAssetModel *model = obj;
                if ([model.asset_symbol isEqualToString:tokenName]) {
                    tokenM = model;
                    *stop = YES;
                }
            }];
            if (completeBlock) {
                completeBlock(infoM, tokenM, YES);
            }
        } else {
            if (completeBlock) {
                completeBlock(nil, nil, NO);
            }
        }
    }];
}

+ (void)requestETHAssetWithAddress:(NSString *)address tokenName:(NSString *)tokenName completeBlock:(void(^)(ETHAddressInfoModel *infoM,Token *tokenM, Token *ethTokenM, BOOL success))completeBlock {
    
    [TokenListHelper requestETHAddressInfo:address showLoad:NO completeBlock:^(ETHAddressInfoModel * _Nonnull infoM, BOOL success) {
        if (success) {
            
            __block Token *tokenM = nil;
            [infoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Token *model = obj;
                if ([model.tokenInfo.symbol isEqualToString:tokenName]) {
                    tokenM = model;
                    *stop = YES;
                }
            }];
            __block Token *ethTokenM = nil;
            [infoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Token *model = obj;
                if ([model.tokenInfo.symbol isEqualToString:@"ETH"]) {
                    ethTokenM = model;
                    *stop = YES;
                }
            }];
            if (completeBlock) {
                completeBlock(infoM, tokenM, ethTokenM, YES);
            }
        } else {
            if (completeBlock) {
                completeBlock(nil, nil, nil, NO);
            }
        }
    }];
    
//    // 检查地址有效性
//    BOOL isValid = [TrustWalletManage.sharedInstance isValidAddressWithAddress:address];
//    if (!isValid) {
//        if (completeBlock) {
//            completeBlock(nil, nil, NO);
//        }
//        return;
//    }
////    kWeakSelf(self);
//    NSDictionary *params = @{@"address":address,@"token":@""}; //
//    [RequestService requestWithUrl5:ethAddressInfo_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//
//        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSDictionary *dic = [responseObject objectForKey:Server_Data];
//            ETHAddressInfoModel *infoM = [ETHAddressInfoModel getObjectWithKeyValues:dic];
//            __block Token *tokenM = nil;
//            [infoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                Token *model = obj;
//                if ([model.tokenInfo.symbol isEqualToString:tokenName]) {
//                    tokenM = model;
//                    *stop = YES;
//                }
//            }];
//            __block Token *ethTokenM = nil;
//            [infoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                Token *model = obj;
//                if ([model.tokenInfo.symbol isEqualToString:@"ETH"]) {
//                    ethTokenM = model;
//                    *stop = YES;
//                }
//            }];
//            if (completeBlock) {
//                completeBlock(tokenM, ethTokenM, YES);
//            }
//        } else {
//            if (completeBlock) {
//                completeBlock(nil, nil, NO);
//            }
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        if (completeBlock) {
//            completeBlock(nil, nil, NO);
//        }
//    }];
}

+ (void)requestQLCAssetWithAddress:(NSString *)address tokenName:(NSString *)tokenName completeBlock:(void(^)(QLCAddressInfoModel *infoM, QLCTokenModel *tokenM, BOOL success))completeBlock {
    
    [TokenListHelper requestQLCAddressInfo:address showLoad:NO completeBlock:^(QLCAddressInfoModel * _Nonnull infoM, BOOL success) {
        if (success) {
            __block QLCTokenModel *tokenM = nil;
            [infoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                QLCTokenModel *model = obj;
                if ([model.tokenName isEqualToString:tokenName]) {
                    tokenM = model;
                    *stop = YES;
                }
            }];

            if (completeBlock) {
                completeBlock(infoM, tokenM, YES);
            }
        } else {
            if (completeBlock) {
                completeBlock(nil, nil, NO);
            }
        }
    }];
    
//    // 检查地址有效性
//    BOOL validateQLCAddress = [QLCWalletManage.shareInstance walletAddressIsValid:address];
//    if (!validateQLCAddress) {
//        if (completeBlock) {
//            completeBlock(nil, NO);
//        }
//        return;
//    }
//    BOOL isMainNetwork = [ConfigUtil isMainNetOfChainNetwork];
//    [QLCLedgerRpc accountInfoWithAddress:address isMainNetwork:isMainNetwork successHandler:^(NSDictionary<NSString * ,id> * _Nonnull responseObject) {
//        if (responseObject != nil) {
//            QLCAddressInfoModel *infoM = [QLCAddressInfoModel getObjectWithKeyValues:responseObject];
//            __block QLCTokenModel *tokenM = nil;
//            [infoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                QLCTokenModel *model = obj;
//                if ([model.tokenName isEqualToString:tokenName]) {
//                    tokenM = model;
//                    *stop = YES;
//                }
//            }];
////            if (completeBlock) {
////                completeBlock(tokenM, YES);
////            }
//            if (!tokenM) {
//                if (completeBlock) {
//                    completeBlock(nil, NO);
//                }
//            } else {
//                [QLCWalletInfo requestQLCTokensWithModel:tokenM completeBlock:completeBlock];
//            }
//        } else {
//            if (completeBlock) {
//                completeBlock(nil, NO);
//            }
//        }
//    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
//        if (completeBlock) {
//            completeBlock(nil, NO);
//        }
//    }];
}

//+ (void)requestQLCTokensWithModel:(QLCTokenModel *)tokenM completeBlock:(void(^)(QLCTokenModel *tokenM, BOOL success))completeBlock {
//    BOOL isMainNetwork = [ConfigUtil isMainNetOfChainNetwork];
//    [QLCLedgerRpc tokensWithIsMainNetwork:isMainNetwork successHandler:^(id _Nullable responseObject) {
//
//        if (responseObject != nil) {
//            NSArray *tokenArr = [QLCTokenInfoModel mj_objectArrayWithKeyValuesArray:responseObject];
////            [infoM.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////                QLCTokenModel *tokenM = obj;
//                [tokenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    QLCTokenInfoModel *tokenInfoM = obj;
//                    if ([tokenM.tokenName isEqualToString:tokenInfoM.tokenName]) {
//                        tokenM.tokenInfoM = tokenInfoM;
//                        *stop = YES;
//                    }
//                }];
////            }];
//            if (completeBlock) {
//                completeBlock(tokenM, YES);
//            }
//
//        } else {
//            if (completeBlock) {
//                completeBlock(nil, NO);
//            }
//        }
//
//    } failureHandler:^(NSError * _Nullable error, NSString * _Nullable message) {
//        if (completeBlock) {
//            completeBlock(nil, NO);
//        }
//    }];
//}

@end
