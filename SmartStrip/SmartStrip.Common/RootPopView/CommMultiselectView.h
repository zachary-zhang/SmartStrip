//
//  CommMultiselectView.h
//  SmartStrip
//
//  Created by john on 16/1/16.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "RootPopView.h"
@protocol CommMultiselectViewDelegate<NSObject>
-(void)didSelectObjectWithArray:(NSArray *)selectArray andTag:(int)tag;
@end
@interface CommMultiselectView : RootPopView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) id<CommMultiselectViewDelegate>delegate;
@property (nonatomic,strong) UITableView *zTableView;

@end
