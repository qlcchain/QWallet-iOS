//
//  TopupPayHelper.h
//  Qlink
//
//  Created by Jelly Foo on 2020/2/12.
//  Copyright © 2020 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TopupDeductionTokenModel,TopupProductModel;

@interface TopupPayHelper : NSObject

@property (nonatomic, strong) TopupDeductionTokenModel *selectDeductionTokenM;
@property (nonatomic, strong) NSString *selectPhoneNum;

+ (instancetype)shareInstance;
- (void)handlerPayCNY:(TopupProductModel *)model;
- (void)handlerPayToken:(TopupProductModel *)model;

@end

NS_ASSUME_NONNULL_END
