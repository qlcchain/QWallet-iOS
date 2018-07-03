//
//  WalletUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "WalletUtil.h"
#import "Qlink-Swift.h"
#import "NewWalletViewController.h"
#import "CreateNewWalletViewController.h"
#import "UnlockWalletViewController.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
#import "SystemUtil.h"
#import "TransferUtil.h"
#import "AppDelegate.h"
#import "QlinkTabbarViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface WalletUtil ()

@property (nonatomic) BOOL needUnlock;
@property (nonatomic) CheckProcessFrom checkFrom;

@end

@implementation WalletUtil

+ (instancetype)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static WalletUtil *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc]init];
        sharedObj.isLock = YES;
    });
    return sharedObj;
}


+ (void) setUnlock:(BOOL) lock
{
    [WalletUtil shareInstance].isLock = lock;
}
+ (BOOL)isExistPass
{
    NSString *value = [KeychainUtil getKeyValueWithKeyName:WALLET_PASS_KEY];
    if (value == nil || [value isEmptyString]) {
        return NO;
    }
    return YES;
}
+ (BOOL) removeChainKey:(NSString *) key
{
    return [KeychainUtil removeKeyWithKeyName:key];
}
+ (BOOL) removeAllKey
{
    return [KeychainUtil removeAllKey];
}

+ (BOOL) setWalletkeyWithKey:(NSString *) walletkey withWalletValue:(NSString *) walletValue
{
    NSString *walletKeyValues = [NSString stringWithFormat:@"%@",walletValue];
    NSString *value = [KeychainUtil getKeyValueWithKeyName:walletkey];
    if (value && ![value isEmptyString]) {
        NSArray *valueArr = [value componentsSeparatedByString:@","];
        
        NSMutableArray *values = [NSMutableArray arrayWithArray:valueArr];
        if ([values containsObject:walletValue]) {
            return NO;
        }
        walletKeyValues = [NSString stringWithFormat:@"%@,%@",value,walletKeyValues];
    }
    return [KeychainUtil saveValueToKeyWithKeyName:walletkey keyValue:walletKeyValues];
}



+ (BOOL) setKeyValue:(NSString *) key value:(NSString *) value
{

   return [KeychainUtil saveValueToKeyWithKeyName:key keyValue:value];
}

+ (BOOL) setDataKey:(NSString *) key Datavalue:(NSData *) data
{
    if ([WalletUtil getKeyDataValue:key]) {
        [WalletUtil removeChainKey:key];
    }
    return [KeychainUtil saveDataKeyAndDataWithKeyName:key keyValue:data];
}
+ (NSData *) getKeyDataValue:(NSString *) key
{
    return [KeychainUtil getKeyDataValueWithKeyName:key];
}

+ (NSString *) getKeyValue:(NSString *) key
{
    return [KeychainUtil getKeyValueWithKeyName:key];
}

+ (BOOL) isExistWalletPrivateKey
{
    NSString *value = [KeychainUtil getKeyValueWithKeyName:WALLET_PRIVATE_KEY];
    if (value == nil || [value isEmptyString]) {
        return NO;
    }
    return YES;
}

