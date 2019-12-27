//
//  MnemonicTipView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ClaimSuccessTipView.h"
#import "UIView+Visuals.h"
#import "GlobalConstants.h"

@interface ClaimSuccessTipView ()

@property (weak, nonatomic) IBOutlet UIView *tipBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@end

@implementation ClaimSuccessTipView

+ (instancetype)getInstance {
    ClaimSuccessTipView *view = [[[NSBundle mainBundle] loadNibNamed:@"ClaimSuccessTipView" owner:self options:nil] lastObject];
    [view.tipBack cornerRadius:8];
    return view;
}

- (void)showWithTitle:(NSString *)title tip:(NSString *)tip {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [kAppD.window addSubview:self];
    _titleLab.text = title;
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:1.5];
}

- (void)hide {
    [self removeFromSuperview];
}


@end
