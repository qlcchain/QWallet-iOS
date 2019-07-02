//
//  NSNumber+RemoveZero.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/19.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (RemoveZero)

- (NSString *)show4floatStr;
- (NSString *)showfloatStr:(NSNumber *)decimal;

@end

NS_ASSUME_NONNULL_END
