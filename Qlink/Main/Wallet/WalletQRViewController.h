//
//  WalletQRViewController.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseViewController.h"

typedef void (^CodeQRComplete)(NSString *codeValue);

@interface WalletQRViewController : QBaseViewController
@property (nonatomic ,copy) CodeQRComplete completeBlcok;

- (instancetype) initWithCodeQRCompleteBlock:(void (^)(NSString *codeValue)) completion;

@end
