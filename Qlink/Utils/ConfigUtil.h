//
//  ConfigUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigUtil : NSObject
    
+ (NSString *)getServerDomain;
+ (NSString *)getMIFI;
+ (NSString *)getChannel;
@end
