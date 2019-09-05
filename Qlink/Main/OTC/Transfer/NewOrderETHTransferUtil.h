//
//  NewOrderTransferUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/8/20.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ETHTransferSuccessBlock)(NSString *sendAddress, NSString *txid);

@interface NewOrderETHTransferUtil : NSObject

+ (void)transferETH:(NSString *)tokenName amountStr:(NSString *)amountStr successB:(ETHTransferSuccessBlock)successB;

@end

NS_ASSUME_NONNULL_END
