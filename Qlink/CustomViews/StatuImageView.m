//
//  StatuImageView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/19.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "StatuImageView.h"


@implementation StatuImageView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        if ([ToxManage getP2PConnectionStatus]) {
            [self p2pOnlineStatus:nil];
        } else {
            [self p2pOfflineStatus:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p2pOfflineStatus:) name:P2P_OFFLINE_NOTI object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p2pOnlineStatus:) name:P2P_ONLINE_NOTI object:nil];
    }
    return self;
}

#pragma mark - p2p 状态改变通知
- (void) p2pOfflineStatus:(NSNotification *) noti
{
    self.image = [UIImage imageNamed:@"icon_offline"];
}
- (void) p2pOnlineStatus:(NSNotification *) noti
{
//    NSLog(@"%@",[NSThread currentThread]);
    self.image = [UIImage imageNamed:@"icon_online"];
}

@end
