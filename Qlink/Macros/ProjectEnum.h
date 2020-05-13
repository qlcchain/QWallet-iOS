//
//  ProjectEnum.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/29.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectEnum : NSObject

typedef enum : NSUInteger {
    WalletTypeETH,
    WalletTypeEOS,
    WalletTypeNEO,
    WalletTypeQLC,
    WalletTypeAll,
} WalletType;

typedef NS_ENUM(NSUInteger, OTCRecordListType) {
    OTCRecordListTypePosted = 0,
    OTCRecordListTypeProcessing,
    OTCRecordListTypeCompleted,
    OTCRecordListTypeClosed,
    OTCRecordListTypeAppealed,
};

typedef NS_ENUM(NSUInteger, TopupPayType) {
    TopupPayTypeNormal = 0,
    TopupPayTypeGroupBuy,
};

@end

NS_ASSUME_NONNULL_END
