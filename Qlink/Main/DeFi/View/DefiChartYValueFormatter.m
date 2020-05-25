//
//  DefiChartYValueFormatter.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/21.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DefiChartYValueFormatter.h"
#import "NSString+RemoveZero.h"

@interface DefiChartYValueFormatter ()
{
//    NSDateFormatter *_dateFormatter;
}
@end


@implementation DefiChartYValueFormatter

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
    NSString *valueStr = [NSString stringWithFormat:@"%@",@(value)];
    NSString *resultStr = @"";
    if (_inputType == DefiChartTypeTVLUSD) {
         NSString *tvlUsd_defi = [valueStr showfloatStr_Defi:2];
         resultStr = [NSString stringWithFormat:@"$%@",tvlUsd_defi];
     } else if (_inputType == DefiChartTypeETH) {
         NSString *eth_defi = [valueStr showfloatStr_Defi:2];
         resultStr = [NSString stringWithFormat:@"%@ ETH",eth_defi];
     } else if (_inputType == DefiChartTypeDAI) {
          NSString *dai_defi = [valueStr showfloatStr_Defi:2];
         resultStr = [NSString stringWithFormat:@"%@",dai_defi];
     } else if (_inputType == DefiChartTypeBTC) {
         NSString *btc_defi = [valueStr showfloatStr_Defi:2];
        resultStr = [NSString stringWithFormat:@"%@ BTC",btc_defi];
    }
    
    return resultStr;
//    return [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:value]];
}

@end
