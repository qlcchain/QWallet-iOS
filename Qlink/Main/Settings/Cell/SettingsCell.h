//
//  SettingsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *SettingsCellReuse = @"SettingsCell";
#define SettingsCell_Height 48

@interface SettingsShowModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic) BOOL haveNextPage;

@end

@interface SettingsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UISwitch *swit;


- (void)configCellWithModel:(SettingsShowModel *)model;

@end

NS_ASSUME_NONNULL_END
