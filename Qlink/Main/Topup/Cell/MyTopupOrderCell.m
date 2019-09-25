//
//  MyTopupOrderCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyTopupOrderCell.h"
#import "UIView+Visuals.h"

@implementation MyTopupOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _contentBack.layer.cornerRadius = 4;
    _contentBack.layer.masksToBounds = YES;
    
    [_contentBack addShadowWithOpacity:1.0 shadowColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5] shadowOffset:CGSizeMake(0,4) shadowRadius:10 andCornerRadius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
