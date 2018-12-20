//
//  ToxRequestModel1.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/20.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToxRequestModel1 : BBaseModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END
