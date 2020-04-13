//
//  PersonalInfoCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseTableCell.h"

static NSString *PersonalInfoCellReuse = @"PersonalInfoCell";
#define PersonalInfoCell_Height 48

@interface PersonalInfoShowModel : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *val;
@property (nonatomic) BOOL showArrow;
@property (nonatomic) BOOL showCopy;
@property (nonatomic) BOOL showHead;

@end

@interface PersonalInfoCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *keyLab;
@property (weak, nonatomic) IBOutlet UILabel *valLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconCopy;
@property (weak, nonatomic) IBOutlet UIImageView *iconArrow;
@property (weak, nonatomic) IBOutlet UIImageView *iconHead;

- (void)configCell:(PersonalInfoShowModel *)model;

@end
