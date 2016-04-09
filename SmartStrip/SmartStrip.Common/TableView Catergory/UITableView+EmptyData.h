//
//  UITableView+EmptyData.h
//  SmartStrip
//
//  Created by john on 16/1/13.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)
/**
 *  tableview的扩展 Catergory 当无数据提示的内容
 *
 *  @param message  所提示的信息
 *  @param rowCount cell的个数
 */
- (void) tableViewShowWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end
