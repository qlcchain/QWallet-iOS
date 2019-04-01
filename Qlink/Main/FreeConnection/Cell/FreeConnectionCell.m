//
//  FreeConnectionCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/7/18.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "FreeConnectionCell.h"
#import "FreeRecordMode.h"

@implementation FreeConnectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _nameLab.text = nil;
    _timeLab.text = nil;
    _numLab.text = nil;
}

- (void)setCellMode:(FreeRecordMode *) mode
{
    _nameLab.text = mode.assetName?:@"";
    _timeLab.text = mode.time?:@"";
    _numLab.text = mode.num?:@"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
