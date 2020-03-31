//
//  MnemonicTipView.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/23.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TopupProductModel,TopupDeductionTokenModel;

typedef void(^StartGroupBuyOKBlock)(void);
typedef void(^StartGroupBuySuccessBlock)(void);

@interface StartGroupBuyView : UIView

@property (nonatomic, copy) StartGroupBuyOKBlock okBlock;
@property (nonatomic, copy) StartGroupBuySuccessBlock successBlock;

+ (instancetype)getInstance;
- (void)config:(TopupProductModel *)productM tokenM:(TopupDeductionTokenModel *)tokenM;
- (void)show;

@end

NS_ASSUME_NONNULL_END