+ (void) checkTouchWithSuccessBlock:(void (^)(void)) successBlock failure:(void (^)(void)) failureBlock
{
    // 检查设备是否支持
    LAContext *context = [LAContext new];
    // 用于设置提示语，表示为什么要使用Touch ID
    if (@available(iOS 11.0, *)) {
        //context.localizedReason = @"";
    } else {
        // Fallback on earlier versions
    }
    //用于设置左边的按钮的名称，默认是Enter Password.
    //context.localizedFallbackTitle = @"";
    //这个属性是设置指纹输入失败之后的弹出框的选项
    //context.localizedFallbackTitle = @"再试一次";
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //NSLog(@"支持指纹识别");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Fingerprint verification" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    successBlock();
                }];
            }else{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    failureBlock();
                }];
            }
        }];
    } else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            failureBlock();
        }];
    }
}
// 是否开启指纹
+ (BOOL) isOpenTouch
{
    NSString *touchStatu = [HWUserdefault getStringWithKey:TOUCH_SWITCH_KEY];
    if ([[NSStringUtil getNotNullValue:touchStatu] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void) checkWalletPassAndPrivateKey:(QBaseViewController *) vs TransitionFrom:(CheckProcessFrom)checkFrom
{
    AppD.checkPassLock = NO;
    [WalletUtil shareInstance].checkFrom = checkFrom;
    [WalletUtil shareInstance].isDelay = YES;
    if ([WalletUtil isExistPass]) {
        // 判断上次输入密码时间
        NSString *backTime = [HWUserdefault getObjectWithKey:INPUNT_PASS_TIME_KEY];
        NSDateFormatter *dateFormatrer = [NSDateFormatter defaultDateFormatter];
        NSDate *backDate = [dateFormatrer dateFromString:backTime];
        // 判断日期相隔时间
        NSInteger minutes = [[NSDate date] minutesAfterDate:backDate];
        
        if ([WalletUtil shareInstance].isLock || minutes >  30) {
            if ([WalletUtil isOpenTouch]) { // 是否开启指纹
                [WalletUtil checkTouchWithSuccessBlock:^{
                    [WalletUtil setUnlock:NO];
                    NSString *enterBackTime = [[NSDate date] formattedDateYearYueRi:@"yyyy-MM-dd HH:mm:ss"];
                    [HWUserdefault insertString:enterBackTime withkey:INPUNT_PASS_TIME_KEY];
                    
                    if ([WalletUtil isExistWalletPrivateKey]) { // 钱包私钥是否存在
                        [WalletUtil manageContiueWork];
                    } else {
                        [WalletUtil presentNewWallet:vs]; // 创建钱包
                    }
                    
                } failure:^{
                    
                    if ([WalletUtil shareInstance].isLock) { // 是否是第一次启动
                        [WalletUtil presentUnlockWallet:vs];
                    } else {
                        // 判断上次输入密码时间
                        NSString *backTime = [HWUserdefault getObjectWithKey:INPUNT_PASS_TIME_KEY];
                        NSDateFormatter *dateFormatrer = [NSDateFormatter defaultDateFormatter];
                        NSDate *backDate = [dateFormatrer dateFromString:backTime];
                        // 判断日期相隔时间
                        NSInteger minutes = [[NSDate date] minutesAfterDate:backDate];
                        if (minutes >  30) {
                            [WalletUtil presentUnlockWallet:vs];
                        } else {
                            if ([WalletUtil isExistWalletPrivateKey]) { // 钱包私钥是否存在
                                [WalletUtil manageContiueWork];
                            } else {
                                [WalletUtil presentNewWallet:vs]; // 创建钱包
                            }
                        }
                    }
                }];
            } else { // 没有开启指纹
                if ([WalletUtil shareInstance].isLock) { // 是否是第一次启动
                    [WalletUtil presentUnlockWallet:vs];
                } else {
                    // 判断上次输入密码时间
                    NSString *backTime = [HWUserdefault getObjectWithKey:INPUNT_PASS_TIME_KEY];
                    NSDateFormatter *dateFormatrer = [NSDateFormatter defaultDateFormatter];
                    NSDate *backDate = [dateFormatrer dateFromString:backTime];
                    // 判断日期相隔时间
                    NSInteger minutes = [[NSDate date] minutesAfterDate:backDate];
                    if (minutes >  30) {
                        [WalletUtil presentUnlockWallet:vs];
                    } else {
                        if ([WalletUtil isExistWalletPrivateKey]) { // 钱包私钥是否存在
                            [WalletUtil manageContiueWork];
                        } else {
                            [WalletUtil presentNewWallet:vs]; // 创建钱包
                        }
                    }
                }
            }
            
        } else {
           
            if ([WalletUtil isExistWalletPrivateKey]) { // 钱包私钥是否存在
                [WalletUtil shareInstance].isDelay = NO;
                [WalletUtil manageContiueWork];
            } else {
                [WalletUtil presentNewWallet:vs]; // 创建钱包
            }
        }
    } else {
        [WalletUtil presentCreateWallet:vs]; // 创建密码
    }
    
    
   /* [WalletUtil shareInstance].checkFrom = checkFrom;
    if ([WalletUtil isExistPass]) { // 密码是否存在
        if ([WalletUtil shareInstance].isLock) { // 是否是第一次启动
            [WalletUtil presentUnlockWallet:vs];
        } else {
            // 判断上次输入密码时间
            NSString *backTime = [HWUserdefault getObjectWithKey:INPUNT_PASS_TIME_KEY];
            NSDateFormatter *dateFormatrer = [NSDateFormatter defaultDateFormatter];
            NSDate *backDate = [dateFormatrer dateFromString:backTime];
            // 判断日期相隔时间
            NSInteger minutes = [[NSDate date] minutesAfterDate:backDate];
            if (minutes >  30) {
                 [WalletUtil presentUnlockWallet:vs];
            } else {
                if ([WalletUtil isExistWalletPrivateKey]) { // 钱包私钥是否存在
                    [WalletUtil manageContiueWork];
                } else {
                    [WalletUtil presentNewWallet:vs]; // 创建钱包
                }
            }
            
        }
        
    } else {
        [WalletUtil presentCreateWallet:vs]; // 创建密码
    }*/
}

+ (void)presentUnlockWallet:(QBaseViewController *) vs {
    UnlockWalletViewController *vc = [[UnlockWalletViewController alloc] init];
    // [vs presentModalVC:vc animated:YES];
     [vs.navigationController pushViewController:vc animated:YES];
}

+ (void)presentCreateWallet:(QBaseViewController *) vs {
    CreateNewWalletViewController *vc = [[CreateNewWalletViewController alloc] init];
   [vs.navigationController pushViewController:vc animated:YES];
}

+ (void)presentNewWallet:(QBaseViewController *) vs {
    NewWalletViewController *vc = [[NewWalletViewController alloc] initWithJump:PassJump];
    [vs.navigationController pushViewController:vc animated:YES];
}

// 获取当前钱包的信息
+ (void) getCurrentWalletInfo
{
    // 得到所有钱包
    if (![WalletUtil isExistWalletPrivateKey]) {
        return;
    }
    
    NSString *privateValues = [KeychainUtil getKeyValueWithKeyName:WALLET_PRIVATE_KEY];
    
    NSString *publicValues = [KeychainUtil getKeyValueWithKeyName:WALLET_PUBLIC_KEY];
   
    NSString *adderssValues = [KeychainUtil getKeyValueWithKeyName:WALLET_ADDRESS_KEY];
    
    NSString *wifValues = [KeychainUtil getKeyValueWithKeyName:WALLET_WIF_KEY];
    
    NSInteger walletIndex = [[KeychainUtil getKeyValueWithKeyName:CURRENT_WALLET_KEY] integerValue];
    
    if (publicValues && ![publicValues isEmptyString]) {
        NSMutableArray *values = [NSMutableArray arrayWithArray:[publicValues componentsSeparatedByString:@","]];
        [CurrentWalletInfo getShareInstance].publicKey = values[walletIndex];
    }
    
    if (privateValues && ![privateValues isEmptyString]) {
        NSMutableArray *values = [NSMutableArray arrayWithArray:[privateValues componentsSeparatedByString:@","]];
        [CurrentWalletInfo getShareInstance].privateKey = values[walletIndex];
    }
    
    if (adderssValues && ![adderssValues isEmptyString]) {
        NSMutableArray *values = [NSMutableArray arrayWithArray:[adderssValues componentsSeparatedByString:@","]];
        [CurrentWalletInfo getShareInstance].address = values[walletIndex];
    }
    
    if (wifValues && ![wifValues isEmptyString]) {
        NSMutableArray *values = [NSMutableArray arrayWithArray:[wifValues componentsSeparatedByString:@","]];
        [CurrentWalletInfo getShareInstance].wif = values[walletIndex];
    }
    
    // app第一次启动
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 得到当前钱包对象
        [WalletManage.shareInstance3 getWalletWithPrivatekeyWithPrivatekey:[CurrentWalletInfo getShareInstance].privateKey];
        // 选取交易网络
        [WalletManage configO3NetworkWithIsMain:[WalletUtil checkServerIsMian]];
        // 重新初始化 Account->将Account设为当前钱包
        [WalletManage.shareInstance3 configureAccountWithMainNet:[WalletUtil checkServerIsMian]];
        // 查询当前钱包资产
        [TransferUtil sendGetBalanceRequest];
    });
    
}

