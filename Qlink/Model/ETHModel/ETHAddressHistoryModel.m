//
//  ETHAddressHistoryModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/8.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHAddressHistoryModel.h"
#import "NSString+RemoveZero.h"

@implementation Operation

- (NSString *)getTokenNum {
    NSString *decimals = [NSString stringWithFormat:@"1e-%@",self.tokenInfo.decimals];
    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
    NSNumber *balanceNum = @([[NSString stringWithFormat:@"%@",self.value] doubleValue]);
    NSNumber *numberNum = @([decimalsNum doubleValue]*[balanceNum doubleValue]);
    NSString *num = [[NSString stringWithFormat:@"%@",numberNum] removeFloatAllZero];
    return num;
}

@end

@implementation ETHAddressHistoryModel

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"operations" : @"Operation"};
}


@end
