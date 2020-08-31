//
//  QSwapStatusManager.h
//  Qlink
//
//  Created by 旷自辉 on 2020/8/24.
//  Copyright © 2020 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSwapStatusManager : NSObject
+ (instancetype) getShareQSwapStatusManager;
- (void) updateSwapStatusWithPrames:(NSArray *) parames;

@end

NS_ASSUME_NONNULL_END
