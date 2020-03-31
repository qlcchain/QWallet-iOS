//
//  GroupPeopleView.h
//  Qlink
//
//  Created by Jelly Foo on 2020/1/13.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupPeopleView : UIView

+ (instancetype)getInstance;
- (void)configGroupBuy:(NSArray *)urlArr;
- (void)configAssemble:(NSArray *)urlArr;

@end

NS_ASSUME_NONNULL_END
