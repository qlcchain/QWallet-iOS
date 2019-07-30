//
//  TipOKView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TipOKBlock)(void);

@interface VerifyTipView : UIView

@property (nonatomic, copy) TipOKBlock okBlock;

+ (instancetype)getInstance;
- (void)showWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
