//
//  EditTextViewController.h
//  PNRouter
//
//  Created by 旷自辉 on 2018/9/15.
//  Copyright © 2018年 旷自辉. All rights reserved.
//

#import "QBaseViewController.h"

typedef enum : NSUInteger {
    EditUsername,
    EditEmail,
    EditPhone,
} EditType;

typedef void(^EditSuccessBlock)(NSString *text);

@interface EditTextViewController : QBaseViewController

@property (nonatomic, copy) EditSuccessBlock editSuccessB;

- (instancetype)initWithType:(EditType) type;

@end
