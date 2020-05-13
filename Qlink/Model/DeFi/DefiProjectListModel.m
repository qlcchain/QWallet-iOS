//
//  DefiProjectListModel.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DefiProjectListModel.h"
#import "NSString+RemoveZero.h"
#import "GlobalConstants.h"

static NSString *const Defi_type_lending = @"Lending";
static NSString *const Defi_type_dexes = @"DEXes";
static NSString *const Defi_type_derivatives = @"Derivatives";
static NSString *const Defi_type_payments = @"Payments";
static NSString *const Defi_type_assets = @"Assets";

@implementation DefiProjectListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

//- (NSString *)tvlUsd_str {
//    return [NSString doubleToString:_tvlUsd];
//}

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
