//
//  WebViewController.h
//  Qlink
//
//  Created by 旷自辉 on 2018/5/30.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseViewController.h"

@interface WebViewController : QBaseViewController
@property (nonatomic , assign) NSInteger type;

- (instancetype) initWithType:(NSInteger) urlType;
@end
