//
//  GroupBuyListModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/1/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

static NSString *const Group_Status_NEW = @"NEW";
static NSString *const Group_Status_PROCESSING = @"PROCESSING";
static NSString *const Group_Status_FULL = @"FULL";
static NSString *const Group_Status_CANCEL = @"CANCEL";
static NSString *const Group_Status_SUCCESS = @"SUCCESS";
static NSString *const Group_Status_FAIL = @"FAIL";
static NSString *const Group_Status_TIME_OUT = @"TIME_OUT";

NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyListItemModel : BBaseModel

@property (nonatomic, strong) NSString *head; // = "/data/dapp/head/f597e8eccf8e4624bcd92ef04d6881cb.jpg";
@property (nonatomic, strong) NSString *nickname; // = hzpa;
@property (nonatomic) BOOL isCommander;
@property (nonatomic, strong) NSString *ID;

@end

@interface GroupBuyListModel : BBaseModel

@property (nonatomic, strong) NSString *createDate;// = "2020-01-14 16:29:05";
@property (nonatomic, strong) NSString *deductionToken;// = QGAS;
@property (nonatomic, strong) NSString *deductionTokenAmount_str;// = "4.089";
@property (nonatomic) double deductionTokenAmount;
@property (nonatomic, strong) NSString *discount;// = "0.9";
@property (nonatomic, strong) NSNumber *duration;// = 180;
@property (nonatomic, strong) NSString *ID;// = ed8acf44868946a68f317cd1037166f8;
@property (nonatomic, strong) NSString *joined;// = 0;
@property (nonatomic, strong) NSNumber *numberOfPeople;// = 3;
@property (nonatomic, strong) NSString *payFiatMoney;// = "3.68";
@property (nonatomic, strong) NSString *payToken;// = QLC;
@property (nonatomic, strong) NSString *payTokenAmount_str;// = "3.14";
@property (nonatomic) double payTokenAmount;
@property (nonatomic, strong) NSNumber *payTokenPrice;// = 1;
@property (nonatomic, strong) NSString *status;// = PROCESSING;
@property (nonatomic, strong) NSString *head;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSArray *items;

@end

NS_ASSUME_NONNULL_END
