//
//  HistoryChartView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/19.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HistoryChartNoDataBlock)(void);
typedef void(^HistoryChartHaveDataBlock)(void);

@interface QLCHistoryChartView : UIView

+ (instancetype)getInstance;
- (void)updateWithSymbol:(NSString *)symbol frequency:(NSString *)frequency noDataBlock:(HistoryChartNoDataBlock)noDataBlock haveDataBlock:(HistoryChartHaveDataBlock)haveDataBlock;

@end

NS_ASSUME_NONNULL_END
