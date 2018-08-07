//
//  FreeRecordMode.h
//  Qlink
//
//  Created by 旷自辉 on 2018/7/18.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface FreeRecordMode : BBaseModel

@property (nonatomic , strong) NSString *fromP2pId;
@property (nonatomic , strong) NSString *assetName;
@property (nonatomic , assign) NSInteger freeType;
@property (nonatomic , strong) NSString *num;
@property (nonatomic , strong) NSString *time;
@property (nonatomic , strong) NSString *toAddress;
@property (nonatomic , strong) NSString *toP2pId;

@end
