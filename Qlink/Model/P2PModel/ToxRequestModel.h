//
//  ToxRequestModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/23.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface ToxRequestModel : BBaseModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *data;

@end
