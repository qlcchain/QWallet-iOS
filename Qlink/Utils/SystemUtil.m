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
    [RequestService requestWithUrl:sys_version_info_Url params:@{} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
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

@end
