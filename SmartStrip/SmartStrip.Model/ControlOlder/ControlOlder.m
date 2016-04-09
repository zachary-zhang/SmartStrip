//
//  ControlOlder.m
//  SmartStrip
//
//  Created by john on 16/1/12.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "ControlOlder.h"

@implementation ControlOlder
/**
 *  拼接控制命令
 */
+(NSData *)generateContorlOlderWithCommandID:(int)commandID andParameterData:(NSData *)parameterData
{
    NSData *controlData;
    //目标地址
    NSData *destAddrData = commandID==0?[ControlOlder loadHeartbeatAddr]:[ControlOlder loadCurrentStripAddr];
    //源地址
    NSData *srcAddrData =[[ControlOlder load:nil] dataUsingEncoding:NSASCIIStringEncoding];
    //数据包内容  parameterData
    
    Byte byte[255];
    /**
     *  Head 2字节
     */
    byte[0]=0x68;
    byte[1]=0x68;
    
    /**
     *  ComCode 2 公司标识
     */
    byte[4] =0x00;
    byte[5] =0x00;
    
    /**
     *  DestAddrLen 目标地址长度 1
     */
    byte[6] =destAddrData.length;
    /**
     *  DestAddr 目标地址 6
     */
    Byte* destAddrByte=(Byte*)[destAddrData bytes];
    memcpy(&byte[7], destAddrByte, 6);
    /**
     *  SrcAddrLen 源地址长度 1
     */
    byte[13] = srcAddrData.length;
    /**
     *  SrcAddr 源地址 36
     */
    Byte* srcAddrByte=(Byte*)[srcAddrData bytes];
    memcpy(&byte[14], srcAddrByte, srcAddrData.length);
    /**
     *  index 包序列号 2
     */
    int index = 3;
    memcpy(&byte[14+srcAddrData.length],&index, 2);
    /**
     *  CMD 命令号 2
     */
    
    memcpy(&byte[16+srcAddrData.length],&commandID, 2);
    /**
     *  dataLen  数据包长度 2
     */
     int dateLen=(int)parameterData.length;
    memcpy(&byte[18+srcAddrData.length],&dateLen, 2);
    /**
     *  data 数据包
     */
    Byte* parameterByte=(Byte*)[parameterData bytes];
    memcpy(&byte[20+srcAddrData.length],parameterByte, dateLen);
    
    /**
     *  checkSum 2
     */
    int checkSum;
    
    /**
     *  footer 0x0d 0x0a
     */
    byte[22+srcAddrData.length+dateLen] = 0x0d;
    byte[23+srcAddrData.length+dateLen] = 0x0a;
    
    int temp1 =byte[18+srcAddrData.length];
    int temp2 =byte[19+srcAddrData.length];
    byte[18+srcAddrData.length] =temp2;
    byte[19+srcAddrData.length] =temp1;
    
    /**
     *  Length 2
     */
    int byteLen =(int)(24+srcAddrData.length+dateLen);
    memcpy(&byte[2],&byteLen, 2);
    
    /**
     *  大小端转化1 ---->length 转化
     */
    Byte newByte1[255];
    memcpy(&newByte1[0], &byte, byteLen);
    byte[2]=newByte1[3];
    byte[3] =newByte1[2];
    
    for (int i=0; i<20+srcAddrData.length+dateLen; i++) {
        checkSum+= byte[i];
    }
    memcpy(&byte[20+srcAddrData.length+dateLen],&checkSum, 2);
   
    /**
     *  大小端转化2 ---->index CMD CheckSum 转化
     */
    Byte newByte2[255];
    memcpy(&newByte2[0], &byte, byteLen);
    //index
    byte[14+srcAddrData.length]=newByte2[15+srcAddrData.length];
    byte[15+srcAddrData.length] =newByte2[14+srcAddrData.length];
    //CMD
    byte[16+srcAddrData.length]=newByte2[17+srcAddrData.length];
    byte[17+srcAddrData.length] =newByte2[16+srcAddrData.length];
    //checkSum
    byte[20+srcAddrData.length+dateLen]=newByte2[21+srcAddrData.length+dateLen];
    byte[21+srcAddrData.length+dateLen] =newByte2[20+srcAddrData.length+dateLen];
    
    controlData=[NSData dataWithBytes:byte length:byteLen];
    NSLog(@"controlData  :%@",controlData);
    
    return controlData;
}
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}
/**
 *  设备唯一标示
 */
+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [ControlOlder getKeychainQuery:@"com.manbu.smartstrip.usernamepassword"];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    NSDictionary *dic =ret ;
    NSData *data = [[dic allValues][0] dataUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"-------%@----%d",ret,(int)data.length);
    return [dic allValues][0];
}
/**
 *  获取插排地址
 */
+(NSData *)loadCurrentStripAddr
{
    Byte testStripAddr[6] ={0x18,0XFE,0X34,0X01,0X12,0XC3};
    NSData *destAddrData = [NSData dataWithBytes:testStripAddr length:6];
    return destAddrData;
}
/**
 *  获取心跳包 服务器地址
 */
+(NSData *)loadHeartbeatAddr
{
    NSString *heartbeatAddr = @"EEEEEE";
    NSData *destAddrData =[heartbeatAddr dataUsingEncoding:NSASCIIStringEncoding];
    return destAddrData;
}
@end
