//
//  HistoryChartView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/19.
//  Copyright © 2018 pan. All rights reserved.
//

#import "HistoryChartView.h"
#import <Charts/Charts-Swift.h>
#import "UIColor+Random.h"
#import "GlobalConstants.h"

@interface HistoryChartView ()  <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (nonatomic, strong) NSMutableArray *lineArr;
@property (nonatomic, strong) NSString *currentSymbol;
@property (nonatomic, copy) HistoryChartNoDataBlock noDataB;

@end

@implementation HistoryChartView

+ (instancetype)getInstance {
    HistoryChartView *view = [[[NSBundle mainBundle] loadNibNamed:@"HistoryChartView" owner:self options:nil] lastObject];
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
    
    // x-axis limit line
    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
    llXAxis.lineWidth = 4.0;
    llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
    llXAxis.labelPosition = ChartLimitLabelPositionBottomRight;
    llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
    
    //[_chartView.xAxis addLimitLine:llXAxis];
    
    _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
    _chartView.xAxis.gridLineDashPhase = 0.f;
    
//    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:150.0 label:@"Upper Limit"];
//    ll1.lineWidth = 4.0;
//    ll1.lineDashLengths = @[@5.f, @5.f];
//    ll1.labelPosition = ChartLimitLabelPositionRightTop;
//    ll1.valueFont = [UIFont systemFontOfSize:10.0];
    
//    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:-30.0 label:@"Lower Limit"];
//    ll2.lineWidth = 4.0;
//    ll2.lineDashLengths = @[@5.f, @5.f];
//    ll2.labelPosition = ChartLimitLabelPositionRightBottom;
//    ll2.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
//    [leftAxis addLimitLine:ll1];
//    [leftAxis addLimitLine:ll2];
    leftAxis.axisMaximum = 200.0;
    leftAxis.axisMinimum = -50.0;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _chartView.rightAxis.enabled = NO;
    
    //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
    //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
    
//    BalloonMarker *marker = [[BalloonMarker alloc]
//                             initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
//                             font: [UIFont systemFontOfSize:12.0]
//                             textColor: UIColor.whiteColor
//                             insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
//    marker.chartView = _chartView;
//    marker.minimumSize = CGSizeMake(80.f, 40.f);
//    _chartView.marker = marker;
    
    _chartView.legend.form = ChartLegendFormLine;
    
//    _sliderX.value = 45.0;
//    _sliderY.value = 100.0;
//    [self slidersValueChanged:nil];
    
    [_chartView animateWithXAxisDuration:2];
}

- (void)refreshLeftAxisWithMax:(double)max min:(double)min {
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.axisMaximum = max;
    leftAxis.axisMinimum = min;
}

- (void)updateWithSymbol:(NSString *)symbol noDataBlock:(HistoryChartNoDataBlock)noDataBlock {
    _noDataB = noDataBlock;
    _currentSymbol = symbol;
    [self requestBinaKlinesWithSymbol:symbol];
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
        set1.drawValuesEnabled = NO;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:values label:_currentSymbol?:@""];
        
        set1.drawIconsEnabled = NO;
        set1.drawValuesEnabled = NO;
        set1.lineDashLengths = @[@5.f, @2.5f];
        set1.highlightLineDashLengths = @[@5.f, @2.5f];
//        [set1 setColor:UIColor.blackColor];
//        [set1 setCircleColor:UIColor.blackColor];
        [set1 setColor:[UIColor mainColor]];
        [set1 setCircleColor:[UIColor mainColor]];
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
    }
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
- (void)requestBinaKlinesWithSymbol:(NSString *)symbol {
    kWeakSelf(self);
    NSString *interval = @"1m";
    NSDictionary *params = @{@"symbol":symbol,@"interval":interval, @"size":@(20)};
    [RequestService requestWithUrl5:binaKlines_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            [weakself.lineArr removeAllObjects];
            NSArray *arr = [responseObject objectForKey:Server_Data];
            [weakself.lineArr addObjectsFromArray:arr];
            [weakself updateChartData];
            if (weakself.lineArr.count <= 0) {
                if (weakself.noDataB) {
                    weakself.noDataB();
                }
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
}

@end
