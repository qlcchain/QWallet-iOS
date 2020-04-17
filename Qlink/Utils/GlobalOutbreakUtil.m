//
//  GlobalOutbreakUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2020/4/15.
//  Copyright © 2020 pan. All rights reserved.
//

#import "GlobalOutbreakUtil.h"
#import "GlobalConstants.h"
#import "GlobalOutbreakWebViewController.h"
#import "QNavigationController.h"
#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "UserModel.h"
#import "RSAUtil.h"
#import <OutbreakRed/OutbreakRed.h>

@implementation GlobalOutbreakUtil

+ (void)transitionToGlobalOutbreak {
    [GlobalOutbreakUtil requestSys_location];
}


+ (void)requestSys_location {
//    kWeakSelf(self);
    NSDictionary *params = @{};
    [kAppD.window makeToastInView:kAppD.window];
    [RequestService requestWithUrl10:sys_location_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeNormal successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        [kAppD.window hideToast];
        if ([responseObject[Server_Code] integerValue] == 0) {
            NSString *location = responseObject[@"location"];
            [GlobalOutbreakUtil jumpToGlobalOutbreak:location];
        } else {
            [kAppD.window makeToastDisappearWithText:responseObject[Server_Msg]];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [kAppD.window hideToast];
    }];
}

+ (void)requestGzbd_focus:(void(^)(NSString *subsidised,NSString *isolationDays,NSString *claimedQgas))completeBlock {
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
    OR_RequestModel *requestM = [OR_RequestModel new];
    requestM.p2pId = [UserModel getTopupP2PId];
    requestM.appBuild = APP_Build;
    requestM.appVersion = APP_Version;
    [OutbreakRedSDK requestGzbd_focusWithAccount:account token:token timestamp:timestamp requestM:requestM completeBlock:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nonnull responseObject, NSError * _Nonnull error) {
        if (!error) {
            if ([responseObject[Server_Code] integerValue] == 0) {
                if (completeBlock) {
                    NSString *subsidised = responseObject[@"subsidised"];
                    NSString *isolationDays = responseObject[@"isolationDays"];
                    NSString *claimedQgas = responseObject[@"claimedQgas"];
                    completeBlock(subsidised,isolationDays,claimedQgas);
                }
            }
        } else {
            
        }
    }];
}


+ (void)jumpToGlobalOutbreak:(NSString *)location {
    NSString *inputUrl = GlobalOutbreak_domestic;
    if ([location isEqualToString:@"domestic"]) {
    } else if ([location isEqualToString:@"overseas"]) {
        inputUrl = GlobalOutbreak_overseas;
    }
    GlobalOutbreakWebViewController *vc = [[GlobalOutbreakWebViewController alloc] init];
    vc.inputUrl = inputUrl;
    vc.inputTitle = GlobalOutbreak_title;
    [((QNavigationController *)kAppD.mtabbarC.selectedViewController) pushViewController:vc animated:YES];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
