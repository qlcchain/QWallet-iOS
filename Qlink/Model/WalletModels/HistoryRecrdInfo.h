//
//  HistoryRecrdInfo.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/10.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"
#import <BGFMDB/BGFMDB.h>

@interface HistoryRecrdInfo : BBaseModel

@property (nonatomic ,strong) NSString *recordId;

//0 wifi连接，1.兑换， 2 转账, 3vpn连接， 4 wifi注册扣费 、 5 vpn注册扣费
@property (nonatomic ,assign) int recordType;
/**
 * 记录是否上报给wifi或者vpn资产的提供端
 * 现在只有两种记录需要上报，wifi使用和vpn使用,并且是在connectType == 0的时候才要上报
 */
@property (nonatomic ,assign) BOOL isReported;
/**
 * 记录连接类型，0代表是使用端的连接记录，1代表是提供端的记录
 */
@property (nonatomic ,assign) int connectType;
/**
 *交易的流水号
 */
@property (nonatomic ,strong) NSString *txid;
/**
 *在交易类型为1的时候，表示兑换的neo的数量
 */
@property (nonatomic ,assign) double neoCount;
/**
 *   交易的qlcCount
 */
@property (nonatomic ,assign) double qlcCount;
/**
 *交易生成的时间戳
 */
@property (nonatomic ,strong) NSString *timestamp;
/**
 *同txid
 */
@property (nonatomic ,strong) NSString *exChangeId;
/**
 *对方的好友编号
 */
@property (nonatomic ,assign) int friendNum;
/**
 *资产名字
 * 当交易类型为0 或者3的时候
 */
@property (nonatomic ,strong) NSString *assetName;
/**
 * 需要接收人的p2pid.
 * 因为加入了每次启动app的删除好友的逻辑，所以记录friendNum是不行的了，必须用p2pId来进行识别
 */
@property (nonatomic ,strong) NSString *toP2pId;

@property (nonatomic ,assign) BOOL isMainNet;

@end
