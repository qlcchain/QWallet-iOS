//
//  VersionManager.m
//  Qlink
//
//  Created by Jelly Foo on 2018/6/14.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VersionManager.h"

@implementation VersionManager

- (void)requestGetUpdateInfo {
    //    @weakify_self
//    NSDictionary *params = @{@"os":@"ios"};
//    [AppD.window makeToastActivity];
//    [RequestService requestgetForceUpdateInfoWithParams:params successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        [AppD.window hideToastActivity];
//        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
//            VersionInfoModel *model = [VersionInfoModel getObjectWithKeyValues:responseObject[@"versioninfo"]];
//            //获取本地的build号
//            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//            NSString *localBuild = [infoDic valueForKey:@"CFBundleVersion"];
//            if (model.currentversionname > [localBuild integerValue]) { // 显示更新
//                if (model.isforceupdate == 1) { // 强制更新
//                    [self showForceUpdateAlert:model.downloadlink];
//                } else { // 非强制更新
//                    [self showNormalUpdateAlert:model.downloadlink];
//                }
//            } else {
//                [AppD jumpRoot];
//            }
//        } else {
//            [AppD jumpRoot];
//        }
//    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        [AppD.window hideToastActivity];
//        [AppD jumpRoot];
//    }];
}

- (void)showForceUpdateAlert:(NSString *)url {
//    @weakify_self
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:kLang(@"update_app") message:kLang(@"update_new_version_force") preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *alertA = [UIAlertAction actionWithTitle:kLang(@"update") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf jumpToAppStoreDetail:url];
//        [weakSelf showForceUpdateAlert:url];
//    }];
//    [alertC addAction:alertA];
//
//    [AppD.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}

- (void)showNormalUpdateAlert:(NSString *)url {
//    @weakify_self
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:kLang(@"update_app") message:kLang(@"update_new_version_need") preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *alertB = [UIAlertAction actionWithTitle:kLang(@"later") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [AppD jumpRoot];
//    }];
//    [alertC addAction:alertB];
//    UIAlertAction *alertA = [UIAlertAction actionWithTitle:kLang(@"update") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf jumpToAppStoreDetail:url];
//    }];
//    [alertC addAction:alertA];
//
//    [AppD.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}

- (void)jumpToAppStoreDetail:(NSString *)url {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}

- (NSInteger)compareVersion1:(NSString *)version1 WithVersion2:(NSString *)version2 { // 1:version1>version2  0:verison1=version2  -1:version1<version2 版本格式：1.0.0
    NSMutableArray *version1Arr = [NSMutableArray arrayWithArray:[version1 componentsSeparatedByString:@"."]];
    NSMutableArray *version2Arr = [NSMutableArray arrayWithArray:[version2 componentsSeparatedByString:@"."]];
    if (version1Arr.count < 3) { // 不够3个，加至3个  补0
        for (int i = 0; i < 3-version1Arr.count; i++) {
            [version1Arr addObject:@"0"];
        }
    }
    if (version2Arr.count < 3) { // 不够3个，加至3个  补0
        for (int i = 0; i < 3-version2Arr.count; i++) {
            [version2Arr addObject:@"0"];
        }
    }
    
    __block NSInteger result = 0;
    [version1Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] > [version2Arr[idx] integerValue]) {
            result = 1;
            *stop = YES;
        } else if ([obj integerValue] == [version2Arr[idx] integerValue]) {
        } else if ([obj integerValue] < [version2Arr[idx] integerValue]) {
            result = -1;
            *stop = YES;
        }
    }];
    
    return result;
}

@end
