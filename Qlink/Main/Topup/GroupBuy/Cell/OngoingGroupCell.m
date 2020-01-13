//
//  OngoingGroupCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import "OngoingGroupCell.h"
#import "GroupPeopleView.h"
#import "GlobalConstants.h"

@interface OngoingGroupCell ()

@property (weak, nonatomic) IBOutlet UIView *peopleBack;
@property (nonatomic, strong) GroupPeopleView *groupPeopleV;

@end

@implementation OngoingGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (!_groupPeopleV) {
        _groupPeopleV = [GroupPeopleView getInstance];
        [_peopleBack addSubview:_groupPeopleV];
        kWeakSelf(self);
        [_groupPeopleV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(weakself.peopleBack).offset(0);
        }];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)config {
    [_groupPeopleV config:@[@"",@"",@""]];
}

@end
