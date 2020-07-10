//
//  DefiPriceCell.h
//  Qlink
//
//  Created by 旷自辉 on 2020/7/8.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *DefiPriceCell_Reuse = @"DefiPriceCell";
#define DefiPriceCell_Height 140

@class DefiTokenModel;

@interface DefiPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblsysbol;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblGains;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblSupply;
@property (weak, nonatomic) IBOutlet UILabel *lblMarketValue;
@property (weak, nonatomic) IBOutlet UILabel *lblCrculation;
@property (weak, nonatomic) IBOutlet UIImageView *zfIcon;

- (void) config:(DefiTokenModel *) tokenM;

@end

NS_ASSUME_NONNULL_END
