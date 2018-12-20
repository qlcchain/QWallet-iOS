//
//  BlockChainInfo.h
//  啊啊啊啊啊啊
//
//  Created by oraclechain on 2018/1/23.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOS_BlockChainInfo : NSObject

@property(nonatomic, strong) NSNumber *block_cpu_limit;
@property(nonatomic, strong) NSNumber *block_net_limit;
@property(nonatomic, strong) NSString *last_irreversible_block_id;
@property(nonatomic, strong) NSNumber *virtual_block_cpu_limit;
@property(nonatomic, strong) NSNumber *virtual_block_net_limit;
@property(nonatomic, strong) NSString *server_version;
@property(nonatomic, strong) NSString *server_version_string;
@property(nonatomic, strong) NSNumber *head_block_num;
@property(nonatomic, strong) NSString *last_irreversible_block_num;
@property(nonatomic, strong) NSString *chain_id;
@property(nonatomic, strong) NSString *head_block_id;
@property(nonatomic, strong) NSString *head_block_time;
@property(nonatomic, strong) NSString *head_block_producer;
@property(nonatomic, strong) NSString *recent_slots;
@property(nonatomic, strong) NSString *participation_rate;
@end
