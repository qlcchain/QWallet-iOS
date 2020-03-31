//
//  MyCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *MyCellReuse = @"MyCell";
#define MyCell_Height 56

@interface MyShowModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic) BOOL showRed;

@end

@interface MyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *redView;


- (void)configCellWithModel:(MyShowModel *)model;

@end
