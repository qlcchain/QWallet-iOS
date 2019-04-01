//
//  VPNMode.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNMode.h"


@implementation VPNMode

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"vpnList" : @"VPNInfo"};
}

@end

@implementation VPNInfo

//+ (NSDictionary *) mj_replacedKeyFromPropertyName
//{
//    return @{@"vpnName" : @"ssId"};
//}

@end
