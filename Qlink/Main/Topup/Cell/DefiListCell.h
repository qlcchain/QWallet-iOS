//
//  DefiListCell.h
//  Qlink
//
//  Created by 旷自辉 on 2020/10/27.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *DefiListCell_Reuse = @"DefiListCell";
#define DefiListCell_Height 60

@interface DefiListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblUrl;

@end

NS_ASSUME_NONNULL_END
