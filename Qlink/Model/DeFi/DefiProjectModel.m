//
//  DefiProjectModel.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/8.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DefiProjectModel.h"
#import "GlobalConstants.h"

static NSString *const Defi_type_lending = @"Lending";
static NSString *const Defi_type_dexes = @"DEXes";
static NSString *const Defi_type_derivatives = @"Derivatives";
static NSString *const Defi_type_payments = @"Payments";
static NSString *const Defi_type_assets = @"Assets";

@implementation DefiProject_ValModel

@end

@implementation DefiProject_KeyModel


@end

@implementation DefiProjectModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id", @"Description":@"description"};
}

- (void)setJsonValue:(NSString *)jsonValue {
    _jsonValue = jsonValue;
    
    NSDictionary *jsonDic = [jsonValue mj_JSONObject];
    NSDictionary *tvlDic = jsonDic[@"tvl"];
    if (tvlDic != nil) {
        NSMutableArray *tempArr = [NSMutableArray array];
        [tvlDic.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *keyStr = obj;
            NSDictionary *valDic = tvlDic[keyStr];
            DefiProject_KeyModel *keyModel = [DefiProject_KeyModel new];
            keyModel.keyStr = keyStr;
            keyModel.valModel = [DefiProject_ValModel mj_objectWithKeyValues:valDic];
            [tempArr addObject:keyModel];
        }];
        _tvlArr = tempArr;
    }
}

+ (NSString *)getScoreStr:(NSString *)_selectRate {
    NSString *selectScore = @"10";
     if ([_selectRate isEqualToString:@"A++"]) {
         selectScore = @"10";
     } else if ([_selectRate isEqualToString:@"A+"]) {
         selectScore = @"9";
     } else if ([_selectRate isEqualToString:@"A"]) {
         selectScore = @"8";
     } else if ([_selectRate isEqualToString:@"B++"]) {
         selectScore = @"7";
     } else if ([_selectRate isEqualToString:@"B+"]) {
         selectScore = @"6";
     } else if ([_selectRate isEqualToString:@"B"]) {
         selectScore = @"5";
     } else if ([_selectRate isEqualToString:@"C"]) {
        selectScore = @"4";
    } else if ([_selectRate isEqualToString:@"D"]) {
          selectScore = @"3";
      }
    return selectScore;
}

+ (NSString *)getRatingStr:(NSString *)_rating {
    NSString *ratingStr = @"10";
     if ([_rating isEqualToString:@"10"]) {
         ratingStr = @"A++";
     } else if ([_rating isEqualToString:@"9"]) {
         ratingStr = @"A+";
     } else if ([_rating isEqualToString:@"8"]) {
         ratingStr = @"A";
     } else if ([_rating isEqualToString:@"7"]) {
         ratingStr = @"B++";
     } else if ([_rating isEqualToString:@"6"]) {
         ratingStr = @"B+";
     } else if ([_rating isEqualToString:@"5"]) {
         ratingStr = @"B";
     } else if ([_rating isEqualToString:@"4"]) {
        ratingStr = @"C";
    } else if ([_rating isEqualToString:@"3"]) {
          ratingStr = @"D";
    } else if ([_rating isEqualToString:@"0"]) {
        ratingStr = kLang(@"defi_unrated");
    }
    return ratingStr;
}

+ (UIColor *)getRatingColor:(NSString *)_rating {
    UIColor *ratingStr = UIColorFromRGB(0xFF3669);
     if ([_rating isEqualToString:@"10"]) {
         ratingStr = UIColorFromRGB(0x7ED321);
     } else if ([_rating isEqualToString:@"9"]) {
         ratingStr = UIColorFromRGB(0x7ED321);
     } else if ([_rating isEqualToString:@"8"]) {
         ratingStr = UIColorFromRGB(0x7ED321);
     } else if ([_rating isEqualToString:@"7"]) {
         ratingStr = MAIN_BLUE_COLOR;
     } else if ([_rating isEqualToString:@"6"]) {
         ratingStr = MAIN_BLUE_COLOR;
     } else if ([_rating isEqualToString:@"5"]) {
         ratingStr = MAIN_BLUE_COLOR;
     } else if ([_rating isEqualToString:@"4"]) {
        ratingStr = UIColorFromRGB(0xF5A623);
    } else if ([_rating isEqualToString:@"3"]) {
        ratingStr = UIColorFromRGB(0xFF3669);
    } else if ([_rating isEqualToString:@"0"]) {
        ratingStr = UIColorFromRGB(0xFF3669);
    }
    return ratingStr;
}

