//
//  VPNTranferMode.h
//  Qlink
//
//  Created by 旷自辉 on 2018/7/13.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface VPNTranferMode : BBaseModel

@property (nonatomic ,strong) NSString *vpnName;
@property (nonatomic , strong) NSString *vpnConnectTime;
@property (nonatomic , strong) NSString *p2pId;
@property (nonatomic , strong) NSString *transferSuccessTime;
@property (nonatomic , strong) NSString *tranferAddress;
@property (nonatomic , strong) NSString *tranferCost;
@property (nonatomic ,strong) NSString *recordId;
@property (nonatomic , assign) BOOL isTranferSuccess;
@property (nonatomic , assign) BOOL isBecomeTranfer;
@property (nonatomic , assign) BOOL isCurrentConnect;

@end
