//
//  VPNMode.h
//  Qlink
//
//  Created by 旷自辉 on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"
#import <BGFMDB/BGFMDB.h>

@interface VPNMode : BBaseModel

@property (nonatomic , copy) NSString *country;
@property (nonatomic , strong) NSArray *vpnList;


@end

@interface VPNInfo : BBaseModel

@property (nonatomic , copy) NSString *address;
@property (nonatomic , copy) NSString *country;
@property (nonatomic , copy) NSString *p2pId;
@property (nonatomic , copy) NSString *type;
@property (nonatomic , copy) NSString *vpnName;
@property (nonatomic , copy) NSString *qlc;
@property (nonatomic , copy) NSString *registerQlc;//": 0.00,
@property (nonatomic , copy) NSString *cost;//": 0.0,
@property (nonatomic , copy) NSString *connectNum;//": 0,
@property (nonatomic , copy) NSString *imgUrl;//": "",
@property (nonatomic , copy) NSString *heartTime;//": "2018-04-18 10:36:14"
@property (nonatomic, copy) NSString *bandwidth;
@property (nonatomic, copy) NSString *ipV4Address;
@property (nonatomic, copy) NSString *profileLocalPath;
@property (nonatomic) BOOL isMainNet;

// 新增字段
//userId
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *privateKeyPassword;
//profileUUid
@property (nonatomic, copy) NSString *continent;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *groupNum;
@property (nonatomic, copy) NSString *connectMaxnumber;
@property (nonatomic, copy) NSString *assetTranfer;
//@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *unReadMessageCount;
@property (nonatomic) NSInteger friendNum;
@property (nonatomic, copy) NSString *configuration;
@property (nonatomic, copy) NSString *currentConnect;
@property (nonatomic) BOOL isConnected;
@property (nonatomic) NSInteger online;
@property (nonatomic, copy) NSString *isLoadingAvater;
@property (nonatomic, copy) NSString *avaterUpdateTime;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *ssId;
@property (nonatomic, copy) NSString *connectCost;
@property (nonatomic , copy) NSString *recordId;
// vpn扣费时间
@property (nonatomic, copy) NSString *tranTime;

- (BOOL)isOwner;
- (BOOL)isFriend;

@end

