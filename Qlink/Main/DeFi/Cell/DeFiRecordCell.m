//
//  DeFiRecordCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiRecordCell.h"
#import "DefiProjectListModel.h"

@interface DeFiRecordCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


@end

@implementation DeFiRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)config:(DefiProjectListModel *)model {
    NSString *iconStr = [[model.name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    _icon.image = [UIImage imageNamed:iconStr];
    _nameLab.text = [model getShowName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
