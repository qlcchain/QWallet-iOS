//
//  ETHTransactionRecordCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Operation,NEOAddressHistoryModel,ETHAddressTransactionsModel,EOSTraceModel,QLCAddressHistoryModel;

static NSString *ETHTransactionRecordCellReuse = @"ETHTransactionRecordCell";
#define ETHTransactionRecordCell_Height 64

@interface ETHTransactionRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

- (void)configCellWithETHModel:(ETHAddressTransactionsModel *)model;
- (void)configCellWithETHOtherModel:(Operation *)model;
- (void)configCellWithNEOModel:(NEOAddressHistoryModel *)model;
- (void)configCellWithEOSModel:(EOSTraceModel *)model;
- (void)configCellWithQLCModel:(QLCAddressHistoryModel *)model;

@end

NS_ASSUME_NONNULL_END
