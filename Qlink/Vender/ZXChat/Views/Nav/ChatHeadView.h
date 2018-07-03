//
//  ChatHeadView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/5/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ChatHeadViewHeight 67

typedef void(^ChatHeadBackBlock)(void);

@interface ChatHeadView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) ChatHeadBackBlock backB;

+ (ChatHeadView *)getNibView;

@end