- (UIColor *)getCategoryColor {
    UIColor *color = UIColorFromRGB(0xFF679D);
    if ([self.category isEqualToString:Defi_type_lending]) {
        color = UIColorFromRGB(0x945BFF);
    } else if ([self.category isEqualToString:Defi_type_dexes]) {
        color = UIColorFromRGB(0xFFB46A);
    } else if ([self.category isEqualToString:Defi_type_derivatives]) {
        color = UIColorFromRGB(0x00C0FF);
    } else if ([self.category isEqualToString:Defi_type_payments]) {
        color = UIColorFromRGB(0x7ED321);
    } else if ([self.category isEqualToString:Defi_type_assets]) {
        color = UIColorFromRGB(0x0C66FF);
    }
    
    return color;
}

+ (NSString *)getExperUrl:(NSString *)project {
    NSString *url = @"";
    if ([project isEqualToString:@"Maker"]) {
        url = @"https://makerdao.com";
    } else if ([project isEqualToString:@"Synthetix"]) {
        url = @"https://www.synthetix.io";
    } else if ([project isEqualToString:@"Compound"]) {
        url = @"https://compound.finance";
    } else if ([project isEqualToString:@"Aave"]) {
        url = @"https://aave.com";
    } else if ([project isEqualToString:@"Uniswap"]) {
        url = @"https://uniswap.io";
    } else if ([project isEqualToString:@"InstaDApp"]) {
        url = @"https://instadapp.io";
    } else if ([project isEqualToString:@"dYdX"]) {
        url = @"https://dydx.exchange";
    } else if ([project isEqualToString:@"Set Protocol"]) {
        url = @"https://www.tokensets.com";
    } else if ([project isEqualToString:@"WBTC"]) {
        url = @"https://www.wbtc.network";
    } else if ([project isEqualToString:@"Lightning Network"]) {
        url = @"https://lightning.network";
    } else if ([project isEqualToString:@"Bancor"]) {
        url = @"https://www.bancor.network";
    } else if ([project isEqualToString:@"Loopring"]) {
        url = @"https://loopring.org";
    } else if ([project isEqualToString:@"Kyber"]) {
       url = @"https://kyber.network";
   } else if ([project isEqualToString:@"Nexus Mutual"]) {
       url = @"https://nexusmutual.io";
   } else if ([project isEqualToString:@"bZx"]) {
       url = @"https://bzx.network";
   } else if ([project isEqualToString:@"DDEX"]) {
       url = @"https://ddex.io";
   } else if ([project isEqualToString:@"Erasure"]) {
       url = @"https://erasure.world";
   } else if ([project isEqualToString:@"Nuo Network"]) {
       url = @"https://nuo.network";
   } else if ([project isEqualToString:@"RAY"]) {
       url = @"https://staked.us/v/robo-advisor-yield/";
   } else if ([project isEqualToString:@"Opyn"]) {
       url = @"https://opyn.co";
   } else if ([project isEqualToString:@"Dharma"]) {
       url = @"https://www.dharma.io";
   } else if ([project isEqualToString:@"Augur"]) {
       url = @"https://www.augur.net";
   } else if ([project isEqualToString:@"Melon"]) {
       url = @"https://melonprotocol.com";
   } else if ([project isEqualToString:@"xDai"]) {
     url = @"https://www.xdaichain.com";
 } else if ([project isEqualToString:@"Veil"]) {
     url = @"https://veil.co";
 } else if ([project isEqualToString:@"Connext"]) {
     url = @"https://connext.network";
 } else if ([project isEqualToString:@"dForce"]) {
     url = @"https://dforce.network";
 }
    return url;
}

- (NSString *)getShowName {
    NSString *showName = _name;
    if (nil != _shortName && _shortName.length > 0) {
        showName = _shortName;
    }
    return showName;
}

@end
