//
//  OutbreakRedCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/4/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import "OutbreakRedCell.h"
#import "QBaseDarkButton.h"
#import "GlobalConstants.h"
#import "OutbreakFocusModel.h"

@interface OutbreakRedCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopOffset;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet QBaseDarkButton *checkBtn;
@property (nonatomic, copy) OutbreakRedClickBlock clickB;
@property (nonatomic, strong) OutbreakFocusModel *clickM;
 
@end

@implementation OutbreakRedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _checkBtn.layer.cornerRadius = 13;
    _checkBtn.layer.masksToBounds = YES;
    _checkBtn.layer.borderColor = MAIN_BLUE_COLOR.CGColor;
    _checkBtn.layer.borderWidth = 0.5;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    
}

- (void)config:(OutbreakFocusModel *)model clickB:(OutbreakRedClickBlock)clickB {
    _clickB = clickB;
    _clickM = model;
    _titleLab.text = kLang(@"daily_bounty");
    
    NSString *tipStr = @"";
    NSString *qlcStr = model.qlcAmount;
    NSString *dayStr = model.days;
    NSString *language = [Language currentLanguageCode];
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        tipStr = [NSString stringWithFormat:kLang(@"claim_qgas_from_staked_qlc_by_checking_out_the___"),qlcStr,dayStr];
        _titleTopOffset.constant = 10;
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        tipStr = [NSString stringWithFormat:kLang(@"claim_qgas_from_staked_qlc_by_checking_out_the___"),dayStr,qlcStr];
        _titleTopOffset.constant = 16;
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        tipStr = [NSString stringWithFormat:kLang(@"claim_qgas_from_staked_qlc_by_checking_out_the___"),qlcStr,dayStr];
        _titleTopOffset.constant = 10;
    }
    _tipLab.text = tipStr;
    
    if ([model.status isEqualToString:OutbreakFocusStatus_New]) {
        [_checkBtn setTitle:kLang(@"check") forState:UIControlStateNormal];
        [_checkBtn setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
        _checkBtn.backgroundColor = [UIColor whiteColor];
    } else if ([model.status isEqualToString:OutbreakFocusStatus_NO_AWARD]) {
        [_checkBtn setTitle:kLang(@"Claim") forState:UIControlStateNormal];
        [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkBtn.backgroundColor = MAIN_BLUE_COLOR;
    } else if ([model.status isEqualToString:OutbreakFocusStatus_AWARDED]) {
        [_checkBtn setTitle:kLang(@"awarded") forState:UIControlStateNormal];
        [_checkBtn setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
        _checkBtn.backgroundColor = [UIColor whiteColor];
   } else if ([model.status isEqualToString:OutbreakFocusStatus_OVERDUE]) {
          [_checkBtn setTitle:kLang(@"overdue") forState:UIControlStateNormal];
          [_checkBtn setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
          _checkBtn.backgroundColor = [UIColor whiteColor];
      }
}

- (IBAction)clickAction:(id)sender {
    if (_clickB) {
        _clickB(_clickM);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
