//
//  QLCAccountPendingModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/6/5.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLCAccountPendingModel : BBaseModel

@property (nonatomic, strong) NSString *source;//:String?
@property (nonatomic, strong) NSNumber *amount;//:BigUInt?
@property (nonatomic, strong) NSString *type;//:String?
@property (nonatomic, strong) NSString *tokenName;//:String?
@property (nonatomic, strong) NSString *Hash;//:String?
@property (nonatomic, strong) NSNumber *timestamp;//:Int64?
@property (nonatomic, strong) NSString *account;//:String?

@end

NS_ASSUME_NONNULL_END
