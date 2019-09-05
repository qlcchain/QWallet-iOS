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
    [view.tipBack cornerRadius:8];
    return view;
}

+ (void)showWithTitle:(NSString *)title {
    QToastView *view = [QToastView getInstance];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:view];
    view.titleLab.text = title;
    
    [view performSelector:@selector(hide) withObject:nil afterDelay:1.5];
}

- (void)hide {
    [self removeFromSuperview];
}


@end
