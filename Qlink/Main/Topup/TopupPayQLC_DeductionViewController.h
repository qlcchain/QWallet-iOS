//
//  ETHTransferViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class QLCTokenModel,TopupProductModel,TopupOrderModel;

@interface TopupPayQLC_DeductionViewController : QBaseViewController

@property (nonatomic, strong) NSString *sendDeductionAmount;
@property (nonatomic, strong) NSString *sendDeductionToAddress;
@property (nonatomic, strong) NSString *sendDeductionMemo;
@property (nonatomic, strong) NSString *inputDeductionToken;

//@property (nonatomic, strong) TopupProductModel *inputProductM;
@property (nonatomic, strong) TopupOrderModel *inputOrderM;

@property (nonatomic, strong) NSString *sendPayTokenAmount;
@property (nonatomic, strong) NSString *sendPayTokenToAddress;
@property (nonatomic, strong) NSString *sendPayTokenMemo;
@property (nonatomic, strong) NSString *inputPayToken;

//@property (nonatomic, strong) NSString *inputAreaCode;
//@property (nonatomic, strong) NSString *inputPhoneNumber;
//@property (nonatomic, strong) NSString *inputDeductionTokenId;

@end

NS_ASSUME_NONNULL_END
