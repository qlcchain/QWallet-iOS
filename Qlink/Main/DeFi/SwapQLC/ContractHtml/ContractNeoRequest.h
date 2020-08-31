//
//  ContractNeoRequest.h
//  Qlink
//
//  Created by 旷自辉 on 2020/8/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractNeoRequest : UIView

+ (ContractNeoRequest *)addContractNeoRequest;
+ (void)removeContractNeoRequest:(ContractNeoRequest *)contractV;
- (void) testNeoContract;
@end

NS_ASSUME_NONNULL_END
