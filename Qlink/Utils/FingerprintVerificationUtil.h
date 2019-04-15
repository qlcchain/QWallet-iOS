//
//  FingetprintVerificationUtil.h
//  PNRouter
//
//  Created by Jelly Foo on 2018/9/10.
//  Copyright © 2018年 旷自辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FingerprintVerificationUtil : NSObject

+ (void)show:(void (^)(BOOL success))block;

@end
