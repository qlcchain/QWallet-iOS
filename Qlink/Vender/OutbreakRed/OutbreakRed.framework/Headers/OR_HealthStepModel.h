//
//  OR_HealthStepModel.h
//  OutbreakRed
//
//  Created by Jelly Foo on 2020/4/15.
//  Copyright © 2020 Jelly Foo. All rights reserved.
//

#import <OutbreakRed/OutbreakRed.h>

NS_ASSUME_NONNULL_BEGIN

@interface OR_HealthStepModel : OR_BBaseModel

@property (nonatomic , copy) NSString * _Nonnull dateString;//时间戳，表示数据对应的时间 注意是整点数的时间戳，如2017-10-28 0:0:0
@property (nonatomic, strong) NSNumber * _Nonnull step;

@end

NS_ASSUME_NONNULL_END
