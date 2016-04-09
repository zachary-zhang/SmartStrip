//
//  CurrentNetwork.h
//  SmartStrip
//
//  Created by john on 16/1/14.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentNetwork : NSObject
/**
 *  获取当前WiFi名称
 *
 *  @return WiFi名称
 */
+(NSString *)generateCurrentNetwork;
+(NSString*)generateCurrentNetworkBSSID;
@end
