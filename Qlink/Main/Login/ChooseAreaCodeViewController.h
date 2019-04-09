//
//  ChooseAreaCodeViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseViewController.h"

@class AreaCodeModel;

typedef void(^ChooseAreaCodeBlock)(AreaCodeModel *model);

@interface ChooseAreaCodeViewController : QBaseViewController

@property (nonatomic, copy) ChooseAreaCodeBlock chooseB;

@end
