//
//  PageOneView.m
//  Qlink
//
//  Created by 旷自辉 on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "PageOneView.h"

@implementation PageOneView

- (void) dealloc
{
    [_timer invalidate];
    _timer = nil;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //发光
        _winQImgView.layer.shadowRadius = 6;
        _winQImgView.layer.shadowColor = [UIColor whiteColor].CGColor;
        _winQImgView.layer.shadowOffset = CGSizeMake(0, 0);
        _winQImgView.layer.shadowOpacity = 0.9f;
    }
    return self;
}
- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {
    
    if (CGRectEqualToRect(self.mainImageView.frame, superViewBounds)) {
        return;
    }
    
    self.mainImageView.frame = superViewBounds;
    self.coverView.frame = superViewBounds;
   // self.indexLabel.frame = CGRectMake(0, 10, superViewBounds.size.width, 20);
}
- (void) statrtTimeCountdownWithSecons:(double) secons
{
    _timeSecons = secons;
    if (secons!=0)
    {
        _subSecons = 0;
        //时间间隔是100毫秒，也就是0.1秒
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
// 每间隔1秒定时器触发执行该方法
- (void)timerAction
{
    
    [self getTimeFromTimeInterval:_timeSecons] ;
    
    // 当时间间隔为0时干掉定时器
    if (_timeSecons-_subSecons == 0)
    {
        _subSecons = 0.0;
        [_timer invalidate];
        _timer = nil;
    }
}

// 通过时间间隔计算具体时间(小时,分,秒,毫秒)
- (void)getTimeFromTimeInterval : (double)timeInterval
{
    //1s=1000毫秒
    _subSecons += 1.0f;//毫秒数从0-9，所以每次过去100毫秒
    
    //天数
    NSString *days = [NSString stringWithFormat:@"%ld", (NSInteger)((_timeSecons-_subSecons)/(24*3600))];
    //小时数
    NSString *hours = [NSString stringWithFormat:@"%ld", (NSInteger)((_timeSecons-_subSecons)/60/60)%24];
    //分钟数
    NSString *minute = [NSString stringWithFormat:@"%ld", (NSInteger)((_timeSecons-_subSecons)/60)%60];
    //秒数
    NSString *second = [NSString stringWithFormat:@"%ld", ((NSInteger)(_timeSecons-_subSecons))%60];
   
    if (minute.integerValue < 10) {
        minute = [NSString stringWithFormat:@"0%@", minute];
    }
    if (second.integerValue < 10) {
        second = [NSString stringWithFormat:@"0%@", second];
    }
    if (days.integerValue < 10) {
        days = [NSString stringWithFormat:@"0%@", days];
    }
    if (hours.integerValue < 10) {
        hours = [NSString stringWithFormat:@"0%@", hours];
    }
    
    _lblMin.text = [NSString stringWithFormat:@"%@",minute];
    _lblSecon.text = [NSString stringWithFormat:@"%@",second];
    _lblHour.text = [NSString stringWithFormat:@"%@",hours];
    _lblDay.text = [NSString stringWithFormat:@"%@",days];
    
}
@end
