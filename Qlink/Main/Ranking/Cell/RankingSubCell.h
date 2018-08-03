//
//  RankingSubCell.h
//  Qlink
//
//  Created by 旷自辉 on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//


#import <UIKit/UIKit.h>

static NSString *RankingSubCellReuse = @"RankingSubCell";
#define RankingSubCell_Height 75
@class VPNRankMode;
@interface RankingSubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblconnet;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
- (void) setVPNRankMode:(VPNRankMode *) mode;
@end
