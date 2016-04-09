//
//  WanManager.h
//  SmartStrip
//
//  Created by john on 16/1/12.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

typedef void (^SocketBlock)(NSData *blockData) ;
typedef void(^SocketFailureBlock) (NSString *blockString);

@interface WanManager : NSObject<GCDAsyncSocketDelegate>
@property(nonatomic,strong)SocketBlock zSocketBlock;
@property(nonatomic,strong)SocketFailureBlock zSocketFailureBlock;
+(WanManager *)shareWanManager;
-(void)connetToHost;
-(void)keepSocketLinks;
-(void)controllStripWithData:(NSData *)data andIsControlOrder:(BOOL)isControlOrder;
-(void)returnData:(SocketBlock)block  failure:(SocketFailureBlock)failureBlock;
@end
