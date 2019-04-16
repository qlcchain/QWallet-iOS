//
//  GuangGaoCollectionCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GuanggaoListModel;

static NSString *GuangGaoCollectionCellReuse = @"GuangGaoCollectionCell";
#define GuangGaoCollectionCell_Height 148

@interface GuangGaoCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgV;

- (void)configCell:(GuanggaoListModel *)model;

@end
