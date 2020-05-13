//
//  AppConfigUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/6.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutbreakRedUtil : NSObject

@property (nonatomic, strong) NSString *appShow19; // 疫情活动 1:开启
@property (nonatomic, strong) NSString *show19; // 疫情审核

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