// 获取所有钱包
+ (NSArray *) getAllWalletList
{
    NSString *privateValues = [KeychainUtil getKeyValueWithKeyName:WALLET_PRIVATE_KEY];
    
   // NSString *publicValues = [KeychainUtil getKeyValueWithKeyName:WALLET_PUBLIC_KEY];
    
    NSString *adderssValues = [KeychainUtil getKeyValueWithKeyName:WALLET_ADDRESS_KEY];
    
  //  NSInteger walletIndex = [[KeychainUtil getKeyValueWithKeyName:CURRENT_WALLET_KEY] integerValue];
    
    
    
    if (privateValues && ![privateValues isEmptyString]) {
        NSArray *privateArr =  [privateValues componentsSeparatedByString:@","];
        NSArray *addressArr =  [adderssValues componentsSeparatedByString:@","];
        return [NSArray arrayWithObjects:privateArr,addressArr, nil];
    } else {
        return nil;
    }
    
}


/**
 /**
 *生成32为无序标示  转帐id
 *
 @return changeid
 */
+(NSString *) getExChangeId
{
//    NSString *value = [KeychainUtil getKeyValueWithKeyName:[CurrentWalletInfo getShareInstance].address];
//    if (value == nil || [value isEmptyString]) {
//        NSString *changeId = [SystemUtil uuidString];
//        [WalletUtil setKeyValue:[CurrentWalletInfo getShareInstance].address value:changeId];
//        return changeId;
//    }
//    return value;
   

     char data[32];
     for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
     return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    

}

