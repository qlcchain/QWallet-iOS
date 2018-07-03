//
//  nounView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/23.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "NounView.h"

@implementation NounView


+ (id) loadNounViewWithFrame:(CGRect) rect
{
    NounView *nounView = [[[NSBundle mainBundle] loadNibNamed:@"NounView" owner:self options:nil] lastObject];
    nounView.frame = rect;
    nounView.layer.cornerRadius = rect.size.height/2;
    nounView.layer.masksToBounds = YES;
    nounView.backgroundColor = [UIColor whiteColor];
    return nounView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
