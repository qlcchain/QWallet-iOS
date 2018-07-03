//
//  ContinentModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface CountryModel : BBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *countryImage;
@property (nonatomic, strong) NSString *countryCode;

@end

@interface ContinentModel : BBaseModel

@property (nonatomic, strong) NSString *continent;
@property (nonatomic, strong) NSArray *country;

@end
