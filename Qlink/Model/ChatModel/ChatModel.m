//
//  ChatModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/5/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

- (instancetype)init {
    if (self = [super init]) {
        self.messages = [NSMutableArray array];
    }
    
    return self;
}

@end
