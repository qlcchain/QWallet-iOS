//
//  AgentModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/11/1.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AgentModel : BBaseModel

@property (nonatomic, copy) NSString *agent;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *appBuild;

@end

NS_ASSUME_NONNULL_END
