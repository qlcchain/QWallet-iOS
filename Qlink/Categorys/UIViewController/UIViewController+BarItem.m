//
//  UINavigationController+BarItem.m
//  LoveDaBai
//
//  Created by Jelly Foo on 15/12/7.
//  Copyright © 2015年 life. All rights reserved.
//

#import "UIViewController+BarItem.h"
#import "UIView+Frame.h"

#define KK_Orange_Color [UIColor colorWithRed:255.0/255.0 green:199.0/255.0 blue:6.0/255.0 alpha:1]

@implementation UIViewController (BarItem)

- (void)setLeftFirstItemWithFirstImage:(UIImage *)leftFirstImage LeftFirstItemWithFirstTitle:(NSString *)leftFirstTitle LeftFirstTarget:(id)leftFirstTarget LeftFirstSel:(SEL)leftFirstSel LeftSecondItemWithSecondImage:(UIImage *)leftSecondImage LeftSecondItemWithSecondTitle:(NSString *)leftSecondTitle LeftSecondTarget:(id)leftSecondTarget LeftSecondSel:(SEL)leftSecondSel {
    UIView *leftView = [[UIView alloc] init];
    
    UIButton *leftFirstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    if (leftFirstTitle && leftFirstTitle.length > 0) {
        [leftFirstButton setTitle:leftFirstTitle forState:UIControlStateNormal];
        leftFirstButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftFirstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (leftFirstImage) {
        [leftFirstButton setImage:leftFirstImage forState:UIControlStateNormal];
        leftFirstButton.frame = CGRectMake(0, (44 - leftFirstImage.size.height)/2.0, leftFirstImage.size.width, leftFirstImage.size.height);
    }
    [leftFirstButton addTarget:leftFirstTarget action:leftFirstSel forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:leftFirstButton];
    
    UIButton *leftSecondButton = [[UIButton alloc] initWithFrame:CGRectMake(leftFirstButton.right, 0, 44, 44)];
    if (leftSecondTitle && leftSecondTitle.length > 0) {
        [leftSecondButton setTitle:leftSecondTitle forState:UIControlStateNormal];
        leftSecondButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [leftSecondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (leftSecondImage) {
        [leftSecondButton setImage:leftSecondImage forState:UIControlStateNormal];
//        leftSecondButton.frame = CGRectMake(leftFirstButton.right, (44 - leftSecondImage.size.height)/2.0, leftSecondImage.size.width, leftSecondImage.size.height);
    }
    [leftSecondButton addTarget:leftSecondTarget action:leftSecondSel forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:leftSecondButton];
    
    leftView.frame = CGRectMake(0, 0, leftFirstButton.width+leftSecondButton.width, 44);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (UIButton *)setLeftItemWithImage:(UIImage *)leftImage LeftItemWithTitle:(NSString *)leftTitle LeftTitleColor:(UIColor *)leftColor LeftTarget:(id)leftTarget LeftSel:(SEL)leftSel {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    if (leftTitle && leftTitle.length > 0) {
        [backButton setTitle:leftTitle forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [backButton setTitleColor:leftColor forState:UIControlStateNormal];
    }
    
    if (leftImage) {
        [backButton setImage:leftImage forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    }
    
    [backButton addTarget:leftTarget action:leftSel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    return backButton;
}

- (UIButton *)setRightItemWithImage:(UIImage *)rightImage RightItemWithTitle:(NSString *)rightTitle RightTarget:(id)rightTarget RightSel:(SEL)rightSel {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    if (rightTitle && rightTitle.length > 0) {
        [rightButton setTitle:rightTitle forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        //        [backButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
        rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [rightButton setTitleColor:KK_Orange_Color forState:UIControlStateNormal];
    }
    
    if (rightImage) {
        [rightButton setImage:rightImage forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
    }
    
    [rightButton addTarget:rightTarget action:rightSel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    return rightButton;
}

- (UIButton *)setRightItemWithImage:(UIImage *)rightImage RightItemWithTitle:(NSString *)rightTitle RightTitleColor:(UIColor *)rightColor RightTarget:(id)rightTarget RightSel:(SEL)rightSel {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    if (rightTitle && rightTitle.length > 0) {
        [rightButton setTitle:rightTitle forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        //        [backButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
        rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    }
    
    if (rightImage) {
        [rightButton setImage:rightImage forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
    }
    
    [rightButton addTarget:rightTarget action:rightSel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    return rightButton;
}

- (UIButton *)setRightItemWithTitle:(NSString *)rightTitle TitleColor:(UIColor *)titleColor RightTarget:(id)rightTarget RightSel:(SEL)rightSel {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    if (rightTitle && rightTitle.length > 0) {
        [rightButton setTitle:rightTitle forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        //        [backButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
        rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [rightButton setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    [rightButton addTarget:rightTarget action:rightSel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    return rightButton;
}

@end
