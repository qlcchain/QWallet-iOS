//
//  UserModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/18.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManage : NSObject

@property (nonatomic , strong) NSString *myQLC;
@property (nonatomic , strong) NSString *myGAS;


+ (instancetype)shareInstance;

//+ (BOOL)isExistHeadUrl;
//- (void)registerNoti;
+ (NSString *)getHeadUrl;
+ (NSString *)getWholeHeadUrl;
+ (void)setHeadUrl:(NSString *)url;
+ (void)requestGetHeadView;
- (NSString *)getRandomName;
+ (void)fetchUserInfo;

@end
