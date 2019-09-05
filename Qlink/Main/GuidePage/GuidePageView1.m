//
//  GuidePageView1.m
//  Qlink
//
//  Created by 旷自辉 on 2018/6/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuidePageView1.h"
#import "GlobalConstants.h"

@interface GuidePageView1 ()

@property (weak, nonatomic) IBOutlet UIView *bottomBack;

@end

@implementation GuidePageView1

+ (instancetype)loadGuidePageView1 {
    GuidePageView1 *view = [[[NSBundle mainBundle] loadNibNamed:@"GuidePageView1" owner:self options:nil] lastObject];
    UIColor *shadowColor = [UIColorFromRGB(0x34547A) colorWithAlphaComponent:0.1];
    [view.bottomBack addShadowWithOpacity:1 shadowColor:shadowColor shadowOffset:CGSizeMake(0,-1) shadowRadius:10 andCornerRadius:0];

    return view;
}


@end
