//
//  GuidePageView2.m
//  Qlink
//
//  Created by 旷自辉 on 2018/6/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuidePageView2.h"

@implementation GuidePageView2
+ (instancetype) loadGuidePageView2
{
    return [[[NSBundle mainBundle] loadNibNamed:@"GuidePageView2" owner:self options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
