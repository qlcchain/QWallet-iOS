//
//  ResetPWSuccessView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ResetPWSuccessView.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface ResetPWSuccessView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;

@end

@implementation ResetPWSuccessView

+ (instancetype)getInstance {
    ResetPWSuccessView *view = [[[NSBundle mainBundle] loadNibNamed:@"ResetPWSuccessView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)show {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    [self.tipBack showPopAnimate];
}

- (void)hide {
    [self removeFromSuperview];
}

@end
