//
//  MyTopupOrderCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TopupOrderModel;

static NSString *MyTopupOrderCellReuse = @"MyTopupOrderCell";
//#define MyTopupOrderCell_Height 180

typedef void(^MyTopupOrderCancelBlock)(void);
typedef void(^MyTopupOrderPayBlock)(void);
typedef void(^MyTopupOrderCredentialBlock)(void);
typedef void(^MyTopupOrderCredentialDetalBlock)(void);

@interface MyTopupOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *topupAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *topupStateLab;
@property (weak, nonatomic) IBOutlet UILabel *discountAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *qgasAmountLab;
@property (weak, nonatomic) IBOutlet UIView *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *credentialLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *credentialDetailHeight; // 48
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payHeight; // 48


+ (CGFloat)cellHeight:(TopupOrderModel *)model;
- (void)config:(TopupOrderModel *)model cancelB:(MyTopupOrderCancelBlock)cancelB payB:(MyTopupOrderPayBlock)payB credentialB:(MyTopupOrderCredentialBlock)credentialB credetialDetalB:(MyTopupOrderCredentialDetalBlock)credentialDetailB;

@end

NS_ASSUME_NONNULL_END
