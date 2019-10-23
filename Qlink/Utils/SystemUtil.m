//
//  SystemUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/11.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "SystemUtil.h"
#import "Qlink-Swift.h"
#import "NeoTransferUtil.h"
#import "GlobalConstants.h"
#import "NSDate+Category.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import "JPUSHService.h"

@implementation SystemUtil

+ (NSString *) uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    
    CFRelease(uuid_ref);
    
    CFRelease(uuid_string_ref);
    
    NSString *stringWithoutQuotation = [[uuid lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return stringWithoutQuotation;
    
}

/**
 获取时间戳

 @return 时间戳
 */
+ (NSString *) getTimeInterval
{
   NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f",timeInterval];
}

/**
 app退出时。配置
 */
+ (void) configureAPPTerminate {
//    NSLog(@"applicationState = %ld",(long)[UIApplication sharedApplication].applicationState);
//    [SystemUtil deleteVPNConfig];
//    [NeoTransferUtil updateUserDefaultVPNListCurrentVPNConnectStatus];
//    [ToxManage readDataToKeychain];
    // 结束p2p连接
   // if ([ToxManage getP2PConnectionStatus]) {
    //    [ToxManage endP2PConnection];
   // }
}

//+ (void)deleteVPNConfig {
//    // 断开vpn连接
////    [VPNUtil.shareInstance stopVPN];
//    // 删除vpn本地配置
////    [VPNUtil.shareInstance removeFromPreferences];
//    // 删除当前VPNInfo
//    [HWUserdefault deleteObjectWithKey:Current_Connenct_VPN];
//
//}

+ (void)checkAPPUpdate {
//    NSString * url = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=%@",AppStore_ID];
    [RequestService requestWithUrl5:sys_version_info_Url params:@{} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSDictionary *data = responseObject[Server_Data];
            // 线上
            NSString *versionNum = data[@"version_number"];
            if (versionNum && versionNum.length > 0 && [versionNum containsString:@"#"]) {
                NSString *versionLine = [[versionNum componentsSeparatedByString:@"#"] lastObject];
                NSArray * arrayLine = [versionLine componentsSeparatedByString:@"."];
                NSInteger lineVersionInt = 0;
                if (arrayLine.count == 3) {
                    lineVersionInt = [arrayLine[0] integerValue]*100 + [arrayLine[1] integerValue]*10 + [arrayLine[2] integerValue];
                }
                // 本地
                NSArray *arrayLocal = [APP_Version componentsSeparatedByString:@"."];
                NSInteger localVersionInt = 0;
                if (arrayLocal.count == 3) {
                    localVersionInt = [arrayLocal[0] integerValue]*100 + [arrayLocal[1] integerValue]*10 + [arrayLocal[2] integerValue];
                }
                if (lineVersionInt > localVersionInt) { // 线上版本大于本地版本
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:kLang(@"a_new_version_of_my_qwallet__") preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * ok = [UIAlertAction actionWithTitle:kLang(@"cancel") style:UIAlertActionStyleDefault handler:nil];
                    UIAlertAction * update = [UIAlertAction actionWithTitle:kLang(@"install_now") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //跳转到App Store
                        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?mt=8",AppStore_ID];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
                    }];
                    [alert addAction:ok];
                    [alert addAction:update];
                    [kAppD.window.rootViewController presentViewController:alert animated:YES completion:nil];
                }
            }
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSLog(@"版本更新出错，%@",error.description);
    }];
}

+ (void)requestLogout:(void (^)(void))completeBlock {
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
//    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token}];
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl5:user_logout_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            if (completeBlock) {
                completeBlock();
            }
            [kAppD logout];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

+ (void)requestBind_jpush {
    if (![UserModel haveLoginAccount]) {
        return;
    }
    UserModel *userM = [UserModel fetchUserOfLogin];
    if (!userM.md5PW || userM.md5PW.length <= 0) {
        return;
    }
    
    NSString *jpushId = [JPUSHService registrationID]?:@"";
    if ([jpushId isEmptyString]) {
        return;
    }
    
    //    kWeakSelf(self);
    NSString *account = userM.account?:@"";
    NSString *md5PW = userM.md5PW?:@"";
    NSString *timestamp = [RequestService getRequestTimestamp];
    NSString *encryptString = [NSString stringWithFormat:@"%@,%@",timestamp,md5PW];
    NSString *token = [RSAUtil encryptString:encryptString publicKey:userM.rsaPublicKey?:@""];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"account":account,@"token":token,@"appOs":@"IOS",@"pushPlatform":@"JIGUANG",@"pushId":jpushId}];
    [RequestService requestWithUrl5:user_bind_jpush_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
            
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
