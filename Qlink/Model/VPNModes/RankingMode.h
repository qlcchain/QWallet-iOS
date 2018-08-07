//
//  RankingMode.h
//  Qlink
//
//  Created by 旷自辉 on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface RankingMode : BBaseModel

@property (nonatomic , strong) NSString *actEndDate;
@property (nonatomic , strong) NSString *actStatus;
@property (nonatomic , strong) NSString *actStartDate;
@property (nonatomic , strong) NSString *actId;
@property (nonatomic , strong) NSString *actName;
@property (nonatomic , strong) NSString *actAmount;

@end
