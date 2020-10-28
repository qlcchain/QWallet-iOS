//
//  UrlCell.h
//  Qlink
//
//  Created by 旷自辉 on 2020/10/27.
//  Copyright © 2020 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickClearBlock)(NSInteger tag);

static NSString *UrlCellReuse = @"UrlCell";
#define UrlCelllHeight 50

@interface UrlCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, copy) ClickClearBlock clearBlock;

@end

NS_ASSUME_NONNULL_END
