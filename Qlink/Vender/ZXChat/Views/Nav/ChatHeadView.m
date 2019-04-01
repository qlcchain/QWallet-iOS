//
//  ChatHeadView.m
//  Qlink
//
//  Created by Jelly Foo on 2018/5/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChatHeadView.h"

@interface ChatHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation ChatHeadView

+ (ChatHeadView *)getNibView {
    ChatHeadView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"ChatHeadView" owner:self options:nil] firstObject];
    
    return nibView;
}

- (IBAction)backAction:(id)sender {
    if (_backB) {
        _backB();
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLab.text = title;
}

@end
