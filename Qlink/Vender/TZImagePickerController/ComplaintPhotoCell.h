//
//  ComplaintPhotoCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/19.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *ComplaintPhotoCellReuse = @"ComplaintPhotoCell";

@interface ComplaintPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, strong) id asset;

@end

NS_ASSUME_NONNULL_END
