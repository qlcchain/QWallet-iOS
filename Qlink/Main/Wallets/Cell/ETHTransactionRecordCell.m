//
//  ETHTransactionRecordCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHTransactionRecordCell.h"
#import "ETHAddressHistoryModel.h"
#import "NSDate+Category.h"
#import "NEOAddressHistoryModel.h"
#import "WalletCommonModel.h"
#import "ETHAddressTransactionsModel.h"
#import "EOSTraceModel.h"
#import "QLCAddressHistoryModel.h"

@interface ETHTransactionRecordCell ()

@property (nonatomic, strong) NSString *tokenHash;

@end

@implementation ETHTransactionRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _icon.image = nil;
    _addressLab.text = nil;
    _statusLab.text = nil;
    _timeLab.text = nil;
    _priceLab.text = nil;
}

- (void)configCellWithETHModel:(ETHAddressTransactionsModel *)model {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    BOOL isSend = NO;
    if ([[model.from lowercaseString] isEqualToString:[currentWalletM.address lowercaseString]]) {
        isSend = YES;
    }
    if (!isSend) {
        _icon.image = [UIImage imageNamed:@"icons_eth_trade_confirm"];
    } else {
        _icon.image = [UIImage imageNamed:@"icons_eth_trade_fail"];
    }

    _tokenHash = model.Hash;
    NSString *addressText = model.Hash;
    if (addressText.length > 8) {
        addressText = [NSString stringWithFormat:@"%@...%@",[addressText substringToIndex:8],[addressText substringWithRange:NSMakeRange(addressText.length - 8, 8)]];
    }
    _addressLab.text = addressText;
    _statusLab.text = nil;
    _timeLab.text = [NSDate getTimeWithTimestamp:[NSString stringWithFormat:@"%@",model.timestamp] format:@"MM/dd HH:mm" isMil:NO];
    _priceLab.text = [NSString stringWithFormat:@"%@%@ %@",isSend?@"-":@"+",[model getTokenNum],[model getSymbol]];
}

- (void)configCellWithETHOtherModel:(Operation *)model {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    BOOL isSend = NO;
    if ([[model.from lowercaseString] isEqualToString:[currentWalletM.address lowercaseString]]) {
        isSend = YES;
    }
    if (!isSend) {
        _icon.image = [UIImage imageNamed:@"icons_eth_trade_confirm"];
    } else {
        _icon.image = [UIImage imageNamed:@"icons_eth_trade_fail"];
    }

    _tokenHash = model.transactionHash;
    NSString *addressText = model.transactionHash;
    if (addressText.length > 8) {
        addressText = [NSString stringWithFormat:@"%@...%@",[addressText substringToIndex:8],[addressText substringWithRange:NSMakeRange(addressText.length - 8, 8)]];
    }
    _addressLab.text = addressText;
    _statusLab.text = nil;
    _timeLab.text = [NSDate getTimeWithTimestamp:[NSString stringWithFormat:@"%@",model.timestamp] format:@"MM/dd HH:mm" isMil:NO];
    _priceLab.text = [NSString stringWithFormat:@"%@%@ %@",isSend?@"-":@"+",[model getTokenNum],model.tokenInfo.symbol];
}

- (void)configCellWithNEOModel:(NEOAddressHistoryModel *)model {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    BOOL isSend = NO;
    if ([[model.address_from lowercaseString] isEqualToString:[currentWalletM.address lowercaseString]]) {
        isSend = YES;
    }
    if (!isSend) {
        _icon.image = [UIImage imageNamed:@"icons_eth_trade_confirm"];
    } else {
        _icon.image = [UIImage imageNamed:@"icons_eth_trade_fail"];
    }
    
    _tokenHash = model.txid;
    NSString *addressText = model.txid;
    if (addressText.length > 8) {
        addressText = [NSString stringWithFormat:@"%@...%@",[addressText substringToIndex:8],[addressText substringWithRange:NSMakeRange(addressText.length - 8, 8)]];
    }
    _addressLab.text = addressText;
    _statusLab.text = nil;
    _timeLab.text = [NSDate getTimeWithTimestamp:[NSString stringWithFormat:@"%@",model.time] format:@"MM/dd HH:mm" isMil:NO];
    _priceLab.text = [NSString stringWithFormat:@"%@%@ %@",isSend?@"-":@"+",[model getTokenNum],model.symbol];
}

- (void)configCellWithEOSModel:(EOSTraceModel *)model {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    BOOL isSend = NO;
    if ([model.sender isEqualToString:currentWalletM.account_name]) {
        isSend = YES;
    }
    if (!isSend) {
        _icon.image = [UIImage imageNamed:@"icons_eth_trade_confirm"];
    } else {
        _icon.image = [UIImage imageNamed:@"icons_eth_trade_fail"];
    }
    
    _tokenHash = model.trx_id;
    NSString *addressText = model.trx_id;
    if (addressText.length > 8) {
        addressText = [NSString stringWithFormat:@"%@...%@",[addressText substringToIndex:8],[addressText substringWithRange:NSMakeRange(addressText.length - 8, 8)]];
    }
    _addressLab.text = addressText;
    _statusLab.text = nil;
//    _timeLab.text = [NSDate getTimeWithTimestamp:[NSString stringWithFormat:@"%@",model.time] format:@"MM/dd HH:mm" isMil:NO];
    
    _timeLab.text = [NSDate getLocalDateFormateUTCDate:model.timestamp];
    _priceLab.text = [NSString stringWithFormat:@"%@%@ %@",isSend?@"-":@"+",[model getTokenNum],model.symbol];
}

- (void)configCellWithQLCModel:(QLCAddressHistoryModel *)model {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    BOOL isSend = [model.type isEqualToString:@"Send"]?YES:NO;
    if (!isSend) {
        _icon.image = [UIImage imageNamed:@"icons_eth_trade_confirm"];
    } else {
        _icon.image = [UIImage imageNamed:@"icons_eth_trade_fail"];
    }
    
    _tokenHash = model.Hash;
//    NSString *addressText = model.Hash;
    NSString *addressText = model.address;
    if (addressText.length > 8) {
        addressText = [NSString stringWithFormat:@"%@...%@",[addressText substringToIndex:8],[addressText substringWithRange:NSMakeRange(addressText.length - 8, 8)]];
    }
    _addressLab.text = addressText;
    _statusLab.text = nil;
    _timeLab.text = [NSDate getTimeWithTimestamp:[NSString stringWithFormat:@"%@",model.timestamp] format:@"MM/dd HH:mm" isMil:NO];
    _priceLab.text = [NSString stringWithFormat:@"%@%@ %@",isSend?@"-":@"+",[model getAmountNum],model.tokenName];
}

- (IBAction)copyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _tokenHash?:@"";
    [kAppD.window makeToastDisappearWithText:@"Copied"];
}


@end
