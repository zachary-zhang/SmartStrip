//
//  Singlton.h
//  SmartStrip
//
//  Created by john on 16/1/15.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singlton : NSObject
+ (void)saveSettingValue:(NSString *)value forKey:(NSString *)key;
+ (NSString *)readSettingsByKey:(NSString *)key;
+ (BOOL)isNOTStringNullOrWhitespace:(NSString *)value;
@end
