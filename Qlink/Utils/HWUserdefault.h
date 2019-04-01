//
//  HWUserdefault.h
//  GemPay
//
//  Created by Gempay on 15/2/6.
//  Copyright (c) 2015年 GemPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWUserdefault : NSObject

+ (void)insertString:(NSString *)object withkey:(NSString *)key;
+ (void)insertData:(NSData*)object withkey:(NSString *)key;
+ (void)insertInt:(NSInteger)object withkey:(NSString *)key;
+ (void)deleteObjectWithKey:(NSString *)key;
+ (void)insertObj:(NSObject *)object withkey:(NSString *)key;
+ (id)getObjectWithKey:(NSString *)key;
+ (void)deleteObjectWithKeyArray:(NSArray *)array;
+ (NSString *)getStringWithKey:(NSString *)key;
+ (NSInteger)getIntWithKey:(NSString *)key;
+ (NSData*) getDataWithKey:(NSString*) key;
+ (void)insertArr:(NSMutableArray*)object withkey:(NSString *)key;
+ (NSMutableArray*) getArrWithKey:(NSString*) key;


@end
