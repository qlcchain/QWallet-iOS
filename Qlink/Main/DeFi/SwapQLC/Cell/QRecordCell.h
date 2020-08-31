//
//  QRecordCell.h
//  Qlink
//
//  Created by 旷自辉 on 2020/8/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *QRecordCellReuse = @"QRecordCell";
#define QRecordCell_Height 140

typedef void(^ClickClaimBlcok)(void);

@interface QRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *claimBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (nonatomic ,copy) ClickClaimBlcok claimBlock;
@property (weak, nonatomic) IBOutlet UILabel *lblExpierTime;

@end

NS_ASSUME_NONNULL_END
