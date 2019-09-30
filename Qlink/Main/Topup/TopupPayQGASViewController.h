//
//  ETHTransferViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class QLCTokenModel,TopupProductModel;

@interface TopupPayQGASViewController : QBaseViewController

//@property (nonatomic) BOOL transferToRoot;
//@property (nonatomic) BOOL transferToTradeDetail;
@property (nonatomic, strong) NSString *sendAmount;
@property (nonatomic, strong) NSString *sendToAddress;
@property (nonatomic, strong) NSString *sendMemo;
//@property (nonatomic, strong) NSString *inputTradeOrderId;
@property (nonatomic, strong) NSString *inputPayToken;
@property (nonatomic, strong) TopupProductModel *inputProductM;
@property (nonatomic, strong) NSString *inputAreaCode;
@property (nonatomic, strong) NSString *inputPhoneNumber;

@end

NS_ASSUME_NONNULL_END
