//
//  JoinCommunityCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/16.
//  Copyright © 2018 pan. All rights reserved.
//

#import "JoinCommunityCell.h"

@implementation JoinCommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithIcon:(NSString *)icon name:(NSString *)name url:(NSString *)url {
    _icon.image = [UIImage imageNamed:icon];
    _nameLab.text = name;
    _urlLab.text = url;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _icon.image = nil;
    _nameLab.text = nil;
    _urlLab.text = nil;
}

@end
