//
//  TopupProductModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/9/25.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TopupDeductionTokenModel,GroupBuyListItemModel;

@interface TopupProductModel : BBaseModel

/**
* countryEn : All Operators in China
* explain : 72小时内到账 急用勿拍
* country : 中国
* descriptionEn : 慢充话费，折扣低，价格实惠
* localFiat : CNY 当地法币
* isp : 通用  运营商
* payWay : FIAT   支付方式，fiat= 法币 token = 代币
* description : 慢充话费，折扣低，价格实惠
* discount : 0.98
* nameEn : All provinces of China
* qgasDiscount : 0.02   抵扣币的折扣
* amountOfMoney : 30,50,100   当地法币的金额，和支付币的金额一一对应
* upTime : 2019-10-19 13:31:34
* ispEn :
* payFiatAmount : 30,50,100      支付币的金额
* province : 全国
* payFiat : CYN  支付法币是哪一个
* imgPath : /userfiles/1/images/topup/2019/10/3a117d16c4654ab78a332db30613dadb.jpg
* name : 全国通用
* explainEn : 72小时内到账 急用勿拍
* id : 4b51058ae87141df9217b2d8de9530cc
* stock : -1    库存
* provinceEn :
* payTokenSymbol : QLC 支付币，如果是法币支付，这个字段没有
* payTokenUsdProce : 0.0   支付币美元价格
* payTokenCnyProce : 0.5   支付币人民币价格
*/

@property (nonatomic, strong) NSString *countryEn; //" : "中国",
@property (nonatomic, strong) NSString *explain; //" : "1",
@property (nonatomic, strong) NSString *country; //" : "中国",
@property (nonatomic, strong) NSString *descriptionEn; //" : "1",
@property (nonatomic, strong) NSString *isp; //" : "移动",
@property (nonatomic, strong) NSString *Description; //" : "1",
@property (nonatomic, strong) NSNumber *discount; // 产品的折扣 " : 0.95,
@property (nonatomic, strong) NSNumber *qgasDiscount;
@property (nonatomic, strong) NSString *nameEn; //" : "广东移动",
@property (nonatomic, strong) NSString *amountOfMoney; //" : "50,100,200,300,400,500",
@property (nonatomic, strong) NSString *upTime; //" : "2019-09-25 14:47:17",
@property (nonatomic, strong) NSString *ispEn; //" : "移动",
@property (nonatomic, strong) NSString *province; //" : "广东",
@property (nonatomic, strong) NSString *imgPath; //" : "/",
@property (nonatomic, strong) NSString *name; //" : "广东移动",
@property (nonatomic, strong) NSString *explainEn; //" : "1",
@property (nonatomic, strong) NSString *ID; //" : "56594c9614984f149ec93b51e5161fyy",
@property (nonatomic, strong) NSString *provinceEn; //" : "广东"
@property (nonatomic, strong) NSNumber *stock;//  0:代表没有库存
@property (nonatomic, strong) NSString *deductionToken; //  QGAS
@property (nonatomic, strong) NSString *payFiat; // CYN
@property (nonatomic, strong) NSString *payFiatAmount; //
@property (nonatomic, strong) NSString *payWay; //  FIAT
@property (nonatomic, strong) NSString *payTokenSymbol;
@property (nonatomic, strong) NSNumber *payTokenUsdPrice;
@property (nonatomic, strong) NSNumber *payTokenCnyPrice;
@property (nonatomic, strong) NSString *localFiat;
@property (nonatomic, strong) NSString *payTokenChain; // QLC_CHAIN

@property (nonatomic, strong) NSString *localFaitMoney;
@property (nonatomic, strong) NSString *payTokenMoney;

@property (nonatomic, strong) NSString *localFiatAmount;
@property (nonatomic, strong) NSString *orderTimes;
@property (nonatomic, strong) NSString *haveGroupBuy;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSNumber *groupDiscount; // 团购最低的折扣

//"countryEn" : "All Operators in China",
//"explain" : "72小时内到账 急用勿拍",
//"country" : "中国",
//"isp" : "通用",
//"payWay" : "FIAT",
//"description" : "慢充话费，折扣低，价格实惠",
//"discount" : 0.98,
//"qgasDiscount" : 0.02,
//"payFiatAmount" : "100",
//"province" : "全国",
//"explainEn" : "72小时内到账 急用勿拍",
//"id" : "4b51058ae87141df9217b2d8de9530cc",
//"stock" : -1,
//"descriptionEn" : "慢充话费，折扣低，价格实惠",
//"localFiat" : "CNY",
//"localFiatAmount" : "100",
//"nameEn" : "All provinces of China",
//"orderTimes" : 0,
//"upTime" : "2019-10-19 13:31:34",
//"ispEn" : "",
//"payFiat" : "CNY",
//"imgPath" : "/userfiles/1/images/topup/2019/10/3a117d16c4654ab78a332db30613dadb.jpg",
//"name" : "全国通用",
//"haveGroupBuy" : "no",
//"items" : "",
//"provinceEn" : ""


+ (NSString *)getAmountShow:(TopupProductModel *)productM tokenM:(TopupDeductionTokenModel *)tokenM;
+ (NSString *)getAmountShow:(TopupProductModel *)productM tokenM:(TopupDeductionTokenModel *)tokenM groupDiscount:(NSString *)groupDiscount;
- (TopupProductModel *)v2ToV3;


@end

NS_ASSUME_NONNULL_END
