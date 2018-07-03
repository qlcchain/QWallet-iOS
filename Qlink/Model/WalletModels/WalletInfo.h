//
//  WalletInfo.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface WalletInfo : BBaseModel

@property (nonatomic ,strong) NSString *privateKey;
@property (nonatomic ,strong) NSString *publicKey;
@property (nonatomic ,strong) NSString *scriptHash;
@property (nonatomic ,strong) NSString *address;
@property (nonatomic ,strong) NSString *wif;



@end
