//
//  VPNDataUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/5/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNOperationUtil.h"
#import "WalletUtil.h"


@implementation VPNOperationUtil


+ (instancetype) shareInstance  {
    static VPNOperationUtil *vpnUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (vpnUtil == nil) {
            vpnUtil = [[self alloc] init];
        }
    });
    return vpnUtil;
}
// 将vpn资产表存入keychain
+ (void) saveArrayToKeyChain
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray* finfAlls = [VPNInfo bg_findAll:VPNREGISTER_TABNAME];
        NSMutableArray *dataArray = [VPNInfo mj_keyValuesArrayWithObjectArray:finfAlls];
        NSData *data = [dataArray mj_JSONData];
        [WalletUtil setDataKey:VPN_ASSETS_KEY Datavalue:data];
    });
   
}
// 将keychain中的资产导入资产表中
+ (void) keyChainDataToDB
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [WalletUtil getKeyDataValue:VPN_ASSETS_KEY];
        if (data) {
            NSArray *array =  [data mj_JSONObject];
            NSMutableArray *modeArr = [VPNInfo mj_objectArrayWithKeyValuesArray:array];
            [modeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                VPNInfo *vpnInfo = (VPNInfo *)obj;
                vpnInfo.bg_tableName = VPNREGISTER_TABNAME;
                [vpnInfo bg_saveOrUpdate];
            }];
        }
    });
}

@end
