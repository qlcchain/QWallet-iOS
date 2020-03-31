//
//  EOSTraceModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/4.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSTraceModel.h"
//#import "NSString+RemoveZero.h"
#import "RLArithmetic.h"

@implementation EOSTraceModel

- (NSString *)getTokenNum {
    NSString *num = self.quantity.mul(@(1));
//    NSString *num = [[NSString stringWithFormat:@"%@",self.quantity] removeFloatAllZero];
    return num;
}

@end
