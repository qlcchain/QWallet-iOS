//
//  HistoryChartView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/19.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QLCHistoryChartView.h"
#import <Charts/Charts-Swift.h>
#import "UIColor+Random.h"
#import "GlobalConstants.h"

@interface CubicLineSampleFillFormatter : NSObject <IChartFillFormatter>
{
}
@end

@implementation CubicLineSampleFillFormatter

- (CGFloat)getFillLinePositionWithDataSet:(LineChartDataSet *)dataSet dataProvider:(id<LineChartDataProvider>)dataProvider
{
    return -10.f;
}

@end

@interface QLCHistoryChartView ()  <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (nonatomic, strong) NSMutableArray *lineArr;
@property (nonatomic, strong) NSString *currentSymbol;
@property (nonatomic, copy) HistoryChartNoDataBlock noDataB;
@property (nonatomic, copy) HistoryChartHaveDataBlock haveDataB;

@end

@implementation QLCHistoryChartView

+ (instancetype)getInstance {
    QLCHistoryChartView *view = [[[NSBundle mainBundle] loadNibNamed:@"QLCHistoryChartView" owner:self options:nil] lastObject];
    [view configInit];
    return view;
}

- (void)configInit {
    _lineArr = [NSMutableArray array];

    _chartView.delegate = self;

    _chartView.chartDescription.enabled = NO;

    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
//    _chartView.maxHighlightDistance = 300.0;
    _chartView.userInteractionEnabled = NO;
    _chartView.xAxis.enabled = NO;
    _chartView.noDataText = @"";

    ChartYAxis *yAxis = _chartView.leftAxis;
    yAxis.drawLabelsEnabled = NO;
    yAxis.drawAxisLineEnabled = NO;
//    yAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
//    [yAxis setLabelCount:6 force:NO];
//    yAxis.labelTextColor = UIColor.redColor;
//    yAxis.labelPosition = YAxisLabelPositionInsideChart;
    yAxis.drawGridLinesEnabled = NO;
//    yAxis.axisLineColor = UIColor.blueColor;

    _chartView.rightAxis.enabled = NO;
    _chartView.legend.enabled = NO;

    [_chartView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
    
//    _lineArr = [NSMutableArray array];
//
//    _chartView.delegate = self;
//
//    _chartView.chartDescription.enabled = NO;
//
//    _chartView.dragEnabled = YES;
//    [_chartView setScaleEnabled:YES];
//    _chartView.pinchZoomEnabled = YES;
//    _chartView.drawGridBackgroundEnabled = NO;
//
//    _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
//    _chartView.xAxis.gridLineDashPhase = 0.f;
//
//    ChartYAxis *leftAxis = _chartView.leftAxis;
//    [leftAxis removeAllLimitLines];
//    leftAxis.axisMaximum = 200.0;
//    leftAxis.axisMinimum = -50.0;
//    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
//    leftAxis.drawZeroLineEnabled = NO;
//    leftAxis.drawLimitLinesBehindDataEnabled = YES;
//
//    _chartView.rightAxis.enabled = NO;
//
//    _chartView.legend.form = ChartLegendFormLine;
//
//    [_chartView animateWithXAxisDuration:2];
}

- (void)refreshLeftAxisWithMax:(double)max min:(double)min {
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.axisMaximum = max;
    leftAxis.axisMinimum = min;
}

- (void)updateWithSymbol:(NSString *)symbol frequency:(NSString *)frequency noDataBlock:(HistoryChartNoDataBlock)noDataBlock haveDataBlock:(HistoryChartHaveDataBlock)haveDataBlock {
    _noDataB = noDataBlock;
    _haveDataB = haveDataBlock;
    _currentSymbol = symbol;
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 延时
        [weakself requestBinaKlinesWithSymbol:symbol frequency:frequency];
    });
    
    if (_noDataB) {
        _noDataB();
    }
}

