//
//  GroupBuyListModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/1/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

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
@property (nonatomic, strong) NSString *deductionTokenAmount;// = "4.089";
@property (nonatomic, strong) NSString *discount;// = "0.9";
@property (nonatomic, strong) NSNumber *duration;// = 180;
@property (nonatomic, strong) NSString *ID;// = ed8acf44868946a68f317cd1037166f8;
@property (nonatomic, strong) NSString *joined;// = 0;
@property (nonatomic, strong) NSNumber *numberOfPeople;// = 3;
@property (nonatomic, strong) NSString *payFiatMoney;// = "3.68";
@property (nonatomic, strong) NSString *payToken;// = QLC;
@property (nonatomic, strong) NSString *payTokenAmount;// = "3.14";
@property (nonatomic, strong) NSNumber *payTokenPrice;// = 1;
@property (nonatomic, strong) NSString *status;// = PROCESSING;
@property (nonatomic, strong) NSString *head;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSArray *items;

@end

NS_ASSUME_NONNULL_END
