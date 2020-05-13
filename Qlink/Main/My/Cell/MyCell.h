//
//  MyCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseTableCell.h"

static NSString *MyCellReuse = @"MyCell";
#define MyCell_Height 56

@interface MyShowModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic) BOOL showRed;
@property (nonatomic) BOOL isShow;

@end

@interface MyCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *redView;


- (void)configCellWithModel:(MyShowModel *)model;

@end
