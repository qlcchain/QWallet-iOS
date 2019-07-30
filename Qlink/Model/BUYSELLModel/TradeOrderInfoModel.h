//
//  TradeOrderInfoModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeOrderInfoModel : BBaseModel

@property (nonatomic, strong) NSString *appealDate;// = "";
@property (nonatomic, strong) NSString *buyerConfirmDate;// = "";
@property (nonatomic, strong) NSString *buyerId;// = 61be9c09c0784827af303005f983c705;
@property (nonatomic, strong) NSString *closeDate;// = "";
@property (nonatomic, strong) NSString *entrustOrderId;// = 604861837ad046909418cac7247a6e91;
@property (nonatomic, strong) NSString *head;// = "";
@property (nonatomic, strong) NSString *ID;// = a52d6b9ebcee436ab3ae71fbf0907298;
@property (nonatomic, strong) NSString *nickname;// = "ios_test";
@property (nonatomic, strong) NSString *number;// = 20190718154158708852;
@property (nonatomic, strong) NSString *orderTime;// = "2019-07-18 15:41:59";
@property (nonatomic, strong) NSNumber *qgasAmount;// = 10;
@property (nonatomic, strong) NSString *qgasFromAddress;// = "qlc_1ek43jimwtcg9efmgznbozt7zi4qyz73wz9zi6b65ydrzbsywxy897tznpxm";
@property (nonatomic, strong) NSString *qgasToAddress;// = "qlc_1ek43jimwtcg9efmgznbozt7zi4qyz73wz9zi6b65ydrzbsywxy897tznpxm";
@property (nonatomic, strong) NSString *qgasTransferAddress;// = "qlc_3wpp343n1kfsd4r6zyhz3byx4x74hi98r6f1es4dw5xkyq8qdxcxodia4zbb";
@property (nonatomic, strong) NSString *sellerConfirmDate;// = "";
@property (nonatomic, strong) NSString *sellerId;// = 61be9c09c0784827af303005f983c705;
@property (nonatomic, strong) NSString *status;// = "QGAS_TO_PLATFORM";
@property (nonatomic, strong) NSString *txid;// = "";
@property (nonatomic, strong) NSString *unitPrice;// = "0.001";
@property (nonatomic, strong) NSString *usdtAmount;// = "0.01";
@property (nonatomic, strong) NSString *usdtFromAddress;// = "";
@property (nonatomic, strong) NSString *usdtToAddress;// = 0x9B833b57eFF94c45C91C5D28302CF481a9c766D0;
@property (nonatomic, strong) NSString *appealStatus;
@property (nonatomic, strong) NSString *appealerId;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *photo1;
@property (nonatomic, strong) NSString *photo2;
@property (nonatomic, strong) NSString *photo3;
@property (nonatomic, strong) NSString *photo4;
@property (nonatomic, strong) NSString *auditFeedback;

@end

NS_ASSUME_NONNULL_END
