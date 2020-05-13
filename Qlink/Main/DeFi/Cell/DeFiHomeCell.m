//
//  DeFiHomeCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiHomeCell.h"
#import "DefiProjectListModel.h"
#import "NSString+RemoveZero.h"

@interface DeFiHomeCell ()

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *usdLab;
@property (weak, nonatomic) IBOutlet UILabel *chainLab;


@end

@implementation DeFiHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (void)config:(DefiProjectListModel *)model index:(NSInteger)index {
    _numLab.text = [NSString stringWithFormat:@"%@",@(index+1)];
    NSString *iconStr = [[model.name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    _icon.image = [UIImage imageNamed:iconStr];
    _nameLab.text = [model getShowName];
    NSString *usd_defi = [model.tvlUsd showfloatStr_Defi:2];
    _usdLab.text = [NSString stringWithFormat:@"$%@",usd_defi];
    _chainLab.text = model.chain;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
