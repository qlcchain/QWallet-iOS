//
//  TopupProductModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopupProductModel : BBaseModel

@property (nonatomic, strong) NSString *countryEn; //" : "中国",
@property (nonatomic, strong) NSString *explain; //" : "1",
@property (nonatomic, strong) NSString *country; //" : "中国",
@property (nonatomic, strong) NSString *descriptionEn; //" : "1",
@property (nonatomic, strong) NSString *isp; //" : "移动",
@property (nonatomic, strong) NSString *Description; //" : "1",
@property (nonatomic, strong) NSNumber *discount; //" : 0.95,
@property (nonatomic, strong) NSNumber *qgasDiscount;
@property (nonatomic, strong) NSString *nameEn; //" : "广东移动",
@property (nonatomic, strong) NSString *amountOfMoney; //" : "50,100,200,300,400,500",
@property (nonatomic, strong) NSString *upTime; //" : "2019-09-25 14:47:17",
@property (nonatomic, strong) NSString *ispEn; //" : "移动",
@property (nonatomic, strong) NSString *province; //" : "广东",
@property (nonatomic, strong) NSString *imgPath; //" : "/",
@property (nonatomic, strong) NSString *name; //" : "广东移动",
@property (nonatomic, strong) NSString *explainEn; //" : "1",
@property (nonatomic, strong) NSString *ID; //" : "56594c9614984f149ec93b51e5161fyy",
@property (nonatomic, strong) NSString *provinceEn; //" : "广东"

@property (nonatomic, strong) NSNumber *amount;

@end

NS_ASSUME_NONNULL_END
