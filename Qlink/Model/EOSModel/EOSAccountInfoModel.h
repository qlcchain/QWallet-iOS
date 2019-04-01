//
//  EOSAccountInfoModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Key : BBaseModel

@property (nonatomic, strong) NSString * key;
@property (nonatomic, strong) NSNumber *weight;

@end

@interface RequiredAuth : BBaseModel

@property (nonatomic, strong) NSArray * accounts;
@property (nonatomic, strong) NSArray * keys;
@property (nonatomic, strong) NSNumber *threshold;
@property (nonatomic, strong) NSArray * waits;
@end

@interface Permission : BBaseModel

@property (nonatomic, strong) NSString * parent;
@property (nonatomic, strong) NSString * perm_name;
@property (nonatomic, strong) RequiredAuth * required_auth;

@end

@interface EOSAccountInfoModel : BBaseModel

@property (nonatomic, strong) NSString * create_timestamp;
@property (nonatomic, strong) NSString * creator;
@property (nonatomic, strong) NSArray * permissions;

@end

NS_ASSUME_NONNULL_END
