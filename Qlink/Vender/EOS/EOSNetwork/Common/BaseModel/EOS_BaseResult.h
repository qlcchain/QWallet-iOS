//
//  BaseResult.h
//  pocketEOS
//
//  Created by oraclechain on 2018/7/4.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOS_BaseResult : NSObject
@property(nonatomic , strong) NSNumber *code;
@property(nonatomic , copy) NSString *message;
@property(nonatomic , copy) NSString *msg;

@end
