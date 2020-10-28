//
//  WalletSignUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2020/10/23.
//  Copyright © 2020 pan. All rights reserved.
//

#import "WalletSignUtil.h"
#import <ETHFramework/ETHFramework.h>
#import "RequestService.h"
#import "ServerConstants.h"

@implementation WalletSignUtil

+ (void) signAndSendEthTranserWithPamaerDic:(NSDictionary *) signDic gasPrice:(NSString *)gasPrice sendComplete:(sendComplete)sendComplete {
    
    if (signDic && signDic.count > 0) {
                
        NSInteger gasLimit = [WalletSignUtil numberWithHexString:signDic[@"gas"]?:@"21000"];
        
        NSInteger nonce = [WalletSignUtil numberWithHexString:signDic[@"nonce"]?:@"139"];
         NSString *tranerValue = signDic[@"value"]?:@"0x";
        
         NSLog(@"%ld-----%@------%ld----%@",gasLimit,gasPrice,nonce,tranerValue);

        
         [[TrustWalletManage sharedInstance] sendSignAndTranserFromAddress:signDic[@"from"]?:@"" toAddress:signDic[@"to"]?:@"" amount:tranerValue gasLimit:gasLimit gasPrice:[gasPrice integerValue] nonce:[NSString stringWithFormat:@"%ld",nonce] signData:signDic[@"data"]?:@"0x" isCoin:YES sendComplete:^(BOOL isComplte, NSString *result) {
             sendComplete(isComplte,result);
         }];
        
    } else {
        sendComplete(NO,@"");
    }
   
}


+ (NSInteger)numberWithHexString:(NSString *)hexString{

    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    
    int hexNumber;
    
    sscanf(hexChar, "%x", &hexNumber);
    
    NSLog(@"%ld", (NSInteger)hexNumber);
    
    return (NSInteger)hexNumber;
}

+ (void) getEthWalletPrivate:(NSString *) address getComplete:(getComplete) getComplete {
    
    [TrustWalletManage.sharedInstance exportPrivateKeyWithAddress:address?:@"" :^(NSString * privateKey) {
        getComplete(privateKey);
    }];
}


@end
