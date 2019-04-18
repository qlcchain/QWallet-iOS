//
//  FinanceOrderListModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/12.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface FinanceOrderModel : BBaseModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSNumber *addRevenue; // = 0;
@property (nonatomic, strong) NSNumber *amount; // = 1;
@property (nonatomic, strong) NSNumber *dueDays; // = 31;
@property (nonatomic, strong) NSString *productName; // = "QLC锁仓30天";
@property (nonatomic, strong) NSString *status; // = PAY;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *orderTime;
@property (nonatomic, strong) NSString *maturityTime;

@end

@interface FinanceOrderListModel : BBaseModel

//@property (nonatomic, strong) NSString *balance; // = "105.9";
@property (nonatomic, strong) NSArray *orderList; // =     (
@property (nonatomic, strong) NSNumber *yesterdayRevenue; // = 0;
@property (nonatomic, strong) NSNumber *totalQlc; // = 2;
@property (nonatomic, strong) NSNumber *totalRevenue; // = 0;

@end
