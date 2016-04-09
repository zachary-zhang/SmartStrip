//
//  CurrentNetwork.m
//  SmartStrip
//
//  Created by john on 16/1/14.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "CurrentNetwork.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation CurrentNetwork
/**
 *  获取当前WiFi名称
 *
 *  @return WiFi名称
 */
+(NSString *)generateCurrentNetwork{
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = ( id)CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam));
        if (info && [info count]) { break; }
    }
    NSString* ssid = [info objectForKey:@"SSID"];
    return ssid;
}
+(NSString*)generateCurrentNetworkBSSID
{
    NSString* macIp;
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            macIp = [dict valueForKey:@"BSSID"];
        }
    }
    return macIp;
}
@end
