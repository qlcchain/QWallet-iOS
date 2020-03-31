//
//  QLCWalletManage.h
//  Qlink
//
//  Created by Jelly Foo on 2019/5/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETHWalletManage : NSObject

@property (nonatomic, strong) NSString *ethMainAddress;

+ (instancetype)shareInstance;


@end
