//
//  DeFiHotCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiHotCell.h"
#import "GlobalConstants.h"
#import "DefiNewsListModel.h"

@interface DeFiHotCell ()

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *circle;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (nonatomic, strong) DefiNewsListModel *newsM;
@property (nonatomic, copy) DefiNewsListContentBlock contentB;
@property (nonatomic) NSInteger index;

@end

@implementation DeFiHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _circle.layer.cornerRadius = _circle.width/2.0;
    _circle.layer.masksToBounds = YES;
}

- (void)config:(DefiNewsListModel *)model index:(NSInteger)index contentB:(DefiNewsListContentBlock)contentB {
    _newsM = model;
    _contentB = contentB;
    _index = index;
    
    _topLine.hidden = index==0?YES:NO;
    
    _timeLab.text = [model formattedDefiNewsTime];
    _titleLab.text = model.title;
//    _contentLab.text = model.showContent;
    _contentLab.attributedText = model.showContent;
    
}

+ (CGFloat)cellHeight:(DefiNewsListModel *)model {
    CGFloat topOffset = 40;
    CGFloat titleHeight = 0;
    CGFloat centerOffset = 8;
    CGFloat contentHeight = 0;
    CGFloat bottomOffset = 10;
    
    UIFont *titleFont = [UIFont systemFontOfSize:15];
    titleHeight = [model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-28-16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titleFont} context:nil].size.height+2;
    
//    UIFont *contentFont = [UIFont systemFontOfSize:15];
    contentHeight = [model.showContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-28-16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size.height+2;
    
    return topOffset+titleHeight+centerOffset+contentHeight+bottomOffset;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (IBAction)contentAction:(UIButton *)sender {
    
    _newsM.isShowDetail = !_newsM.isShowDetail;
    if (_contentB) {
        _contentB(_newsM,_index);
    }
}


@end
