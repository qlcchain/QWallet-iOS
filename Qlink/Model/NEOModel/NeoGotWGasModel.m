//
//  NeoGotWGasModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/15.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NeoGotWGasModel.h"
//#import "NSString+RemoveZero.h"
#import "RLArithmetic.h"

@implementation NeoGotWGasModel

- (NSString *)getNum {
    NSString *num = self.receiveNum.mul(@(1));
//    NSString *num = [[NSString stringWithFormat:@"%@",self.receiveNum] removeFloatAllZero];
    return num;
}

@end
