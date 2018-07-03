//
//  GuideSettingMoreView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/7/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideBaseView.h"

@interface GuideSettingMoreView : GuideBaseView

+ (GuideSettingMoreView *)getNibView;
- (void)showGuideToCircle1:(CGRect)circleFrame1 circle2:(CGRect)circleFrame2 tapBlock:(void (^)(void))tapB;

@end
