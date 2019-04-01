//
//  AppConfigUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/6.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppConfigUtil : NSObject

//@property (nonatomic) BOOL hideBottomWhenPush;
@property (nonatomic, strong) NSArray *mnemonicArr;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
