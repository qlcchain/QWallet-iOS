//
//  RankingCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseTableCell.h"

static NSString *RankingCellReuse = @"RankingCell";
#define RankingCell_Height 75

@class VPNRankMode;

@interface RankingCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UIImageView *trophyImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblconnet;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblSub1;
@property (weak, nonatomic) IBOutlet UILabel *lblSub2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameContraintV;

- (void) setVPNRankMode:(VPNRankMode *) mode withType:(NSString *) type withEnd:(BOOL) isEnd;

@end
