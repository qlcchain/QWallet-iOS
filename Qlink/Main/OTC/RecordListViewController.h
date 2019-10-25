//
//  MyOrderListViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OTCRecordListType) {
    OTCRecordListTypePosted = 0,
    OTCRecordListTypeProcessing,
    OTCRecordListTypeCompleted,
    OTCRecordListTypeClosed,
    OTCRecordListTypeAppealed,
};

@class PairsModel;

@interface RecordListViewController : QBaseViewController

@property (nonatomic) OTCRecordListType inputType;

@end

NS_ASSUME_NONNULL_END
