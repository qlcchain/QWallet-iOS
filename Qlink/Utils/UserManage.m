//
//  UserModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/18.
//  Copyright © 2018年 pan. All rights reserved.
//


#import "RequestService.h"

@interface UserManage ()

@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic) NSInteger randomNameIndex;

@end

@implementation UserManage

+ (instancetype)shareInstance {
    static id shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
        [shareObject registerNoti];
        [shareObject dataInit];
    });
    return shareObject;
}

- (void)dataInit {
    _randomNameIndex = arc4random() % [UserManage senderNameArr].count;
}

- (void)registerNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p2pOnline:) name:P2P_ONLINE_NOTI object:nil];
}

+ (BOOL)isExistHeadUrl {
    BOOL exist = NO;
    NSString *url = [UserManage shareInstance].headUrl;
    if (url != nil && url.length > 0) {
        exist = YES;
    }
    return exist;
}

+ (NSString *)getHeadUrl {
    return [UserManage shareInstance].headUrl?:@"";
}

+ (NSString *)getWholeHeadUrl {
    NSString *head = [NSString stringWithFormat:@"%@%@",[RequestService getPrefixUrl],[UserManage getHeadUrl]];
    return head;
}

+ (void)setHeadUrl:(NSString *)url {
    [UserManage shareInstance].headUrl = url;
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_HEAD_CHANGE_NOTI object:nil];
}

- (void)p2pOnline:(NSNotification *)noti {
    if (![UserManage isExistHeadUrl]) { // 不存在头像路径
        [UserManage requestGetHeadView]; // 请求头像
    }
}

+ (void)fetchUserInfo {
    [UserManage requestGetHeadView]; // 请求用户头像
}

+ (void)requestGetHeadView {
    NSString *p2pId = [ToxManage getOwnP2PId]?:@"";
    if (p2pId.length <= 0) {
        return;
    }
    NSDictionary *params = @{@"p2pId":p2pId};
    [RequestService requestWithUrl:getHeadView_Url params:params httpMethod:HttpMethodGet isSign:NO successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
//            NSString *head = [NSString stringWithFormat:@"%@%@",[RequestService getPrefixUrl],responseObject[@"head"]];
            NSString *head = responseObject[@"head"];
            [UserManage setHeadUrl:head];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        DDLogDebug(@"%@",error.description);
//        [AppD.window showHint:error.description];
    }];
}

- (NSString *)getRandomName {
    return [UserManage senderNameArr][_randomNameIndex];
}

+ (NSArray *)senderNameArr {
    return @[@"Jess" ,@"Jesse" ,@"Jessie" ,@"Jo" ,@"Joey" ,@"Jordan" ,@"Joslyn" ,@"Joyce" ,@"Jule" ,@"Jules" ,@"Justice" ,@"Kelly" ,@"Kelsey" ,@"Kendall" ,@"Kerry" ,@"Garfield" ,@"Garland" ,@"Gene" ,@"Gill" ,@"Hadley" ,@"Hailey" ,@"Harley" ,@"Hayden" ,@"Hilary" ,@"Hope" ,@"Jackie" ,@"Jamie" ,@"Jan" ,@"Jean" ,@"Jerry" ,@"Drew" ,@"Easter" ,@"Eddie" ,@"Eden" ,@"Edie" ,@"Elisha" ,@"Ellison" ,@"Ennis" ,@"Evan" ,@"Evelyn" ,@"Fay" ,@"Frances" ,@"Fred" ,@"Gabriel" ,@"Gale" ,@"Cody" ,@"Corey" ,@"Cortney" ,@"Cory" ,@"Courtney" ,@"Dallas" ,@"Daly" ,@"Dana" ,@"Dane" ,@"Darcy" ,@"Day" ,@"Dee" ,@"Devin" ,@"Devon" ,@"Dominique" ,@"Brennan" ,@"Brett" ,@"Britton" ,@"Burnett" ,@"Cameron" ,@"Carmel" ,@"Carol" ,@"Cecile" ,@"Celestine" ,@"Charlene" ,@"Cherry" ,@"Christian" ,@"Christy" ,@"Claire" ,@"Claude" ,@"Avery" ,@"Avril" ,@"Bailey" ,@"Barrie" ,@"Bell" ,@"Benny" ,@"Berry" ,@"Bert" ,@"Bertie" ,@"Beverly" ,@"Billie" ,@"Blake" ,@"Bobbie" ,@"Bobby" ,@"Brady" ,@"Alex" ,@"Alexis" ,@"Alfven" ,@"Alison" ,@"Alva" ,@"Andie" ,@"Andrea" ,@"Anstice" ,@"Arrow" ,@"Asa" ,@"Ash" ,@"Ashby" ,@"Augustine" ,@"Ava" ,@"Averil"];
}

@end
