//
//  FirebaseUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/17.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FirebaseUtil.h"
@import Firebase;

@implementation FirebaseUtil

+ (void)logEventWithItemID:(NSString *)itemID itemName:(NSString *)itemName contentType:(NSString *)contentType {
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:itemID,
                                     kFIRParameterItemName:itemName,
                                     kFIRParameterContentType:contentType
                                     }];
}

@end
