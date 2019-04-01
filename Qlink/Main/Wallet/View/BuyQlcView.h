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
    BuyQLCType,
    BuyMaxType,
    BuyTxtChangeType
} BuyType;

typedef void(^BuyQLCBlock)(BuyType type);

@interface BuyQlcView : UIView<UITextFieldDelegate>

+ (BuyQlcView *)getNibView;
@property (weak, nonatomic) IBOutlet UITextField *txtNEO;
@property (weak, nonatomic) IBOutlet UITextField *txtQLC;
@property (weak, nonatomic) IBOutlet UnderlineView *txtLineView;
@property (weak, nonatomic) IBOutlet UILabel *lblNEOToQLC;


@property (nonatomic ,copy) BuyQLCBlock buyBlcok;

@end
