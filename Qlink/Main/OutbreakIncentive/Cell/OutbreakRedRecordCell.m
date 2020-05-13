//
//  ETHTransactionRecordCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "OutbreakRedRecordCell.h"
#import "ETHAddressHistoryModel.h"
#import "NSDate+Category.h"
#import "NEOAddressHistoryModel.h"
#import "WalletCommonModel.h"
#import "ETHAddressTransactionsModel.h"
#import "EOSTraceModel.h"
#import "QLCAddressHistoryModel.h"
#import "GlobalConstants.h"
#import "OutbreakFocusModel.h"
#import "QBaseTouchButton.h"

@interface OutbreakRedRecordCell ()

@property (nonatomic, strong) NSString *strToCopy;
@property (weak, nonatomic) IBOutlet QBaseTouchButton *copBtn;

@end

@implementation OutbreakRedRecordCell

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
    
//    _icon.image = nil;
    _addressLab.text = nil;
    _statusLab.text = nil;
    _timeLab.text = nil;
    _priceLab.text = nil;
}

- (void)config:(OutbreakFocusModel *)model {
    _strToCopy = model.transfer.txid;
    NSString *addressText = model.transfer.txid;
    if (addressText && addressText.length > 8) {
        addressText = [NSString stringWithFormat:@"%@...%@",[addressText substringToIndex:8],[addressText substringWithRange:NSMakeRange(addressText.length - 8, 8)]];
        _copBtn.hidden = NO;
    } else {
        _copBtn.hidden = YES;
    }
    _addressLab.text = addressText;
    _statusLab.text = nil;
    _timeLab.text = [NSDate dateFromTime_c:model.createDate dateFormat:@"MM/dd HH:mm"];
//    _timeLab.text = [NSDate getTimeWithTimestamp:[NSString stringWithFormat:@"%@",model.createDate] format:@"MM/dd HH:mm" isMil:NO];
    _priceLab.text = [NSString stringWithFormat:@"%@%@ %@",@"+",model.qgasAmount,@"QGAS"];
}

- (IBAction)copyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _strToCopy?:@"";
    [kAppD.window makeToastDisappearWithText:@"Copied"];
}


@end
