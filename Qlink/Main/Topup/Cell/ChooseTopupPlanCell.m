//
//  FinanceCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ChooseTopupPlanCell.h"
#import "GlobalConstants.h"

@implementation ChooseTopupPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _whiteBack.layer.cornerRadius = 6;
    _whiteBack.layer.masksToBounds = YES;
    _contentBack.layer.cornerRadius = 8;
    _contentBack.layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
