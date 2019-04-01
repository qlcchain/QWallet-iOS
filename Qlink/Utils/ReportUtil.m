//
//  ReportUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/15.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ReportUtil.h"
#import <TrustCore/Crypto.h>
#import "NSString+HexStr.h"
#import "Qlink-Swift.h"
#import "CryptoUtilOC.h"
#import <ETHFramework/ETHFramework.h>

@implementation ReportUtil

#pragma mark - Request
+ (void)requestWalletReportWalletCreateWithBlockChain:(NSString *)blockChain address:(NSString *)address pubKey:(NSString *)pubKey privateKey:(nullable NSString *)privateKey {
    NSString *myP2pId = [ToxManage getOwnP2PId];
    NSMutableString *signResult = [NSMutableString string];
    __block NSString *pubKeyResult = @"";
    if ([blockChain isEqualToString:@"ETH"]) {
        NSString *inputStr = [myP2pId stringByAppendingString:address];
        NSData *inputData = [inputStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *signArr = [TrustWalletManage.sharedInstance signMessageWithData:inputData address:address];
        NSString *firstSign = [NSString stringWithFormat:@"%@",[NSString numberHexString:[NSString convertDataToHexStr:signArr[0]]]];
        NSString *secondSign = [[NSString convertDataToHexStr:signArr[1]] substringFromIndex:2];
        NSString *thirdSign = [[NSString convertDataToHexStr:signArr[2]] substringFromIndex:2];
        pubKeyResult = [@"0x" stringByAppendingString:pubKey.length==130?[pubKey substringFromIndex:2]:pubKey];
        //27:0xb9405112c4b5ef4708422c54ef628021bf31ba36e9fb2f7905fa66c154f07a77:0x3038142941e80b06f2a573d0c77ee2440c3aeb700f3067ba341314ca459a8d47
        NSString *midStr = @":0x";
        [signResult appendString:firstSign];
        [signResult appendString:midStr];
        [signResult appendString:secondSign];
        [signResult appendString:midStr];
        [signResult appendString:thirdSign];
        NSLog(@"signResult = %@",signResult);
    } else if ([blockChain isEqualToString:@"EOS"]) {
        pubKeyResult = pubKey;
        NSString *inputStr = [myP2pId stringByAppendingString:address];
        NSString *sign = [CryptoUtilOC eosSignWithPrivateKey:privateKey message:inputStr];
        [signResult appendString:sign];
        NSLog(@"signResult = %@",signResult);
    } else if ([blockChain isEqualToString:@"NEO"]) {
        pubKeyResult = pubKey;
        NSString *sign = [CryptoUtil neoutilsignWithDataHex:myP2pId privateKey:privateKey]?:@"";
        [signResult appendString:sign];
        NSLog(@"signResult = %@",signResult);
    }
    
    NSDictionary *params = @{@"p2pId":myP2pId, @"address":address?:@"", @"blockChain":blockChain, @"pubKey":pubKeyResult, @"signData":signResult};
    NSLog(@"上报参数：%@",params);
    [RequestService requestWithUrl:walletReport_wallet_create_v2_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            //            NSDictionary *dic = [responseObject objectForKey:Server_Data];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

+ (void)requestWalletReportWalletRransferWithAddressFrom:(NSString *)addressFrom addressTo:(NSString *)addressTo blockChain:(NSString *)blockChain symbol:(NSString *)symbol amount:(NSString *)amount txid:(NSString *)txid {
    NSDictionary *parames = @{@"addressFrom":addressFrom ,@"txid":txid,@"addressTo":addressTo,@"blockChain":blockChain,@"symbol":symbol,@"amount":amount}; 
    [RequestService requestWithUrl:walletReport_wallet_transfer_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0){
//            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {

    }];
}

@end
