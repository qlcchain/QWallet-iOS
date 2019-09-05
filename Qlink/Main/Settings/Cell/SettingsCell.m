//
//  SettingsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "SettingsCell.h"
#import "FingerprintVerificationUtil.h"
#import "GlobalConstants.h"

@interface SettingsCell ()

@property (nonatomic, strong) SettingsShowModel *showM;

@end

@implementation SettingsShowModel

@end

@implementation SettingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithModel:(SettingsShowModel *)model {
    _showM = model;
    if (model.haveNextPage) {
        _detailLab.hidden = NO;
        _arrow.hidden = NO;
        _detailLab.text = model.detail;
    } else {
        _detailLab.hidden = YES;
        _arrow.hidden = YES;
    }
    _swit.hidden = !model.showSwitch;
    if ([model.title isEqualToString:kLang(title_screen_lock)]) {
        _swit.on = [FingerprintVerificationUtil getScreenLock];
    }
    _titleLab.text = model.title;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _titleLab.text = nil;
    _detailLab.text = nil;
}

- (IBAction)switchChange:(UISwitch *)sender {
    if ([_showM.title isEqualToString:kLang(title_screen_lock)]) {
        [FingerprintVerificationUtil setScreenLock:sender.on];
    }
}

@end
