//
//  EOSResourcePriceModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/13.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EOSResourcePriceModel : BBaseModel

@property (nonatomic, strong) NSString * cpuPriceUnit;
@property (nonatomic, strong) NSString * netPriceUnit;
@property (nonatomic, strong) NSString * ramPriceUnit;
@property (nonatomic, strong) NSNumber * cpuPrice;
@property (nonatomic, strong) NSNumber * netPrice;
@property (nonatomic, strong) NSNumber * ramPrice;

@end

NS_ASSUME_NONNULL_END
