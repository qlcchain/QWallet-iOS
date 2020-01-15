//
//  GroupKindModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/1/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupKindModel : BBaseModel

@property (nonatomic, strong) NSString *discount;// = "0.9";
@property (nonatomic, strong) NSNumber *duration;// = 180;
@property (nonatomic, strong) NSString *ID;// = 887867843fd44424af4032a77ea51cda;
@property (nonatomic, strong) NSString *name;// = "三人团";
@property (nonatomic, strong) NSString *nameEn;// = "3 peoples";
@property (nonatomic, strong) NSNumber *numberOfPeople;// = 3;

@end

NS_ASSUME_NONNULL_END
