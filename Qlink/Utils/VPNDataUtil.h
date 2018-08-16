//
//  VPNDataUtil.h
//  Qlink
//
//  Created by 旷自辉 on 2018/8/16.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPNDataUtil : NSObject
@property (nonatomic , strong) NSMutableDictionary *vpnDataDic;
+ (instancetype)shareInstance;
@end
