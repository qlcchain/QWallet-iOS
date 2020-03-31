//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GroupBuyListModel,TopupProductModel,TopupDeductionTokenModel,TopupOrderModel;

typedef void(^JoinGroupBuyViewOKBlock)(void);
typedef void(^JoinGroupBuySuccessBlock)(TopupOrderModel *model);

@interface JoinGroupBuyView : UIView

@property (nonatomic, copy) JoinGroupBuyViewOKBlock okBlock;
@property (nonatomic, copy) JoinGroupBuySuccessBlock successBlock;

+ (instancetype)getInstance;
- (void)config:(TopupProductModel *)productM tokenM:(TopupDeductionTokenModel *)tokenM joinM:(GroupBuyListModel *)joinM phoneNum:(NSString *)phoneNum;
- (void)show;

@end

NS_ASSUME_NONNULL_END
