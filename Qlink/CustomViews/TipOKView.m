//
//  TipOKView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "TipOKView.h"
#import "GlobalConstants.h"
#import "UIView+PopAnimate.h"

@interface TipOKView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation TipOKView

+ (instancetype)getInstance {
    TipOKView *view = [[[NSBundle mainBundle] loadNibNamed:@"TipOKView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)showWithTitle:(NSString *)title {
    _titleLab.text = title;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    [self.tipBack showPopAnimate];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)okAction:(id)sender {
    if (_okBlock) {
        _okBlock();
    }
    [self hide];
}

@end
