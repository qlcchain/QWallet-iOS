//
//  RefreshTableView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "RefreshTableView.h"
#import "GlobalConstants.h"

@implementation RefreshTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        [self addSubview:self.slimeView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.slimeView];
    }
    return self;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
//        NSLog(@"********************%@",@(self.frame.size.width));
//        NSLog(@"********************%@",@(SCREEN_WIDTH-34));
        _slimeView = [[SRRefreshView alloc] initWithHeight:SRHeight width:self.frame.size.width];
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = SRREFRESH_BACK_COLOR;
        _slimeView.slime.skinColor =  SRREFRESH_BACK_COLOR;
        _slimeView.slime.lineWith = 1;
       // _slimeView.slime.shadowBlur = 4;
       // _slimeView.slime.shadowColor = MAIN_BLUE_COLOR;
    }
    
    return _slimeView;
}

@end
