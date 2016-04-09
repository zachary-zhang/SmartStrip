//
//  ControlOlder.h
//  SmartStrip
//
//  Created by john on 16/1/12.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlOlder : NSObject
/**
 *  生成发送的具体数据
 *
 *  @param commandID 命令ID
 *
 *  @return 
 */
+(NSData *)generateContorlOlderWithCommandID:(int)commandID andParameterData:(NSData *)parameterData;
+(NSData *)loadCurrentStripAddr;
@end
