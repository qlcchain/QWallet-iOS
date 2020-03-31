//
//  ETHTransferViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

//@class Token;
@class TopupProductModel;

@interface TopupPayETH_Deduction_CNYViewController : QBaseViewController

//@property (nonatomic, strong) Token *inputToken;
//@property (nonatomic, strong) NSArray *inputSourceArr;
//@property (nonatomic, strong) NSString *inputAddress;
//@property (nonatomic) BOOL transferToRoot;
//@property (nonatomic) BOOL transferToTradeDetail;

@property (nonatomic, strong) NSString *sendAmount;
@property (nonatomic, strong) NSString *sendToAddress;
@property (nonatomic, strong) NSString *sendMemo;
//@property (nonatomic, strong) NSString *inputTradeOrderId;
@property (nonatomic, strong) NSString *inputDeductionToken;
@property (nonatomic, strong) TopupProductModel *inputProductM;
@property (nonatomic, strong) NSString *inputAreaCode;
@property (nonatomic, strong) NSString *inputPhoneNumber;
@property (nonatomic, strong) NSString *inputDeductionTokenId;

@end

NS_ASSUME_NONNULL_END
