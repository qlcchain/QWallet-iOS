//
//  NSString+Valid.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/16.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Valid)

- (BOOL)containChinese;
- (BOOL)containUppercase;
- (BOOL)containLowercase;
- (BOOL)containDigital;
- (BOOL)isNumber;
- (BOOL)isNumberDecimal;

@end

NS_ASSUME_NONNULL_END
