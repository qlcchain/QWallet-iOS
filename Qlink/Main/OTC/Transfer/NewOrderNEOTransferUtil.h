//
//  NewOrderTransferUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/8/20.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NEOTransferSuccessBlock)(NSString *sendAddress, NSString *txid);

@interface NewOrderNEOTransferUtil : NSObject

+ (void)transferNEO:(NSString *)tokenName amountStr:(NSString *)amountStr successB:(NEOTransferSuccessBlock)successB;


@end

NS_ASSUME_NONNULL_END
