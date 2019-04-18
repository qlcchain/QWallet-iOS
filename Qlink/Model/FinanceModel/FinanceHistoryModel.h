//
//  FinanceHistoryModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface FinanceHistoryModel : BBaseModel

@property (nonatomic, strong) NSNumber *amount; //" : 1.00,
@property (nonatomic, strong) NSString *address; //" : "AbLSovbur8DHHwJdwDjCqEtDERnNMNnZhA",
@property (nonatomic, strong) NSString *createTime; //" : "2019-04-18 15:27",
@property (nonatomic, strong) NSString *ID; //" : "a99d868ea8cf4003be4f987d1f59a8a5",
@property (nonatomic, strong) NSString *type; //" : "BUY",
@property (nonatomic, strong) NSString *productName; // " : "QLC日日盈"

@end
