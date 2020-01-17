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
#import "GroupBuyListModel.h"
#import "GlobalConstants.h"
#import "RLArithmetic.h"
#import "NSDate+Category.h"
#import "UserModel.h"

@interface OngoingGroupCell ()

@property (weak, nonatomic) IBOutlet UIView *peopleBack;
@property (nonatomic, strong) GroupPeopleView *groupPeopleV;

@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *remainLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@property (nonatomic, copy) OngoingGroupJoinBlock joinB;
@property (nonatomic, strong) GroupBuyListModel *listM;

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
    
    _joinBtn.layer.cornerRadius = 4;
    _joinBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)config:(GroupBuyListModel *)model joinB:(OngoingGroupJoinBlock)joinB {
    _joinB = joinB;
    _listM = model;
    NSString *discountNumStr = @"0";
    NSString *language = [Language currentLanguageCode];
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        discountNumStr = @(100).sub(model.discount.mul(@(100)));
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        discountNumStr = model.discount.mul(@(10));
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        discountNumStr = @(100).sub(model.discount.mul(@(100)));
    }
    
    NSString *discountShowStr = @"";
    NSString *remainShowStr = @"";
    if ([language isEqualToString:LanguageCode[0]]) { // 英文
        discountShowStr = [NSString stringWithFormat:@"%@%% off, %@ discount partners",discountNumStr,model.numberOfPeople];
        remainShowStr = [NSString stringWithFormat:@"%@ more partner needed",model.numberOfPeople.sub(model.joined?:@"0")];
    } else if ([language isEqualToString:LanguageCode[1]]) { // 中文
        discountShowStr = [NSString stringWithFormat:@"满%@人%@折团",model.numberOfPeople,discountNumStr];
        remainShowStr = [NSString stringWithFormat:@"还差%@人",model.numberOfPeople.sub(model.joined?:@"0")];
    } else if ([language isEqualToString:LanguageCode[2]]) { // 印尼
        discountShowStr = [NSString stringWithFormat:@"%@%% off, %@ discount partners",discountNumStr,model.numberOfPeople];
        remainShowStr = [NSString stringWithFormat:@"%@ more partner needed",model.numberOfPeople.sub(model.joined?:@"0")];
    }
    _discountLab.text = discountShowStr;
    _remainLab.text = remainShowStr;
    _timeLab.text = [NSString stringWithFormat:@"%@:%@",kLang(@"valid_till"),[NSDate getTimeWithFromTime:model.createDate addMin:[model.duration integerValue]]];
    
//    __block BOOL isJoin = NO;
//    UserModel *userM = [UserModel fetchUserOfLogin];
//    [model.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        GroupBuyListItemModel *tempM = obj;
//        if ([tempM.ID isEqualToString:userM.ID]) {
//            isJoin = YES;
//        }
//    }];
//    _joinBtn.hidden = isJoin;
    
    GroupBuyListItemModel *itemM = [GroupBuyListItemModel new];
    itemM.head = model.head;
    itemM.nickname = model.nickname;
    itemM.isCommander = YES;
    NSMutableArray *itemArr = [NSMutableArray array];
    [itemArr addObjectsFromArray:model.items];
    [itemArr addObject:itemM];
    [_groupPeopleV config:itemArr];
}

- (IBAction)joinAction:(id)sender {
    if (_joinB) {
        _joinB(_listM);
    }
}


@end
