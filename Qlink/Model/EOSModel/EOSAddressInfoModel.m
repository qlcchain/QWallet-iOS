//
//  EOSAddressInfoModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/27.
//  Copyright © 2019 pan. All rights reserved.
//

#import "EOSAddressInfoModel.h"
#import "EOSSymbolModel.h"

@implementation EOSAddressInfoModel

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"symbol_list" : @"EOSSymbolModel"};
}

@end
