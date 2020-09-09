//
//  QSwapProcessAnimateView.h
//  Qlink
//
//  Created by 旷自辉 on 2020/8/24.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QCloseSwapProcessBlock)(void);

@interface QSwapProcessAnimateView : UIView

@property (nonatomic, copy) QCloseSwapProcessBlock qCloseBlock;

+ (instancetype)getInstance;
- (void)show;
- (void)hide;
- (void)updateStage:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