- (void)updateChartData {
    NSInteger usingIndex = 1;
    NSMutableArray *usingDataArr = [NSMutableArray array];
    [_lineArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *tempArr = obj;
        [usingDataArr addObject:tempArr[usingIndex]];
    }];
    double maxLeftAxis = [[usingDataArr valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double minLeftAxis = [[usingDataArr valueForKeyPath:@"@min.doubleValue"] doubleValue];
    [self refreshLeftAxisWithMax:maxLeftAxis min:minLeftAxis];

    NSMutableArray *values = [[NSMutableArray alloc] init];

    for (int i = 0; i < _lineArr.count; i++) {
        double val = [_lineArr[i][1] doubleValue];
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:val icon: [UIImage imageNamed:@"icon"]]];
    }

    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        [set1 replaceEntries: values];
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:values label:_currentSymbol?:@""];
        
        set1.mode = LineChartModeCubicBezier;
        set1.cubicIntensity = 0.2;

        set1.drawIconsEnabled = NO;
        set1.drawValuesEnabled = NO;
        set1.drawCirclesEnabled = NO;
//        set1.lineDashLengths = @[@5.f, @2.5f];
//        set1.highlightLineDashLengths = @[@5.f, @2.5f];
//        [set1 setColor:UIColor.blackColor];
//        [set1 setCircleColor:UIColor.blackColor];
        [set1 setColor:[UIColor mainColor]];
        [set1 setCircleColor:[UIColor mainColor]];
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
//        set1.formLineDashLengths = @[@5.f, @2.5f];
//        set1.formLineWidth = 1.0;
//        set1.formSize = 15.0;

        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#FFFFFF"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#EBF5FF"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);

        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
//        set1.drawHorizontalHighlightIndicatorEnabled = NO;
//        set1.fillFormatter = [[CubicLineSampleFillFormatter alloc] init];


        CGGradientRelease(gradient);

        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];

        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];

        _chartView.data = data;
    }
    
//    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
//
//    for (int i = 0; i < _lineArr.count; i++) {
//        double val = [_lineArr[i][1] doubleValue];
//        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
//    }
//
//    LineChartDataSet *set1 = nil;
//    if (_chartView.data.dataSetCount > 0)
//    {
//        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
//        [set1 replaceEntries:yVals1];
//        [_chartView.data notifyDataChanged];
//        [_chartView notifyDataSetChanged];
//    }
//    else
//    {
//        set1 = [[LineChartDataSet alloc] initWithEntries:yVals1 label:@"DataSet 1"];
//        set1.mode = LineChartModeCubicBezier;
//        set1.cubicIntensity = 0.2;
//        set1.drawCirclesEnabled = NO;
//        set1.lineWidth = 1.8;
//        set1.circleRadius = 4.0;
//        [set1 setCircleColor:UIColor.whiteColor];
//        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//        [set1 setColor:UIColor.whiteColor];
//        set1.fillColor = UIColor.whiteColor;
//        set1.fillAlpha = 1.f;
//        set1.drawHorizontalHighlightIndicatorEnabled = NO;
//        set1.fillFormatter = [[CubicLineSampleFillFormatter alloc] init];
//
//        LineChartData *data = [[LineChartData alloc] initWithDataSet:set1];
//        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.f]];
//        [data setDrawValues:NO];
//
//        _chartView.data = data;
//    }
}


#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

#pragma mark - Request
- (void)requestBinaKlinesWithSymbol:(NSString *)symbol frequency:(NSString *)frequency {
    kWeakSelf(self);
//    NSString *interval = @"1m";
    NSString *interval = frequency;
    NSDictionary *params = @{@"symbol":symbol,@"interval":interval, @"size":@(100)};
    [RequestService requestWithUrl10:binaKlines_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeRelease successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.lineArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [weakself.lineArr addObjectsFromArray:arr];
            [weakself updateChartData];
            if (weakself.lineArr.count <= 0) {
                if (weakself.noDataB) {
                    weakself.noDataB();
                }
            } else {
                if (weakself.haveDataB) {
                    weakself.haveDataB();
                }
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (weakself.noDataB) {
            weakself.noDataB();
        }
    }];
}

@end
