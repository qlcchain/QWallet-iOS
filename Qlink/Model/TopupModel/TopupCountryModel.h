//
//  TopupCountryModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/12/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopupCountryModel : BBaseModel

@property (nonatomic, strong) NSString *code;// = CN;
@property (nonatomic, strong) NSString *globalRoaming;// = "+86";
@property (nonatomic, strong) NSString *imgPath;// = "/......";
@property (nonatomic, strong) NSString *name;// = "中国";
@property (nonatomic, strong) NSString *nameEn;// = China;

@end

NS_ASSUME_NONNULL_END
