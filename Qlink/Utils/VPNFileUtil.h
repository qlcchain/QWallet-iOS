//
//  VPNUtil.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/20.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPNFileUtil : NSObject

+ (void) saveVPNDataToLibrayPath:(NSData *) data withFileName:(NSString *) fileName;
// 得到所有vpn名字
+ (NSArray *) getAllVPNName;
// vpnname是否存在
+ (BOOL) vpnNameIsExitWithName:(NSString *) fileName;
// 根据文件名得到路径
+ (NSString *) getVPNPathWithFileName:(NSString *) fileName;
 //将keychain vpn文件 导入沙盒
+ (void) keychainVPNFileToLibray;

+ (void) removeVPNFile;
+ (NSString *)getTempPath;


@end
