//
//  DefiHistoricalStatsListModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/7.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DefiHistoricalStatsListModel : BBaseModel


@property (nonatomic, strong) NSString *ethPoor;// = "-48.748051441933";
@property (nonatomic, strong) NSString *statsDate;// = "2020-05-06 17:00:00";
@property (nonatomic, strong) NSString *tvlEth;// = 0;
@property (nonatomic, strong) NSString *usdPoor;// = "-10007";

@property (nonatomic, strong) NSString *tvlUsd;// = 0;

@property (nonatomic, strong) NSString *eth;// = 0;
@property (nonatomic, strong) NSString *dai;// = 0;
@property (nonatomic, strong) NSString *btc;// = 0;



@end

NS_ASSUME_NONNULL_END
