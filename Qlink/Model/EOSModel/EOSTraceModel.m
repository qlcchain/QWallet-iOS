//
//  EOSTraceModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/4.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSTraceModel.h"
#import "NSString+RemoveZero.h"

@implementation EOSTraceModel

- (NSString *)getTokenNum {
    NSString *num = [[NSString stringWithFormat:@"%@",self.quantity] removeFloatAllZero];
    return num;
}

@end
