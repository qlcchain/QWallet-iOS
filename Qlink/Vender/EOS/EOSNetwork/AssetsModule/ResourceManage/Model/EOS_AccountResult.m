//
//  AccountResult.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/23.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "EOS_AccountResult.h"

@implementation EOS_AccountResult
- (EOS_Account *)data{
    if (!_data) {
        _data = [[EOS_Account alloc] init];
    }
    return _data;
}
@end
