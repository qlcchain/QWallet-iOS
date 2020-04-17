//
//  OutbreakFocusModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/4/15.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const OutbreakFocusStatus_New = @"NEW";
static NSString *const OutbreakFocusStatus_NO_AWARD = @"NO_AWARD";
static NSString *const OutbreakFocusStatus_AWARDED = @"AWARDED";
static NSString *const OutbreakFocusStatus_OVERDUE = @"OVERDUE";

@interface OutbreakTransferModel : BBaseModel

@property (nonatomic, strong) NSString *fromAddress;// = "qlc_1q8xk7hdo8p3wym8wpb71zj4h1dmuby4twttm8o3h5ttae38dgrddo195e38";
@property (nonatomic, strong) NSString *toAddress;// = "qlc_1ek43jimwtcg9efmgznbozt7zi4qyz73wz9zi6b65ydrzbsywxy897tznpxm";
@property (nonatomic, strong) NSString *transferStatus;// = NEW;
@property (nonatomic, strong) NSString *txid;// = "";

@end

@interface OutbreakFocusModel : BBaseModel

@property (nonatomic, strong) NSString *createDate;// = "2020-04-15 15:37:39";
@property (nonatomic, strong) NSString *days;// = 1;
@property (nonatomic, strong) NSString *ID;// = 41b4e51b64ad487381c0c5d4e68001a9;
@property (nonatomic, strong) NSString *qgasAmount;// = "0.01012844";
//@property (nonatomic) double qgasAmount;
//@property (nonatomic, strong) NSString *qgasAmount_str;
@property (nonatomic, strong) NSString *qlcAmount;// = 100;
@property (nonatomic, strong) NSString *status;// NEW|AWARDED|NO_AWARD|OVERDUE
@property (nonatomic, strong) NSString *stepNumber;// = 0;
@property (nonatomic, strong) OutbreakTransferModel *transfer;

@end

NS_ASSUME_NONNULL_END
