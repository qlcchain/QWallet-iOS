//
//  OCBaseModel.h
//  
//
//  Created by 1234 on 15/10/13.
//  Copyright © 2015年 life. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface BBaseModel : NSObject <NSCoding>

/**
 *  初始化
 *
 *  @param dic dic description
 *
 *  @return 实例
 */
+ (id)getObjectWithKeyValues:(NSDictionary *)dic;

@end

