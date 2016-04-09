//
//  CommAnimationView.m
//  SmartStrip
//
//  Created by john on 16/1/17.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "CommAnimationView.h"

@implementation CommAnimationView
-(void)prepareForContentSubView
{
    contentView.frame = CGRectMake(zScreenWidth/2-50, zScreenHeightNoNavi/2-50, 100, 100);
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds =YES;
    contentView.backgroundColor = [UIColor blackColor];
    
    loadingView = [[BALoadingView alloc] initWithFrame:contentView.bounds];
    loadingView.segmentColor =[UIColor whiteColor];
    [loadingView initialize];
    [loadingView startAnimation:BACircleAnimationFullCircle];
    [contentView addSubview:loadingView];
}
@end
