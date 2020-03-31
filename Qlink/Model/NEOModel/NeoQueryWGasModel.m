//
//  NeoQueryWGasModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/15.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NeoQueryWGasModel.h"
//#import "NSString+RemoveZero.h"
#import "RLArithmetic.h"

@implementation NeoQueryWGasModel

- (NSString *)getNum {
    NSString *num = self.winqGas.mul(@(1));
//    NSString *num = [[NSString stringWithFormat:@"%@",self.winqGas] removeFloatAllZero];
    return num;
}

@end
