//
//  DefiChartXValueFormatter.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/21.
//  Copyright © 2020 pan. All rights reserved.
//

#import "HistoryChartXValueFormatter.h"
#import "NSDate+Category.h"

@interface HistoryChartXValueFormatter ()
{
//    NSDateFormatter *_dateFormatter;
}
@end

@implementation HistoryChartXValueFormatter

- (id)init
{
    self = [super init];
    if (self)
    {
//        _dateFormatter = [[NSDateFormatter alloc] init];
//        _dateFormatter.dateFormat = @"dd MMM HH:mm";
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    NSString *timestamp = [NSString stringWithFormat:@"%@",@(value)];
    NSString *result = [NSDate getTimeWithTimestamp:timestamp format:MMddHHmm isMil:YES];
//    NSString *result = [NSString stringWithFormat:@"&&%@",@(value)];
    return result;
}

@end
