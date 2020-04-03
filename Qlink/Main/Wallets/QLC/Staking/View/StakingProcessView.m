//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "StakingProcessView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface StakingProcessView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *importantLab;


@end

@implementation StakingProcessView

+ (instancetype)getInstance {
    StakingProcessView *view = [[[NSBundle mainBundle] loadNibNamed:@"StakingProcessView" owner:self options:nil] lastObject];
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
