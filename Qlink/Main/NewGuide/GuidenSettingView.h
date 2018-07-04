//
//  GuidenSettingView.h
//  Qlink
//
//  Created by 旷自辉 on 2018/7/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "GuideBaseView.h"

@interface GuidenSettingView : GuideBaseView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;
+ (GuideBaseView *)getNibView;
@end
