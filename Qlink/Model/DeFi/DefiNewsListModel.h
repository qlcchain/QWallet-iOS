//
//  DefiNewsListModel.h
//  Qlink
//
//  Created by Jelly Foo on 2020/5/12.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DefiNewsListModel : BBaseModel

@property (nonatomic, strong) NSString *authod;//" : "andrey-shevchenko",
@property (nonatomic, strong) NSString *leadText;//" : "The Incognito privacy project is an interoperable chain that will let you privately use DeFi platforms without ever touching Ethereum itself.",
@property (nonatomic, strong) NSString *ID;//" : "b5e48032974c40109737dccf62122adf",
@property (nonatomic, strong) NSString *title;//" : "The Incognito Project Will Give Ethereum DeFi Monero-Like Privacy",
@property (nonatomic, strong) NSString *views;//" : 4920,
@property (nonatomic, strong) NSString *createDate;//" : "2020-04-27 19:36:00"
@property (nonatomic, strong) NSString *content;

@property (nonatomic) BOOL isShowDetail;
@property (nonatomic, strong) NSAttributedString *showContent;

- (NSString *)formattedDefiNewsTime;

@end

NS_ASSUME_NONNULL_END
