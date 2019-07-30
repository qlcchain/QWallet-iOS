//
//  WalletsManageCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/16.
//  Copyright © 2018 pan. All rights reserved.
//

#import "WalletsManageCell.h"
#import "WalletCommonModel.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import "UIView+Visuals.h"

@implementation WalletsManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_shadowBack addShadowWithOpacity:1 shadowColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:0.5] shadowOffset:CGSizeMake(0,4) shadowRadius:10 andCornerRadius:12];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithModel:(WalletCommonModel *)model tokenPriceArr:(NSArray *)tokenPriceArr {
    if (model.walletType == WalletTypeETH) {
        _icon.image = [UIImage imageNamed:@"eth_wallet"];
        _addressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
    } else if (model.walletType == WalletTypeNEO) {
        _icon.image = [UIImage imageNamed:@"neo_wallet"];
        _addressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
    } else if (model.walletType == WalletTypeEOS) {
        _icon.image = [UIImage imageNamed:@"eos_wallet"];
        _addressLab.text = model.account_name;
    } else if (model.walletType == WalletTypeQLC) {
        _icon.image = [UIImage imageNamed:@"qlc_wallet"];
        _addressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
    }
    
    _nameLab.text = model.name;
    
    [self refreshPriceWithArr:tokenPriceArr model:model];
}

- (void)refreshPriceWithArr:(NSArray *)tokenPriceArr model:(WalletCommonModel *)walletCommonM {
    __block NSString *totalPrice = @"";
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (walletCommonM.walletType == WalletTypeETH) {
        NSString *num = [NSString stringWithFormat:@"%@",walletCommonM.balance];
        [tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TokenPriceModel *model = obj;
            if ([model.symbol isEqualToString:@"ETH"]) {
                NSNumber *usdNum = @([num doubleValue]*[model.price doubleValue]);
                totalPrice = [[NSString stringWithFormat:@"%@",usdNum] removeFloatAllZero];
                *stop = YES;
            }
        }];
    } else if (walletCommonM.walletType == WalletTypeEOS) {
        NSString *num = [NSString stringWithFormat:@"%@",walletCommonM.balance];
        [tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TokenPriceModel *model = obj;
            if ([model.symbol isEqualToString:@"EOS"]) {
                NSNumber *usdNum = @([num doubleValue]*[model.price doubleValue]);
                totalPrice = [[NSString stringWithFormat:@"%@",usdNum] removeFloatAllZero];
                *stop = YES;
            }
        }];
    } else if (walletCommonM.walletType == WalletTypeNEO) {
        NSString *num = [NSString stringWithFormat:@"%@",walletCommonM.balance];
        [tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TokenPriceModel *model = obj;
            if ([model.symbol isEqualToString:@"NEO"]) {
                NSNumber *usdNum = @([num doubleValue]*[model.price doubleValue]);
                totalPrice = [[NSString stringWithFormat:@"%@",usdNum] removeFloatAllZero];
                *stop = YES;
            }
        }];
    } else if (walletCommonM.walletType == WalletTypeQLC) {
        NSString *num = [NSString stringWithFormat:@"%@",walletCommonM.balance];
        [tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TokenPriceModel *model = obj;
            if ([model.symbol isEqualToString:@"QLC"]) {
                NSNumber *usdNum = @([num doubleValue]*[model.price doubleValue]);
                totalPrice = [[NSString stringWithFormat:@"%@",usdNum] removeFloatAllZero];
                *stop = YES;
            }
        }];
    }
    
    _priceLab.text = [NSString stringWithFormat:@"%@ %@",[ConfigUtil getLocalUsingCurrencySymbol],totalPrice];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _icon.image = nil;
    _nameLab.text = nil;
    _addressLab.text = nil;
    _priceLab.text = nil;
}

- (IBAction)moreAction:(id)sender {
    if (_moreBlock) {
        _moreBlock();
    }
}


@end
