//
//  FinanceCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupCell.h"
#import "GlobalConstants.h"

@implementation TopupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _discountBack.layer.cornerRadius = 14;
    _discountBack.layer.masksToBounds = YES;
    _contentBack.layer.cornerRadius = 10;
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
