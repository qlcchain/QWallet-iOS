//
//  NSString+Trim.h
//  PNRouter
//
//  Created by 旷自辉 on 2019/3/27.
//  Copyright © 2019 旷自辉. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Trim)
 + (NSString *)trim:(NSString *)val trimCharacterSet:(NSCharacterSet *)characterSet;
 + (NSString *)trimWhitespace:(NSString *)val;
 + (NSString *)trimNewline:(NSString *)val;
 + (NSString *)trimWhitespaceAndNewline:(NSString *)val;
@end

NS_ASSUME_NONNULL_END
