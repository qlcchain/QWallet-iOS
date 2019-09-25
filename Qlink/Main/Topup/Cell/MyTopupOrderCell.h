//
//  MyTopupOrderCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *MyTopupOrderCellReuse = @"MyTopupOrderCell";
#define MyTopupOrderCell_Height 170

@interface MyTopupOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *topupAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *topupStateLab;


@end

NS_ASSUME_NONNULL_END
