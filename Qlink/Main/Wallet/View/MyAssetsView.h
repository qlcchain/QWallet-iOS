//
//  MyAssetsView.h
//  Qlink
//
//  Created by 旷自辉 on 2018/5/2.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAssetsCell.h"

//typedef void(^ClickCancelBlock)(void);

@interface MyAssetsView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic , copy) ClickSettingBlock setBlock;
//@property (nonatomic , copy) ClickCancelBlock cancelBlock;
@property (nonatomic ,strong) NSMutableArray *soureArray;
+ (MyAssetsView *)getNibView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelContraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelContraintH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelContraintBottom;
- (void)dismiss;
@end
