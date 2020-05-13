//
//  HistoryChartView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/19.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DefiProjectListModel;

typedef void(^HistoryChartNoDataBlock)(void);
typedef void(^HistoryChartHaveDataBlock)(void);

typedef NS_ENUM(NSUInteger, DefiChartType) {
    DefiChartTypeTVLUSD,
    DefiChartTypeETH,
    DefiChartTypeDAI,
    DefiChartTypeBTC,
};

@interface DefiChartView : UIView

@property (nonatomic, strong) DefiProjectListModel *inputProjectListM;
@property (nonatomic) DefiChartType inputType;

+ (instancetype)getInstance;
- (void)configWithNoDataBlock:(HistoryChartNoDataBlock)noDataBlock haveDataBlock:(HistoryChartHaveDataBlock)haveDataBlock;
- (void)refreshChart;
- (void)handlerData:(NSDictionary *)responseObject;

@end

NS_ASSUME_NONNULL_END
