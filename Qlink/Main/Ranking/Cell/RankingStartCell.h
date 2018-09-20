//
//  RankingCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *RankingStartCellReuse = @"RankingStartCell";
#define RankingStartCell_Height 68
#define RankingStartCell_EARN_Height (68+37)

@class VPNRankMode;

@interface RankingStartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *trophyImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblconnet;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;

- (void) setVPNRankMode:(VPNRankMode *) mode withRow:(NSInteger)row;

@end
