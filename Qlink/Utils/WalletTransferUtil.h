//
//  WalletTransferUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletTransferUtil : NSObject

+ (instancetype)getShareObject;
- (void)startFetchServerMainAddress;

@end

NS_ASSUME_NONNULL_END
