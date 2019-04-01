//
//  JoinCommunityCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/16.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *JoinCommunityCellReuse = @"JoinCommunityCell";
#define JoinCommunityCell_Height 72

@interface JoinCommunityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *urlLab;

- (void)configCellWithIcon:(NSString *)icon name:(NSString *)name url:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
