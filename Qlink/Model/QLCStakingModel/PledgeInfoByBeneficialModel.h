//
//  PledgeInfoByBeneficialModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/3.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const PledgeState_PledgeStart = @"PledgeStart";
static NSString *const PledgeState_PledgeProcess = @"PledgeProcess";
static NSString *const PledgeState_PledgeDone = @"PledgeDone";
static NSString *const PledgeState_WithdrawStart = @"WithdrawStart";
static NSString *const PledgeState_WithdrawProcess = @"WithdrawProcess";
static NSString *const PledgeState_WithdrawDone = @"WithdrawDone";

@interface PledgeInfoByBeneficialModel : BBaseModel

@property (nonatomic, strong) NSString *beneficial;//": "qlc_1u1d7mgo8hq5nad8jwesw6azfk53a31ge5minwxdfk8t1fqknypqgk8mi3z7",
@property (nonatomic, strong) NSString *pledge;//": "qlc_3hw8s1zubhxsykfsq5x7kh6eyibas9j3ga86ixd7pnqwes1cmt9mqqrngap4",
@property (nonatomic, strong) NSString *amount;//": "240000000",
@property (nonatomic, strong) NSString *multiSigAddress;//": "AH7E3oeRbN6EBp2dmf6EBE8sBoMiwkJqG6",
@property (nonatomic, strong) NSString *pType;//": "vote",
@property (nonatomic, strong) NSString *nep5TxId;//": "467efd04938d060722154cc57d3047d408ba8066601acc1ece72ccd5b0566d04",
@property (nonatomic, strong) NSString *pledgeTime;//": 1559125993,
@property (nonatomic, strong) NSString *withdrawTime;//": 1557253757,
@property (nonatomic, strong) NSString *lastModifyTime;//": 1557209757,
@property (nonatomic, strong) NSString *qgas;//": 23000000000
@property (nonatomic, strong) NSString *state;//": "PledgeDone"

@end

NS_ASSUME_NONNULL_END
