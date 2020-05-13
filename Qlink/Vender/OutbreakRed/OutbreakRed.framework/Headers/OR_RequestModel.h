//
//  OR_RequestModel.h
//  OutbreakRed
//
//  Created by Jelly Foo on 2020/4/15.
//  Copyright © 2020 Jelly Foo. All rights reserved.
//

#import "OR_BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OR_RequestModel : OR_BBaseModel

@property (nonatomic, copy) NSString *p2pId;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *appBuild;
@property (nonatomic, copy) NSString *serverEnv;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
