//
//  DeFiKeystatsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DefiProject_KeyModel;

static NSString *DeFiKeystatsCell_Reuse = @"DeFiKeystatsCell";
#define DeFiKeystatsCell_Height 48

@interface DeFiKeystatsCell : UITableViewCell

- (void)config:(DefiProject_KeyModel *)model;

@end

NS_ASSUME_NONNULL_END
