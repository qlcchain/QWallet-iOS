//
//  ManageFundsView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnderlineView.h"

typedef enum : NSUInteger {
    CodeType,
    PasteType,
    SendNowType,
    MaxType,
    TxtChangeType
} BalanceType;

typedef void(^BalanceSendBlock)(BalanceType type);


@interface SendFundsView : UIView <UITextFieldDelegate>


+ (SendFundsView *)getNibView;

@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UnderlineView *txtLineView;


@property (weak, nonatomic) IBOutlet UITextField *txtMoney;
@property (weak, nonatomic) IBOutlet UIImageView *qlcImgView;
@property (nonatomic ,copy) BalanceSendBlock sendBlock;

@end
