//
//  BalanceInfo.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface BalanceInfo : BBaseModel

@property (nonatomic ,strong) NSNumber *qlc;
@property (nonatomic ,strong) NSNumber *neo;
@property (nonatomic ,strong) NSNumber *gas;

- (NSString *)getWinqGas;

@end
