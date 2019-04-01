//
//  FreeConnectionCell.h
//  Qlink
//
//  Created by Jelly Foo on 2018/7/18.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FreeRecordMode;
static NSString *FreeConnectionCellReuse = @"FreeConnectionCell";
#define FreeConnectionCell_Height 65

@interface FreeConnectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

- (void) setCellMode:(FreeRecordMode *) mode;

@end
