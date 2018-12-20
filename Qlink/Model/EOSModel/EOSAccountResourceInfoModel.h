//
//  EOSAccountResourceInfoModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResourceRam : BBaseModel

@property (nonatomic, strong) NSNumber * available; // " : 10098,
@property (nonatomic, strong) NSNumber * used; //" : 4114

@end

@interface ResourceNet : BBaseModel

@property (nonatomic, strong) NSNumber * max; //" : 101291,
@property (nonatomic, strong) NSNumber * available; //" : 99698,
@property (nonatomic, strong) NSNumber * used; //" : 1593

@end

@interface ResourceCpu : BBaseModel

@property (nonatomic, strong) NSNumber * max; // " : 25060,
@property (nonatomic, strong) NSNumber * available; //" : 16741,
@property (nonatomic, strong) NSNumber * used; //" : 8319

@end

@interface ResourceStaked : BBaseModel

@property (nonatomic, strong) NSString * net_weight;
@property (nonatomic, strong) NSString * cpu_weight;

@end

@interface EOSAccountResourceInfoModel : BBaseModel

@property (nonatomic, strong) ResourceStaked * staked;
@property (nonatomic, strong) ResourceCpu * cpu;
@property (nonatomic, strong) ResourceNet * net;
@property (nonatomic, strong) ResourceRam * ram;


@end

NS_ASSUME_NONNULL_END
