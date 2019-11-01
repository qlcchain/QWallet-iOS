//
//  QToastView.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QToastView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"

@interface QToastView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation QToastView

+ (instancetype)getInstance {
    QToastView *view = [[[NSBundle mainBundle] loadNibNamed:@"QToastView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:4];
    return view;
}

+ (void)showWithTitle:(NSString *)title {
    QToastView *view = [QToastView getInstance];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:view];
    view.titleLab.text = title;
    
    view.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
    [view performSelector:@selector(hide) withObject:nil afterDelay:2];
}

- (void)hide {
    [self removeFromSuperview];
}


@end
