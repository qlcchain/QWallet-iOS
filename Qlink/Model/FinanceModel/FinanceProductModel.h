//
//  FinanceProductModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface FinanceProductModel : BBaseModel

@property (nonatomic, strong) NSNumber *timeLimit; //" : 30,
@property (nonatomic, strong) NSNumber *annualIncomeRate; //" : 0.20,
@property (nonatomic, strong) NSString *name; //" : "QLC锁仓30天",
@property (nonatomic, strong) NSString *enName; //" : "xxxxxxxxxxxxxxxxxxxx",
@property (nonatomic, strong) NSString *ID; //" : "a721b33c572742d097e36c75f0089ce4",
@property (nonatomic, strong) NSNumber *leastAmount; //" : 1,
@property (nonatomic, strong) NSString *status; // " : "ON_SALE"  "NEW"  "SELL_OUT"  "END"
@property (nonatomic, strong) NSString *point; // "高收益",

@end
