//
//  WalletSelectCell.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/9.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "QBaseTableCell.h"

@interface WalletSelectCell : QBaseTableCell
@property (weak, nonatomic) IBOutlet UILabel *lblWalletKey;
@property (weak, nonatomic) IBOutlet UIImageView *selectBtn;

- (void) cellSelect:(BOOL) isSelect;

@end
