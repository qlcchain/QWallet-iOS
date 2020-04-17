//
//  OutbreakRedCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/4/14.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OutbreakFocusModel;

static NSString *OutbreakRedCell_Reuse = @"OutbreakRedCell";
#define OutbreakRedCell_Height 81

typedef void(^OutbreakRedClickBlock)(OutbreakFocusModel *clickM);

@interface OutbreakRedCell : UITableViewCell

- (void)config:(OutbreakFocusModel *)model clickB:(OutbreakRedClickBlock)clickB;

@end

NS_ASSUME_NONNULL_END
