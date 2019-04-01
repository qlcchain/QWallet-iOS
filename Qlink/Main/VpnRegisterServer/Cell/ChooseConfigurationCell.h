//
//  ChooseConfigurationCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/8/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ChooseConfigurationCellReuse = @"ChooseConfigurationCell";
#define ChooseConfigurationCell_Height 38

@interface ChooseConfigurationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

- (void)configCellWithName:(NSString *)name;

@end
