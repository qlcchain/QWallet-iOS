//
//  ChooseCountryView.h
//  Qlink
//
//  Created by 旷自辉 on 2018/7/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectCountryBlock)(id selectCountry);

@interface ChooseCountryView : UIView
@property (weak, nonatomic) IBOutlet UITableView *myTabView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContraintH;

@property (nonatomic , copy) SelectCountryBlock selectCountryBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgContraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabContraintH;
@property (nonatomic , assign) BOOL isSave;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;

+ (instancetype) loadChooseCountryView;
- (void) showChooseCountryView;
@end