/**
获取当前选择钱包的索引
 @return 索引
 */
+(NSInteger) getCurrentWalletIndex
{
    NSString *indexstr = [KeychainUtil getKeyValueWithKeyName:CURRENT_WALLET_KEY];
    return [indexstr integerValue];
}

+ (CheckProcessFrom)getCheckFrom {
    return [WalletUtil shareInstance].checkFrom;
}

+ (void)manageCancelWork {
    
    AppD.checkPassLock = YES;
    CheckProcessFrom checkFrom = [WalletUtil getCheckFrom];
    switch (checkFrom) {
        case CheckProcess_WALLET_TABBAR:
        {
            AppD.tabbarC.selectedIndex = 1;
        }
            break;
        case CheckProcess_VPN_ADD:
        {
        }
            break;
        case CheckProcess_VPN_LIST:
        {
        }
            break;
            
        default:
            break;
    }
}

+ (void) manageContiueWork
{
     AppD.checkPassLock = YES;
    CheckProcessFrom fromeType = [WalletUtil getCheckFrom];
    switch (fromeType) {
        case CheckProcess_VPN_ADD:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_PROCESS_SUCCESS_VPN_ADD object:nil];
        }
            break;
        case CheckProcess_VPN_LIST:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_PROCESS_SUCCESS_VPN_LIST object:nil];
        }
            break;
        case CheckProcess_WALLET_TABBAR:
            
            if ([WalletUtil shareInstance].isDelay) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:WALLET_RELOAD object:nil];
            }
            break;
        case CheckProcess_VPN_SEIZE:
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_PROCESS_SUCCESS_VPN_SEIZE object:nil];
            
        break;
            
        default:
            break;
    }
}


#pragma mark - 得到vpn所有名字
+ (NSArray *) getVPNAllName
{
    NSString *vpnValues = [KeychainUtil getKeyValueWithKeyName:VPN_FILE_KEY];
    
    if (vpnValues && ![vpnValues isEmptyString]) {
        return [vpnValues componentsSeparatedByString:@","];
    } else {
        return nil;
    }
}


#pragma mark - 保存交易记录

/**
 保存注册记录

 @param qlc 交易的qlcCount
 @param txtid 交易的流水号
 @param neo 在交易类型为1的时候，表示兑换的neo的数量
 @param type 0 wifi连接，1.兑换， 2 转账, 3vpn连接， 4 wifi注册扣费 、 5 vpn注册扣费
 @param assetName 资产名字 当交易类型为0 或者3的时候
 @param friendNum 对方的好友编号
 @param p2pID 需要接收人的p2pid.
 @param connectType 记录连接类型，0代表是使用端的连接记录，1代表是提供端的记录
 @param isReported 记录是否上报给wifi或者vpn资产的提供端 现在只有两种记录需要上报，wifi使用和vpn使用,并且是在connectType == 0的时候才要上报
 */
+ (void) saveTranQLCRecordWithQlc:(NSString *) qlc txtid:(NSString *) txtid  neo:(NSString *) neo recordType:(int) type assetName:(NSString *) assetName friendNum:(int) friendNum p2pID:(NSString *) p2pID connectType:(int) connectType isReported:(BOOL) isReported
{
    HistoryRecrdInfo *recrdInfo = [[HistoryRecrdInfo alloc] init];
    recrdInfo.bg_tableName = HISTORYRECRD_TABNAME;
    recrdInfo.recordType = type;
    recrdInfo.isReported = isReported;
    recrdInfo.connectType = connectType;
    recrdInfo.txid = txtid;
    recrdInfo.qlcCount = [qlc doubleValue];
    recrdInfo.neoCount = [neo doubleValue];
    recrdInfo.assetName = assetName;
    recrdInfo.friendNum = friendNum;
    recrdInfo.toP2pId = p2pID;
    recrdInfo.isMainNet = [WalletUtil checkServerIsMian];
    recrdInfo.timestamp = [NSString stringWithFormat:@"%ld",[NSDate getTimestampFromDate:[NSDate date]]];
    [recrdInfo bg_saveOrUpdateAsync:nil];
}

/**
 发送获取qlc 和 gas 请求
 @param address 钱包地址
 */
+ (void)sendWalletDefaultReqeustWithAddress:(NSString *)address
{
    NSDictionary *parames = @{@"address":[NSStringUtil getNotNullValue:address]};
    [RequestService requestWithUrl:createWalletV2_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        DDLogDebug(@"createWalletV2_Url 发送失败");
    }];
}

// 获取当前网络
+ (BOOL) checkServerIsMian
{
    NSString *serverNetwork = [HWUserdefault getStringWithKey:SERVER_NETWORK];
    if ([serverNetwork isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end
