//
//  HWUserdefault.m
//  GemPay
//
//  Created by Gempay on 15/2/6.
//  Copyright (c) 2015年 GemPay. All rights reserved.
//

#import "HWUserdefault.h"

@implementation HWUserdefault

+ (void)insertObj:(NSObject *)object withkey:(NSString *)key {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:key];
    [user setObject:object forKey:key];
    [user synchronize];
}

+ (NSString *)getObjectWithKey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *object = [user objectForKey:key];
    return object;
}

+ (void)insertString:(NSString *)object withkey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:key];
    [user setObject:object forKey:key];
    [user synchronize];
}
+ (void)insertData:(NSData*)object withkey:(NSString *)key{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:key];
    [user setObject:object forKey:key];
    [user synchronize];
};

+ (void)insertInt:(NSInteger)object withkey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:key];
    [user setInteger:object forKey:key];
    [user synchronize];
}
+ (void)insertArr:(NSMutableArray*)object withkey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:key];
    [user setObject:object forKey:key];
}



+ (void)deleteObjectWithKey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:key];
}

+ (void)deleteObjectWithKeyArray:(NSArray *)array
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    for (NSString *key in array) {
        [user removeObjectForKey:key];
    }
}

+ (NSString *)getStringWithKey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *object = [user objectForKey:key];
    return object;
}

+ (NSInteger)getIntWithKey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger object = [user integerForKey:key];
    return object;
}
+ (NSData*) getDataWithKey:(NSString*) key{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData* object = [user dataForKey:key];
    return object;
    
};
+ (NSMutableArray*) getArrWithKey:(NSString*) key{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray* object = [user objectForKey:key];
    return object;
    
};

@end
