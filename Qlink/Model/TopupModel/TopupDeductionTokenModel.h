//
//  TopupPayTokenModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/10/24.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopupDeductionTokenModel : BBaseModel

@property (nonatomic, strong) NSString *chain;// = "ETH_CHAIN";
@property (nonatomic, strong) NSString *Hash;// = 0x75231f58b43240c9718dd58b4967c5114342a86c;
@property (nonatomic, strong) NSString *ID;// = 25d073543212425b8f175ba2412ff3a0;
@property (nonatomic, strong) NSNumber *price;// = 18;
@property (nonatomic, strong) NSString *symbol;// = OKB;
@property (nonatomic, strong) NSString *logoPng;
@property (nonatomic, strong) NSString *logoWebp;

- (UIImage *)getDeductionTokenImage;

@end

NS_ASSUME_NONNULL_END
