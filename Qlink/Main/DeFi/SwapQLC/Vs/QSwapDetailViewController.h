//
//  QSwapDetailViewController.h
//  Qlink
//
//  Created by 旷自辉 on 2020/8/22.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseViewController.h"
@class QSwapHashModel;

NS_ASSUME_NONNULL_BEGIN

@interface QSwapDetailViewController : QBaseViewController

- (instancetype)initWithSwapHashModel:(QSwapHashModel *) hashM withStatuString:(NSString *) statusString;

@end

NS_ASSUME_NONNULL_END
