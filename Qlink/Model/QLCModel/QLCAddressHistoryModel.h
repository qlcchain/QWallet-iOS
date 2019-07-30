//
//  QLCAddressHistoryModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/5/29.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QLCTokenInfoModel;

@interface QLCAddressHistoryModel : BBaseModel

@property (nonatomic, strong) NSString *address;// = "qlc_3wpp343n1kfsd4r6zyhz3byx4x74hi98r6f1es4dw5xkyq8qdxcxodia4zbb";
@property (nonatomic, strong) NSNumber *amount;// = 100000000;
@property (nonatomic, strong) NSNumber *balance;// = 9406108847568;
@property (nonatomic, strong) NSString *extra;// = 0000000000000000000000000000000000000000000000000000000000000000;
@property (nonatomic, strong) NSString *Hash;// = 531b3294f03e1c429e6581a572119f312c976465d508c6bc6082edad6f786230;
@property (nonatomic, strong) NSString *link;// = 3be86e07f7b022c753fedb7b98b56f11cab8bf7bf016c31c345fae742b6e9890;
@property (nonatomic, strong) NSString *message;// = 0e5751c026e543b2e8ab2eb06099daa1d1e5df47778f7787faab45cdf12fe3a8;
@property (nonatomic, strong) NSNumber *network;// = 0;
@property (nonatomic, strong) NSNumber *oracle;// = 0;
@property (nonatomic, strong) NSNumber *povHeight;// = 0;
@property (nonatomic, strong) NSString *previous;// = 9b83ca68925b93a78f5213047a2940cb7170c9071c31028e2e6bd4d35a967da8;
@property (nonatomic, strong) NSString *representative;// = "qlc_3hw8s1zubhxsykfsq5x7kh6eyibas9j3ga86ixd7pnqwes1cmt9mqqrngap4";
@property (nonatomic, strong) NSString *signature;// = 98790a3cb77d469bf8453ce69a2767efa566823478c2d0fddb54dd972e98daadc7eb2738acdebdf592102da3bb6d7d08e235d967f9de22283fd9a0c2c6cdea0d;
@property (nonatomic, strong) NSNumber *storage;// = 0;
@property (nonatomic, strong) NSNumber *timestamp;// = 1559118175;
@property (nonatomic, strong) NSString *token;// = a7e8fa30c063e96a489a47bc43909505bd86735da4a109dca28be936118a8582;
@property (nonatomic, strong) NSString *tokenName;// = QLC;
@property (nonatomic, strong) NSString *type;// = Send;
@property (nonatomic, strong) NSNumber *vote;// = 0;
@property (nonatomic, strong) NSString *work;// = 6073842b3a0cda2a;
@property (nonatomic, strong) QLCTokenInfoModel *tokenInfoM;

- (NSString *)getTokenNum;
- (NSString *)getAmountNum;

@end

NS_ASSUME_NONNULL_END
