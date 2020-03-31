//
//  NEOGasClaimModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/3/29.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NEOGasClaimModel : BBaseModel

@property (nonatomic, strong) NSString *address;// = ;
@property (nonatomic, strong) NSArray *claimable;// =         ();
@property (nonatomic, strong) NSArray *claims;// =         ();
//@property (nonatomic, strong) NSString *unclaimed;// = "";
@property (nonatomic) double unclaimed;
@property (nonatomic, strong) NSString *unclaimed_str;// = "";

@end

NS_ASSUME_NONNULL_END
