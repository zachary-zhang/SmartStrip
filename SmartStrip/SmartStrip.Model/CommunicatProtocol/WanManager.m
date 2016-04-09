//
//  WanManager.m
//  SmartStrip
//
//  Created by john on 16/1/12.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "WanManager.h"
#define P2P_CONTROL_IP @"SHX600.gpsime.net"
#define P2P_CONTROL_PORT 6000
#define OUT_TIME  -1

@implementation WanManager
{
    GCDAsyncSocket *tcpSocket;
    NSInteger index;
    NSTimer *timer;
    BOOL zIsControlOrder;
}

+(WanManager *)shareWanManager
{
    static WanManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WanManager alloc] init];
    });
    return manager;
}

-(void)connetToHost
{
    tcpSocket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError* err;
    [tcpSocket connectToHost:P2P_CONTROL_IP onPort:P2P_CONTROL_PORT error:&err];
  
    
}
/**
 *  心跳包
 */
-(void)keepSocketLinks
{
    [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:nil];
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(writeHeartbeatData) userInfo:nil repeats:YES];
}
-(void)writeHeartbeatData
{
    Byte byte[1]={0x00};
    NSData *Data = [NSData dataWithBytes:byte length:1];
    NSData *heartbeatData = [ControlOlder generateContorlOlderWithCommandID:0 andParameterData:Data];
    [tcpSocket writeData:heartbeatData withTimeout:OUT_TIME tag:200];
}
/**
 *  发送控制命名
 *
 *  @param data <#data description#>
 */
-(void)controllStripWithData:(NSData *)data andIsControlOrder:(BOOL)isControlOrder
{
     [tcpSocket writeData:data withTimeout:OUT_TIME tag:index];
    /**
     *  判断是控制命令 超时处理
     */
    zIsControlOrder = isControlOrder;
    if (zIsControlOrder) {
        [self performSelector:@selector(timeoutControl) withObject:nil afterDelay:5];
    }
}

#pragma mark - 代理方法表示连接成功/失败 回调函数
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"didConnect");
    [tcpSocket readDataWithTimeout:OUT_TIME tag:index];
}

#pragma mark - 消息发送成功 代理函数
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"didWriteSuccess");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    _zSocketBlock(data);
    _zSocketFailureBlock(nil);
    if (zIsControlOrder) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutControl) object:nil];
    }
     [tcpSocket readDataWithTimeout:OUT_TIME tag:tag];
}
-(void)returnData:(SocketBlock)block failure:(SocketFailureBlock)failureBlock
{
    _zSocketBlock = block;
    _zSocketFailureBlock = failureBlock;

}
/**
 *  超时处理
 */
-(void)timeoutControl
{
    _zSocketBlock(nil);
    _zSocketFailureBlock(@"TimeOut");
}
@end
