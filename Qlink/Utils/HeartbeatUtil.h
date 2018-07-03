//
//  HeartbeatUtil.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/27.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeartbeatUtil : NSObject
{
    dispatch_source_t _timer;
}
+ (instancetype) shareInstance;
+ (void) sendHeartbeatRequest;
- (void) sendTimedHeartbeat;
- (void) freeTime;
@end
