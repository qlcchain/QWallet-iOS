//
//  CurrentWalletInfo.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "CurrentWalletInfo.h"

@implementation CurrentWalletInfo

+ (instancetype) getShareInstance
{
    static id shareObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

- (void) setAttributValueWithWalletInfo:(WalletInfo *) walletInfo
{
    if (walletInfo) {
        _publicKey = walletInfo.publicKey;
        _privateKey = walletInfo.privateKey;
        _address = walletInfo.address;
        _scriptHash = walletInfo.scriptHash;
        _wif = walletInfo.wif;
        
     
        
    }
}

@end
