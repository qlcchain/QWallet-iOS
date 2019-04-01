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
// sendVpnFileListRsp
@property (nonatomic, strong) NSString *sendVpnFileListRspMsgid;
@property (nonatomic, strong) NSMutableArray *sendVpnFileListRspArr;
@property (nonatomic, strong) NSString *sendVpnFileListRspMsg;
// sendVpnFileNewRsq
@property (nonatomic, strong) NSString *sendVpnFileNewRspMsgid;
@property (nonatomic, strong) NSMutableArray *sendVpnFileNewRspArr;
@property (nonatomic, strong) NSString *sendVpnFileNewRspMsg;

+ (instancetype)shareInstance;
- (BOOL)handleVpnFileListRsp:(NSDictionary *)inputDic;
- (BOOL)handleVpnFileNewRsp:(NSDictionary *)inputDic;

@end
