//
//  LocationMode.h
//  Qlink
//
//  Created by 旷自辉 on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface LocationMode : BBaseModel

+ (instancetype) getShareInstance;

@property (nonatomic ,copy) NSString *country;

@end
