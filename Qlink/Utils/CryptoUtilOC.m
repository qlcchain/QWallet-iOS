//
//  CryptoUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/18.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CryptoUtilOC.h"
#import <eosFramework/EOS_Key_Encode.h>
#import <eosFramework/EosByteWriter.h>
#import <eosFramework/Sha256.h>
#import <eosFramework/uECC.h>
#import <eosFramework/rmd160.h>
#import <eosFramework/libbase58.h>

@implementation CryptoUtilOC

// EOS
+ (NSString *)eosSignWithPrivateKey:(NSString *)privateKey message:(NSString *)message {
    NSString *wif = privateKey;
    NSString *signResult = @"";
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:wif] bytes];
    if (!private_key) {
        NSLog(@"private_key can't be nil!");
        return signResult;
    }
    
    EosByteWriter *writer = [[EosByteWriter alloc] initWithCapacity:255];
    [writer putBytes:[message dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *writerData = [writer toBytes];
    Sha256 *sha256 = [[Sha256 alloc] initWithData:writerData];
//    Sha256 *sha256 = [[Sha256 alloc] initWithData:[EosByteWriter getBytesForSignature:self.chain_Id andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:255]];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(private_key, sha256.mHashBytesData.bytes, signature);
    
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
    }else{
        unsigned char bin[65+4] = { 0 };
        unsigned char *rmdhash = NULL;
        int binlen = 65+4;
        int headerBytes = recId + 27 + 4;
        bin[0] = (unsigned char)headerBytes;
        memcpy(bin + 1, signature, uECC_BYTES * 2);
        
        unsigned char temp[67] = { 0 };
        memcpy(temp, bin, 65);
        memcpy(temp + 65, "K1", 2);
        
        rmdhash = RMD(temp, 67);
        memcpy(bin + 1 +  uECC_BYTES * 2, rmdhash, 4);
        
        char sigbin[100] = { 0 };
        size_t sigbinlen = 100;
        b58enc(sigbin, &sigbinlen, bin, binlen);
        
        NSString *signatureStr = [NSString stringWithFormat:@"SIG_K1_%@", [NSString stringWithUTF8String:sigbin]];
        signResult = signatureStr;
        
//        // 校验
//        NSString *public = @"EOS6zegAh68vCp5mkG1vcWZAD8FJz6UquoB6Y45h9vktfWLWoa7fN";
//        const int8_t *publick_key = [[EOS_Key_Encode getRandomBytesDataWithWif:public] bytes];
//        // Returns 1 if the signature is valid, 0 if it is invalid.
//        int verify = uECC_verify(publick_key,
//                                 sha256.mHashBytesData.bytes,
//                                 signature);
//        NSLog(@"verify = %@",@(verify));
    }
    return signResult;
}

@end
