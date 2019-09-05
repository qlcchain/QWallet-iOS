//
//  NewOrderTransferUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/8/20.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewOrderQLCTransferUtil : NSObject

+ (void)transferQLC:(NSString *)tokenName amountStr:(NSString *)amountStr successB:(void(^)(NSString *sendAddress, NSString *txid))successB;

@end

NS_ASSUME_NONNULL_END
