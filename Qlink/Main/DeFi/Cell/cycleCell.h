//
//  cycleCell.h
//  Qlink
//
//  Created by 旷自辉 on 2020/7/10.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *cycleCell_Reuse = @"cycleCell";


@interface cycleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSysbol;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblZF;
@property (weak, nonatomic) IBOutlet UIImageView *zfIcon;



@end

NS_ASSUME_NONNULL_END
