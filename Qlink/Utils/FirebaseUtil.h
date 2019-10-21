//
//  FirebaseUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2019/10/17.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirebaseConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirebaseUtil : NSObject

+ (void)logEventWithItemID:(NSString *)itemID itemName:(NSString *)itemName contentType:(NSString *)contentType;

@end

NS_ASSUME_NONNULL_END
