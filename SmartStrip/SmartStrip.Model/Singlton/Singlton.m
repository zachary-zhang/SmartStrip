//
//  Singlton.m
//  SmartStrip
//
//  Created by john on 16/1/15.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "Singlton.h"

@implementation Singlton
+ (void)saveSettingValue:(NSString *)value forKey:(NSString *)key
{
    NSUserDefaults * s = [NSUserDefaults standardUserDefaults];
    [s setObject:value forKey:key];
    [s synchronize];
}
+ (NSString *)readSettingsByKey:(NSString *)key
{
    NSUserDefaults * s = [NSUserDefaults standardUserDefaults];
    return [s objectForKey:key];
}
+ (BOOL)isNOTStringNullOrWhitespace:(NSString *)value
{
    return ![value isKindOfClass:[NSNull class]] &&
    value != nil &&
    value.length > 0;
}
@end
